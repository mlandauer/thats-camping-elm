module App.View exposing (view)

import Html exposing (..)
import App.Update exposing (..)
import App.Model exposing (..)
import Pages.About.View
import Pages.Campsites.View
import Pages.Campsite.View


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

        CampsitePage id ->
            Pages.Campsite.View.view

        About ->
            Pages.About.View.view

        UnknownPage ->
            -- TODO: Make this page less ugly
            p [] [ text "This is a 404" ]
