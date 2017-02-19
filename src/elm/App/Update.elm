port module App.Update
    exposing
        ( Msg(..)
        , updateWithMap
        , location2messages
        , delta2hash
        , page2url
        , init
        , Flags
        , online
        )

import App.Model exposing (..)
import Geolocation
import Navigation
import Dict exposing (Dict)
import RouteUrl
import RouteUrl.Builder
import Task
import Pages.Admin.Model
import Pages.Admin.Update
import Pouchdb
import App.NewDecoder
import Json.Decode
import Campsite exposing (Campsite)
import Location exposing (Location)
import Leaflet


-- TODO: We should probably move this port into another module


port storeStarredCampsites : List String -> Cmd msg


port storeLocation : Location -> Cmd msg


port online : (Bool -> msg) -> Sub msg


type Msg
    = UpdateLocation (Result Geolocation.Error Geolocation.Location)
    | ChangePage Page
    | PageBack
    | AdminMsg Pages.Admin.Update.Msg
    | ChangeSuccess Pouchdb.ChangeSuccess
    | ChangeComplete Pouchdb.ChangeComplete
    | ToggleStarCampsite String
    | Online Bool


type alias Flags =
    { version : String
    , standalone : Bool
    , starredCampsites : Maybe (List String)
    , online : Bool
    , location : Maybe Location
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { campsites = Dict.empty
      , location = flags.location
      , errors = []
      , page = CampsitesPage List
      , adminModel = Pages.Admin.Model.initModel
      , standalone = flags.standalone
      , version = flags.version
      , starredCampsites = Maybe.withDefault [] flags.starredCampsites
      , online = flags.online
      , sequence = 0
      }
      -- On startup immediately try to get the location
    , Cmd.batch
        [ Task.attempt UpdateLocation Geolocation.now
        , Pouchdb.changes { live = False, include_docs = True, return_docs = False, since = 0 }
        ]
    )


updateWithMap : Msg -> Model -> ( Model, Cmd Msg )
updateWithMap msg model =
    let
        ( newModel, cmd ) =
            update msg model
    in
        ( newModel, Cmd.batch [ cmd, Leaflet.mapCommand (map model) (map newModel) ] )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateLocation (Err error) ->
            ( { model | errors = ((formatGeolocationError error) :: model.errors) }, Cmd.none )

        UpdateLocation (Ok location) ->
            let
                l =
                    Location location.latitude location.longitude
            in
                ( { model | location = Just l }, storeLocation l )

        ChangePage page ->
            ( { model | page = page }, Cmd.none )

        PageBack ->
            ( model, Navigation.back 1 )

        AdminMsg msg ->
            let
                ( updatedAdminModel, adminCmd ) =
                    Pages.Admin.Update.update msg model.adminModel
            in
                ( { model | adminModel = updatedAdminModel }, Cmd.map AdminMsg adminCmd )

        ChangeSuccess change ->
            -- TODO: Need to think how to handle deleted documents. Is this
            -- something we actually need to handle?
            let
                sequence =
                    max model.sequence change.seq

                o =
                    Json.Decode.decodeValue App.NewDecoder.campsite change.doc
            in
                case o of
                    Ok campsite ->
                        let
                            newCampsites =
                                Dict.insert campsite.id campsite model.campsites

                            admin =
                                model.adminModel
                        in
                            -- Setting model in a child model at the same time.
                            -- Very hokey but this is temporary
                            ( { model
                                | campsites = newCampsites
                                , adminModel = { admin | campsites = newCampsites }
                                , sequence = sequence
                              }
                            , Cmd.none
                            )

                    Err _ ->
                        -- TODO: Show these errors to the user rather than silently ignore
                        ( model, Cmd.none )

        ChangeComplete info ->
            -- Now request the changes continuously
            ( model
            , Pouchdb.changes
                { live = True
                , include_docs = True
                , return_docs = False
                , since = model.sequence
                }
            )

        ToggleStarCampsite id ->
            let
                starred =
                    if List.member id model.starredCampsites then
                        List.filter (\i -> i /= id) model.starredCampsites
                    else
                        id :: model.starredCampsites
            in
                ( { model | starredCampsites = starred }, storeStarredCampsites starred )

        Online online ->
            ( { model | online = online }, Cmd.none )


map : Model -> Leaflet.Map
map model =
    { visible = (model.page == CampsitesPage Map)
    , center =
        Maybe.withDefault
            -- Starting point is 32° 09' 48" South, 147° 01' 00" East which is "centre" of NSW
            (Location -32.163333333333334 147.01666666666668)
            model.location
    , markers = Dict.fromList (List.map (\marker -> ( marker.id, marker )) (allMarkers model))
    }


allMarkers : Model -> List Leaflet.Marker
allMarkers model =
    List.filterMap
        identity
        (List.map markerForCampsite (Dict.values model.campsites))


markerForCampsite : Campsite -> Maybe Leaflet.Marker
markerForCampsite campsite =
    Maybe.map
        (\location ->
            Leaflet.Marker campsite.id
                location
                -- Wish this could come from a view
                ("<a href=\"" ++ (page2url (CampsitePage campsite.id)) ++ "\"><div class=\"campsite\"><div class=\"name\">" ++ (Campsite.shortenName campsite.name) ++ "</div><div class=\"park\">" ++ (Campsite.shortenName campsite.park.longName) ++ "</div></div></a>")
        )
        campsite.location


formatGeolocationError : Geolocation.Error -> String
formatGeolocationError error =
    case error of
        Geolocation.PermissionDenied text ->
            "Permission denied: " ++ text

        Geolocation.LocationUnavailable text ->
            "Location unavailable: " ++ text

        Geolocation.Timeout text ->
            "Timeout: " ++ text


transformCampsites : List Campsite -> Dict String Campsite
transformCampsites campsites =
    -- TODO: Would be nicer if this logic was part of the decoder
    Dict.fromList (List.map (\campsite -> ( campsite.id, campsite )) campsites)


location2messages : Navigation.Location -> List Msg
location2messages location =
    let
        builder =
            (RouteUrl.Builder.fromHash location.href)
    in
        case RouteUrl.Builder.path builder of
            [ "campsites" ] ->
                case Dict.get "type" (RouteUrl.Builder.query builder) of
                    Just "map" ->
                        [ ChangePage (CampsitesPage Map) ]

                    Just _ ->
                        [ ChangePage (CampsitesPage List) ]

                    Nothing ->
                        [ ChangePage (CampsitesPage List) ]

            [ "campsites", id ] ->
                [ ChangePage (CampsitePage id) ]

            [ "about" ] ->
                [ ChangePage AboutPage ]

            [ "admin" ] ->
                [ ChangePage AdminPage ]

            id :: _ ->
                [ ChangePage UnknownPage ]

            -- Default route
            [] ->
                [ ChangePage (CampsitesPage List) ]


delta2hash : Model -> Model -> Maybe RouteUrl.UrlChange
delta2hash previous current =
    Just (RouteUrl.UrlChange RouteUrl.NewEntry (page2url current.page))


page2url : Page -> String
page2url page =
    case page of
        CampsitesPage List ->
            "#/campsites?type=list"

        CampsitesPage Map ->
            "#/campsites?type=map"

        CampsitePage id ->
            "#/campsites/" ++ id

        AboutPage ->
            "#/about"

        AdminPage ->
            "#/admin"

        UnknownPage ->
            "#/404"
