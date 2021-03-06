port module App.Update
    exposing
        ( Msg(..)
        , updateWithMap
        , location2messages
        , delta2hash
        , init
        , initModel
        , Flags
        , online
        , subscriptions
        )

import App.Model exposing (..)
import App.Routing
import Geolocation
import Navigation
import Dict exposing (Dict)
import RouteUrl
import Task
import Pages.Admin.Update
import Pouchdb
import App.Decoder
import Json.Decode
import Location exposing (Location)
import Leaflet
import Errors
import Analytics
import App.Map
import Campsite exposing (Campsite)


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
    | SyncPaused Pouchdb.SyncPaused
    | SyncActive {}
    | ToggleStarCampsite String
    | Online Bool
    | ErrorsMsg Errors.Msg


type alias Flags =
    { version : String
    , standalone : Bool
    , starredCampsites : Maybe (List String)
    , online : Bool
    , location : Maybe Location
    , docs : List Json.Decode.Value
    , sequence : Int
    , limitList : Bool
    }


decodeInitialCampsites : List Json.Decode.Value -> List Campsite
decodeInitialCampsites docs =
    -- We're just going to ignore any errors that we encounter while we decode
    List.map (Json.Decode.decodeValue App.Decoder.campsite) docs
        |> List.filterMap Result.toMaybe


initModel : Flags -> Model
initModel flags =
    { campsites =
        decodeInitialCampsites flags.docs
            |> List.map (\c -> ( c.id, c ))
            |> Dict.fromList
    , location = flags.location
    , errors = Errors.initModel
    , page =
        CampsitesPage List
        {- By setting the initial page to the home page on a first load the
           previous page will be set to the home page. This gives us a nice
           sensible default for the back button
        -}
    , previousPages = []
    , standalone = flags.standalone
    , version = flags.version
    , starredCampsites = Maybe.withDefault [] flags.starredCampsites
    , online = flags.online
    , sequence = flags.sequence
    , synching = True
    , firstPageLoaded = False
    , limitList = flags.limitList
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        model =
            initModel flags
    in
        ( model
          -- On startup immediately try to get the location
        , Cmd.batch
            [ Task.attempt UpdateLocation Geolocation.now
            , Pouchdb.changes
                { live = True
                , include_docs = True
                , return_docs = False
                , since = model.sequence
                }
            , Pouchdb.sync
                { live = True
                , retry = True
                }
              -- We need to tell the map to add the campsites
            , Leaflet.mapCommand
                (App.Map.map { model | campsites = Dict.empty })
                (App.Map.map model)
            ]
        )


updateWithMap : Msg -> Model -> ( Model, Cmd Msg )
updateWithMap msg model =
    let
        ( newModel, cmd ) =
            update msg model
    in
        ( newModel
        , Cmd.batch
            [ cmd
            , Leaflet.mapCommand (App.Map.map model) (App.Map.map newModel)
            ]
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateLocation (Err error) ->
            ( { model
                | errors =
                    Errors.add (formatGeolocationError error) model.errors
              }
            , Cmd.none
            )

        UpdateLocation (Ok location) ->
            let
                l =
                    Location location.latitude location.longitude
            in
                ( { model | location = Just l }, storeLocation l )

        ChangePage page ->
            let
                newPage =
                    if page == CampsitesPage List && (Dict.isEmpty model.campsites) then
                        TourPage Start
                    else if model.standalone && (not model.firstPageLoaded) then
                        CampsitesPage List
                    else
                        page
            in
                ( { model
                    | page = newPage
                    , previousPages = model.page :: model.previousPages
                    , firstPageLoaded = True
                  }
                , Analytics.screenView (Analytics.name newPage)
                )

        PageBack ->
            let
                newPage =
                    Maybe.withDefault (CampsitesPage List)
                        (List.head model.previousPages)
            in
                ( { model
                    | page = newPage
                    , previousPages =
                        Maybe.withDefault []
                            (List.tail model.previousPages)
                  }
                , Analytics.screenView (Analytics.name newPage)
                )

        AdminMsg msg ->
            let
                ( updatedAdminModel, adminCmd ) =
                    Pages.Admin.Update.update msg model
            in
                ( updatedAdminModel, Cmd.map AdminMsg adminCmd )

        ChangeSuccess change ->
            -- TODO: Need to think how to handle deleted documents. Is this
            -- something we actually need to handle?
            let
                o =
                    Json.Decode.decodeValue App.Decoder.campsite change.doc
            in
                case o of
                    Ok campsite ->
                        let
                            newCampsites =
                                Dict.insert campsite.id campsite model.campsites
                        in
                            ( { model
                                | campsites = newCampsites
                                , sequence = change.seq
                              }
                            , Cmd.none
                            )

                    Err _ ->
                        -- TODO: Show these errors to the user rather than silently ignore
                        ( model, Cmd.none )

        ChangeComplete info ->
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

        ErrorsMsg msg ->
            ( { model | errors = Errors.update msg model.errors }, Cmd.none )

        SyncPaused p ->
            ( { model | synching = False }, Cmd.none )

        SyncActive _ ->
            ( { model | synching = True }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Pouchdb.changeSuccess ChangeSuccess
        , Pouchdb.changeComplete ChangeComplete
        , Pouchdb.syncPaused SyncPaused
        , Pouchdb.syncActive SyncActive
        , Leaflet.markerClicked (\id -> ChangePage (CampsitePage id))
        , Sub.map AdminMsg (Pages.Admin.Update.subscriptions model)
        , online Online
        ]


formatGeolocationError : Geolocation.Error -> String
formatGeolocationError error =
    case error of
        Geolocation.PermissionDenied text ->
            "Please allow access to your location. We only use it to show campsites near you. It's never shared."

        Geolocation.LocationUnavailable text ->
            "Location unavailable: " ++ text

        Geolocation.Timeout text ->
            "Timeout: " ++ text


location2messages : Navigation.Location -> List Msg
location2messages location =
    [ ChangePage (App.Routing.location2page location) ]


delta2hash : Model -> Model -> Maybe RouteUrl.UrlChange
delta2hash previous current =
    Just (RouteUrl.UrlChange RouteUrl.NewEntry (App.Routing.page2url current.page))
