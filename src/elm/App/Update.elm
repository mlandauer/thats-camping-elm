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
import App.NewDecoder
import Json.Decode
import Location exposing (Location)
import Leaflet
import Errors
import Analytics
import App.Map


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
    }


initModel : Flags -> Model
initModel flags =
    { campsites = Dict.empty
    , location = flags.location
    , errors = Errors.initModel
    , page = CampsitesPage List
    , standalone = flags.standalone
    , version = flags.version
    , starredCampsites = Maybe.withDefault [] flags.starredCampsites
    , online = flags.online
    , sequence = 0
    , synching = False
    , firstPageLoaded = False
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initModel flags
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
                    if model.standalone && (not model.firstPageLoaded) then
                        CampsitesPage List
                    else
                        page
            in
                ( { model | page = newPage, firstPageLoaded = True }, Analytics.screenView (Analytics.name newPage) )

        PageBack ->
            ( model, Navigation.back 1 )

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
                        in
                            ( { model
                                | campsites = newCampsites
                                , sequence = sequence
                              }
                            , Cmd.none
                            )

                    Err _ ->
                        -- TODO: Show these errors to the user rather than silently ignore
                        ( model, Cmd.none )

        ChangeComplete info ->
            let
                no_campsites_loaded =
                    Debug.log "no_campsites_loaded" (Dict.size model.campsites)
            in
                -- Now request the changes continuously
                ( if no_campsites_loaded == 0 then
                    { model | page = TourPage Start, synching = True }
                  else
                    { model | synching = True }
                , Cmd.batch
                    [ Pouchdb.sync
                        { live = True
                        , retry = True
                        }
                    , Pouchdb.changes
                        { live = True
                        , include_docs = True
                        , return_docs = False
                        , since = model.sequence
                        }
                    ]
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
