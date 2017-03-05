module App.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import App.Update exposing (..)
import App.Model exposing (..)
import Pages.About.View
import Pages.Tour.View
import Pages.Campsites.View
import Pages.Campsite.View
import Pages.Admin.View
import Dict exposing (Dict)
import App.ViewHelpers


view : Model -> Html Msg
view model =
    div
        [ id "app"
        , class
            (if model.standalone then
                "fullscreen"
             else
                ""
            )
        ]
        [ case model.page of
            CampsitesPage displayType ->
                Pages.Campsites.View.view
                    { campsites = (Dict.values model.campsites)
                    , location = model.location
                    , errors = model.errors
                    , starredCampsites = model.starredCampsites
                    , displayType = displayType
                    , synching = model.synching
                    }

            CampsitePage id ->
                case Dict.get id model.campsites of
                    Just campsite ->
                        Pages.Campsite.View.view
                            { campsite = campsite
                            , starred = List.member id model.starredCampsites
                            , online = model.online
                            }

                    Nothing ->
                        App.ViewHelpers.view404

            AboutPage ->
                Pages.About.View.view model.version

            TourPage id ->
                Pages.Tour.View.view id (not (Dict.isEmpty model.campsites))

            AdminPage ->
                Html.map AdminMsg (Pages.Admin.View.view model)

            UnknownPage ->
                App.ViewHelpers.view404
        ]
