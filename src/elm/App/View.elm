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
        [ nav model
        , (case model.page of
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
          )
        ]


nav : Model -> Html Msg
nav model =
    case model.page of
        CampsitesPage displayType ->
            if Dict.isEmpty model.campsites then
                App.ViewHelpers.navBar "" { back = Nothing, about = Nothing }
            else
                App.ViewHelpers.navBar "Camping near you"
                    { back = Nothing, about = Just (ChangePage AboutPage) }

        CampsitePage id ->
            case Dict.get id model.campsites of
                Just campsite ->
                    App.ViewHelpers.navBar campsite.name.short
                        { back = Just PageBack, about = Nothing }

                Nothing ->
                    App.ViewHelpers.navBar "404"
                        { back = Just PageBack, about = Nothing }

        AboutPage ->
            App.ViewHelpers.navBar "About" { back = Just PageBack, about = Nothing }

        TourPage id ->
            App.ViewHelpers.navBar ""
                { back =
                    if (id /= Start) then
                        Just PageBack
                    else
                        Nothing
                , about = Nothing
                }

        AdminPage ->
            App.ViewHelpers.navBar "Database admin"
                { back = Just (ChangePage (CampsitesPage List))
                , about = Nothing
                }

        UnknownPage ->
            App.ViewHelpers.navBar "404" { back = Nothing, about = Nothing }
