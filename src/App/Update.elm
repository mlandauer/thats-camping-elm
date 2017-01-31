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


type Msg
    = UpdateLocation (Result Geolocation.Error Geolocation.Location)
    | NewData (Result Http.Error { parks : List Park, campsites : List Campsite })
    | ChangePage Page
    | PageBack
    | AdminMsg Pages.Admin.Update.Msg


init : ( Model, Cmd Msg )
init =
    ( { campsites = Dict.empty
      , parks = Dict.empty
      , location = Nothing
      , errors = []
      , page = Campsites
      , adminModel = Pages.Admin.Update.initModel
      }
      -- On startup immediately try to get the location and the campsite data
    , Cmd.batch [ Task.attempt UpdateLocation Geolocation.now, syncData ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateLocation (Err error) ->
            ( { model | errors = ((formatGeolocationError error) :: model.errors) }, Cmd.none )

        UpdateLocation (Ok location) ->
            ( { model | location = Just (Location location.latitude location.longitude) }, Cmd.none )

        NewData (Err error) ->
            ( { model | errors = ((formatHttpError error) :: model.errors) }, Cmd.none )

        NewData (Ok data) ->
            -- Replace the current campsites with the new ones
            ( { model | campsites = (transformCampsites data.campsites), parks = (transformParks data.parks) }, Cmd.none )

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


formatGeolocationError : Geolocation.Error -> String
formatGeolocationError error =
    case error of
        Geolocation.PermissionDenied text ->
            "Permission denied: " ++ text

        Geolocation.LocationUnavailable text ->
            "Location unavailable: " ++ text

        Geolocation.Timeout text ->
            "Timeout: " ++ text


formatHttpError : Http.Error -> String
formatHttpError error =
    case error of
        Http.BadUrl text ->
            "Bad URL: " ++ text

        Http.Timeout ->
            "Timeout"

        Http.NetworkError ->
            "Network Error"

        Http.BadStatus response ->
            "Bad Status"

        Http.BadPayload text response ->
            "Bad payload: " ++ text


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


syncData : Cmd Msg
syncData =
    let
        -- Just load the json data from github for the time being. Should do something
        -- more sensible than this in the longer term but it's good enough for now
        url =
            "https://raw.githubusercontent.com/mlandauer/thats-camping-react/master/data.json"

        request =
            Http.get url App.Decoder.parksAndCampsites
    in
        Http.send NewData request
