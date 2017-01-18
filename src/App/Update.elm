module App.Update
    exposing
        ( Msg(..)
        , update
        , page2url
        )

import App.Model exposing (..)
import Http
import Geolocation
import Navigation
import Dict exposing (Dict)


type Msg
    = NewCampsite Campsite
    | UpdateLocation (Result Geolocation.Error Geolocation.Location)
    | NewData (Result Http.Error { parks : List Park, campsites : List Campsite })
    | ChangePage Page
    | PageBack


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewCampsite campsite ->
            ( { model | campsites = campsite :: model.campsites }, Cmd.none )

        UpdateLocation (Err error) ->
            ( { model | error = Just error }, Cmd.none )

        UpdateLocation (Ok location) ->
            ( { model | location = Just (Location location.latitude location.longitude) }, Cmd.none )

        NewData (Err error) ->
            -- TODO: Make it show the error. For the time being does nothing
            ( model, Cmd.none )

        NewData (Ok data) ->
            -- Replace the current campsites with the new ones
            ( { model | campsites = data.campsites, parks = (transformParks data.parks) }, Cmd.none )

        ChangePage page ->
            ( { model | page = page }, Cmd.none )

        PageBack ->
            ( model, Navigation.back 1 )


transformParks : List Park -> Dict Int Park
transformParks parks =
    Dict.fromList (List.map (\park -> ( park.id, park )) parks)


page2url : Page -> String
page2url page =
    case page of
        Campsites ->
            "#/campsites"

        About ->
            "#/about"
