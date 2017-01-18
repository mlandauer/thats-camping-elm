module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Geolocation
import Task
import Location
import Http
import Decoder
import Dict exposing (Dict)
import RouteUrl
import Pages.About.View
import Pages.Campsites.View
import App.Model exposing (..)
import App.Update exposing (..)
import App.View exposing (..)


init : ( Model, Cmd Msg )
init =
    ( { campsites = [], parks = Dict.empty, location = Nothing, error = Nothing, page = Campsites }
      -- On startup immediately try to get the location and the campsite data
    , Cmd.batch [ Task.attempt UpdateLocation Geolocation.now, syncData ]
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main =
    RouteUrl.program { delta2url = delta2hash, location2messages = hash2messages, init = init, view = view, update = update, subscriptions = subscriptions }


view : Model -> Html Msg
view model =
    case model.page of
        Campsites ->
            Pages.Campsites.View.view model

        About ->
            Pages.About.View.view


syncData =
    let
        -- Just load the json data from github for the time being. Should do something
        -- more sensible than this in the longer term but it's good enough for now
        url =
            "https://raw.githubusercontent.com/mlandauer/thats-camping-react/master/data.json"

        request =
            Http.get url Decoder.parksAndCampsites
    in
        Http.send NewData request
