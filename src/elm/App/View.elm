module App.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
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
        [ navView model
        , (case model.page of
            Nothing ->
                text ""

            Just (CampsitesPage displayType) ->
                Pages.Campsites.View.view
                    { campsites = (Dict.values model.campsites)
                    , location = model.location
                    , errors = model.errors
                    , starredCampsites = model.starredCampsites
                    , displayType = displayType
                    , synching = model.synching
                    }

            Just (CampsitePage id) ->
                case Dict.get id model.campsites of
                    Just campsite ->
                        Pages.Campsite.View.view
                            { campsite = campsite
                            , starred = List.member id model.starredCampsites
                            , online = model.online
                            }

                    Nothing ->
                        App.ViewHelpers.view404

            Just AboutPage ->
                Pages.About.View.view model.version

            Just (TourPage id) ->
                Pages.Tour.View.view id (not (Dict.isEmpty model.campsites))

            Just AdminPage ->
                Html.map AdminMsg (Pages.Admin.View.view model)

            Just UnknownPage ->
                App.ViewHelpers.view404
          )
        ]


navView : Model -> Html Msg
navView model =
    let
        -- If there is no previous page just go to the home page
        backPage =
            Maybe.withDefault (CampsitesPage List) model.previousPage
    in
        case model.page of
            Nothing ->
                text ""

            Just (CampsitesPage displayType) ->
                if Dict.isEmpty model.campsites then
                    navBar "" { back = Nothing, about = False }
                else
                    navBar "Camping near you" { back = Nothing, about = True }

            Just (CampsitePage id) ->
                case Dict.get id model.campsites of
                    Just campsite ->
                        navBar campsite.name.short { back = Just backPage, about = True }

                    Nothing ->
                        navBar "404" { back = Just backPage, about = False }

            Just AboutPage ->
                navBar "About" { back = Just backPage, about = False }

            Just (TourPage id) ->
                navBar ""
                    { back =
                        (if id /= Start then
                            Just backPage
                         else
                            Nothing
                        )
                    , about = False
                    }

            Just AdminPage ->
                navBar "Database admin" { back = Just backPage, about = False }

            Just UnknownPage ->
                navBar "404" { back = Just backPage, about = False }


navBar : String -> { back : Maybe Page, about : Bool } -> Html Msg
navBar title { back, about } =
    nav [ class "navbar navbar-default navbar-fixed-top" ]
        [ div [ class "container" ]
            ([ case back of
                Just page ->
                    backButton page

                Nothing ->
                    text ""
             , show about aboutButton
             , h1 [] [ text title ]
             ]
            )
        ]


show : Bool -> Html Msg -> Html Msg
show s html =
    if s then
        html
    else
        text ""


backButton : Page -> Html Msg
backButton page =
    App.ViewHelpers.link ChangePage
        page
        [ class "btn btn-link navbar-link navbar-text pull-left" ]
        [ App.ViewHelpers.glyphicon "menu-left" ]


aboutButton : Html Msg
aboutButton =
    App.ViewHelpers.link ChangePage
        AboutPage
        [ class "btn btn-link navbar-link navbar-text pull-right"
        ]
        [ App.ViewHelpers.glyphicon "info-sign" ]
