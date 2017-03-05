module App exposing (..)

import RouteUrl
import App.Model
import App.Update
import App.View


main : RouteUrl.RouteUrlProgram App.Update.Flags App.Model.Model App.Update.Msg
main =
    RouteUrl.programWithFlags
        { delta2url = App.Update.delta2hash
        , location2messages = App.Update.location2messages
        , init = App.Update.init
        , view = App.View.view
        , update = App.Update.updateWithMap
        , subscriptions = App.Update.subscriptions
        }
