module App.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import App.Update exposing (..)
import App.Model exposing (..)
import Pages.About.View
import Pages.Campsites.View
import Pages.Campsite.View
import Dict


view : Model -> Html Msg
view model =
    div [ id "app" ]
        [ case model.page of
            Campsites ->
                Pages.Campsites.View.view
                    { campsites = (Dict.values model.campsites)
                    , parks = model.parks
                    , location = model.location
                    , error = model.error
                    }

            CampsitePage id ->
                case Dict.get id model.campsites of
                    Just campsite ->
                        Pages.Campsite.View.view { campsite = campsite, park = (Dict.get campsite.parkId model.parks) }

                    Nothing ->
                        view404

            About ->
                Pages.About.View.view

            UnknownPage ->
                view404
        ]


view404 : Html Msg
view404 =
    -- TODO: Make this page less ugly
    p [] [ text "This is a 404" ]
