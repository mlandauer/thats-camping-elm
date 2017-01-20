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


type Msg
    = UpdateLocation (Result Geolocation.Error Geolocation.Location)
    | NewData (Result Http.Error { parks : List Park, campsites : List Campsite })
    | ChangePage Page
    | PageBack


init : ( Model, Cmd Msg )
init =
    ( { campsites = Dict.empty, parks = Dict.empty, location = Nothing, error = Nothing, page = Campsites }
      -- On startup immediately try to get the location and the campsite data
    , Cmd.batch [ Task.attempt UpdateLocation Geolocation.now, syncData ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateLocation (Err error) ->
            ( { model | error = Just error }, Cmd.none )

        UpdateLocation (Ok location) ->
            ( { model | location = Just (Location location.latitude location.longitude) }, Cmd.none )

        NewData (Err error) ->
            -- TODO: Make it show the error. For the time being does nothing
            ( model, Cmd.none )

        NewData (Ok data) ->
            -- Replace the current campsites with the new ones
            ( { model | campsites = (transformCampsites data.campsites), parks = (transformParks data.parks) }, Cmd.none )

        ChangePage page ->
            ( { model | page = page }, Cmd.none )

        PageBack ->
            ( model, Navigation.back 1 )


transformParks : List Park -> Dict Int Park
transformParks parks =
    Dict.fromList (List.map (\park -> ( park.id, park )) parks)


transformCampsites : List Campsite -> Dict Int Campsite
transformCampsites campsites =
    Dict.fromList (List.map (\campsite -> ( campsite.id, campsite )) campsites)


location2messages : Navigation.Location -> List Msg
location2messages location =
    case RouteUrl.Builder.path (RouteUrl.Builder.fromHash location.href) of
        [ "campsites" ] ->
            [ ChangePage Campsites ]

        [ "campsites", id ] ->
            case String.toInt id of
                Ok id ->
                    [ ChangePage (CampsitePage id) ]

                Err _ ->
                    [ ChangePage UnknownPage ]

        [ "about" ] ->
            [ ChangePage About ]

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
            "#/campsites/" ++ toString id

        About ->
            "#/about"

        UnknownPage ->
            "#/404"


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
