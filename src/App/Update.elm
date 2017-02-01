module App.Update
    exposing
        ( Msg(..)
        , update
        , location2messages
        , delta2hash
        , page2url
        , init
        )

import App.Model exposing (..)
import App.Decoder exposing (parksAndCampsites)
import Http
import Geolocation
import Navigation
import Dict exposing (Dict)
import RouteUrl
import RouteUrl.Builder
import Task
import Pages.Admin.Update
import Pouchdb
import App.NewDecoder
import Json.Decode
import Standalone


type Msg
    = UpdateLocation (Result Geolocation.Error Geolocation.Location)
    | ChangePage Page
    | PageBack
    | AdminMsg Pages.Admin.Update.Msg
    | Change Pouchdb.Change
    | Standalone Bool


init : ( Model, Cmd Msg )
init =
    ( { campsites = Dict.empty
      , parks = Dict.empty
      , location = Nothing
      , errors = []
      , page = Campsites
      , adminModel = Pages.Admin.Update.initModel
      }
      -- On startup immediately try to get the location
    , Cmd.batch
        [ Task.attempt UpdateLocation Geolocation.now
        , Task.perform Standalone Standalone.standalone
        ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateLocation (Err error) ->
            ( { model | errors = ((formatGeolocationError error) :: model.errors) }, Cmd.none )

        UpdateLocation (Ok location) ->
            ( { model | location = Just (Location location.latitude location.longitude) }, Cmd.none )

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
                        ( { model | campsites = (Dict.insert campsite.id campsite model.campsites) }, Cmd.none )

                    Err _ ->
                        ( model, Cmd.none )

        Standalone standalone ->
            let
                foo =
                    Debug.log "standalone" standalone
            in
                -- TODO: Make this actually do something
                ( { model | errors = ("standalone2: " ++ toString standalone) :: model.errors }, Cmd.none )


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
    case RouteUrl.Builder.path (RouteUrl.Builder.fromHash location.href) of
        [ "campsites" ] ->
            [ ChangePage Campsites ]

        [ "campsites", id ] ->
            [ ChangePage (CampsitePage id) ]

        [ "parks", id ] ->
            [ ChangePage (ParkPage id) ]

        [ "about" ] ->
            [ ChangePage About ]

        [ "admin" ] ->
            [ ChangePage AdminPage ]

        id :: _ ->
            [ ChangePage UnknownPage ]

        -- Default route
        [] ->
            [ ChangePage Campsites ]


delta2hash : Model -> Model -> Maybe RouteUrl.UrlChange
delta2hash previous current =
    Just (RouteUrl.UrlChange RouteUrl.NewEntry (page2url current.page))


page2url : Page -> String
page2url page =
    case page of
        Campsites ->
            "#/campsites"

        CampsitePage id ->
            "#/campsites/" ++ id

        ParkPage id ->
            "#/parks/" ++ id

        About ->
            "#/about"

        AdminPage ->
            "#/admin"

        UnknownPage ->
            "#/404"
