module App exposing (..)

import RouteUrl
import App.Model exposing (..)
import App.Update exposing (..)
import App.View exposing (..)


main =
    RouteUrl.program
        { delta2url = delta2hash
        , location2messages = location2messages
        , init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
