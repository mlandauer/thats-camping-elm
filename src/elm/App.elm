module App exposing (..)

import RouteUrl
import App.Model exposing (..)
import App.Update exposing (..)
import App.View exposing (..)
import Pages.Admin.Update
import Pouchdb


main : RouteUrl.RouteUrlProgram Flags Model Msg
main =
    RouteUrl.programWithFlags
        { delta2url = delta2hash
        , location2messages = location2messages
        , init = init
        , view = view
        , update = updateWithMarkers
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Pouchdb.change Change
        , Sub.map AdminMsg (Pages.Admin.Update.subscriptions model.adminModel)
        , online Online
        ]
