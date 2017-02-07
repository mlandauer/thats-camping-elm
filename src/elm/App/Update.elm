port module App.Update
    exposing
        ( Msg(..)
        , update
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
import Park exposing (Park)
import Location exposing (Location)
import Leaflet exposing (setMapMarker, mapVisibility, panMapTo, Marker)


-- TODO: We should probably move this port into another module


port storeStarredCampsites : List String -> Cmd msg


port online : (Bool -> msg) -> Sub msg


type Msg
    = UpdateLocation (Result Geolocation.Error Geolocation.Location)
    | ChangePage Page
    | PageBack
    | AdminMsg Pages.Admin.Update.Msg
    | Change Pouchdb.Change
    | ToggleStarCampsite String
    | Online Bool


type alias Flags =
    { version : String
    , standalone : Bool
    , starredCampsites : Maybe (List String)
    , online : Bool
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { campsites = Dict.empty
      , parks = Dict.empty
      , location = Nothing
      , errors = []
      , page = CampsitesPage List
      , adminModel = Pages.Admin.Model.initModel
      , standalone = flags.standalone
      , version = flags.version
      , starredCampsites = Maybe.withDefault [] flags.starredCampsites
      , online = flags.online
      }
      -- On startup immediately try to get the location
    , Task.attempt UpdateLocation Geolocation.now
    )


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
                ( { model | location = Just l }, panMapTo l )

        ChangePage page ->
            ( { model | page = page }, mapVisibility (page == CampsitesPage Map) )

        PageBack ->
            ( model, Navigation.back 1 )

        AdminMsg msg ->
            let
                ( updatedAdminModel, adminCmd ) =
                    Pages.Admin.Update.update msg model.adminModel
            in
                ( { model | adminModel = updatedAdminModel }, Cmd.map AdminMsg adminCmd )

        Change change ->
            -- TODO: Need to think how to handle deleted documents. Is this
            -- something we actually need to handle?
            let
                o =
                    Json.Decode.decodeValue App.NewDecoder.parkOrCampsite change.doc
            in
                case o of
                    Ok (App.NewDecoder.Park park) ->
                        ( { model | parks = (Dict.insert park.id park model.parks) }, Cmd.none )

                    Ok (App.NewDecoder.Campsite campsite) ->
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
                              }
                            , -- Only set a marker when the campsite has location data
                              case markerForCampsite campsite of
                                Just marker ->
                                    setMapMarker marker

                                Nothing ->
                                    Cmd.none
                            )

                    Err _ ->
                        ( model, Cmd.none )

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


markerForCampsite : Campsite -> Maybe Marker
markerForCampsite campsite =
    Maybe.map
        (\location ->
            Marker campsite.id
                location
                -- Wish this could come from a view
                ("<a href=\"" ++ (page2url (CampsitePage campsite.id)) ++ "\">" ++ campsite.shortName ++ "</a>")
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


transformParks : List Park -> Dict String Park
transformParks parks =
    Dict.fromList (List.map (\park -> ( park.id, park )) parks)


transformCampsites : List Campsite -> Dict String Campsite
transformCampsites campsites =
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

            [ "parks", id ] ->
                [ ChangePage (ParkPage id) ]

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

        ParkPage id ->
            "#/parks/" ++ id

        AboutPage ->
            "#/about"

        AdminPage ->
            "#/admin"

        UnknownPage ->
            "#/404"
