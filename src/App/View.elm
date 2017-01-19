module App.View exposing (view)

import Html exposing (..)
import App.Update exposing (..)
import App.Model exposing (..)
import Pages.About.View
import Pages.Campsites.View


view : Model -> Html Msg
view model =
    case model.page of
        Campsites ->
            Pages.Campsites.View.view
                { campsites = model.campsites
                , parks = model.parks
                , location = model.location
                , error = model.error
                }

        About ->
            Pages.About.View.view
