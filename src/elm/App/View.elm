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
        [ navView model
        , (case model.page of
            CampsitesPage displayType ->
                Pages.Campsites.View.view
                    { campsites = (Dict.values model.campsites)
                    , location = model.location
                    , errors = model.errors
                    , starredCampsites = model.starredCampsites
                    , displayType = displayType
                    , synching = model.synching
                    , limitList = model.limitList
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


navView : Model -> Html Msg
navView model =
    case model.page of
        CampsitesPage displayType ->
            if Dict.isEmpty model.campsites then
                navBar ""
                    { back = Nothing, about = False }
            else
                navBar "Camping near you"
                    { back = Nothing, about = True }

        CampsitePage id ->
            case Dict.get id model.campsites of
                Just campsite ->
                    navBar campsite.name.short
                        { back = List.head model.previousPages, about = True }

                Nothing ->
                    navBar "404"
                        { back = List.head model.previousPages, about = False }

        AboutPage ->
            navBar "About"
                { back = List.head model.previousPages, about = False }

        TourPage id ->
            navBar ""
                { back =
                    (if id /= Start then
                        List.head model.previousPages
                     else
                        Nothing
                    )
                , about = False
                }

        AdminPage ->
            navBar "Database admin"
                { back = List.head model.previousPages, about = False }

        UnknownPage ->
            navBar "404"
                { back = List.head model.previousPages, about = False }


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
    App.ViewHelpers.link
        PageBack
        page
        [ class "btn btn-link navbar-link navbar-text pull-left" ]
        [ App.ViewHelpers.glyphicon "menu-left" ]


aboutButton : Html Msg
aboutButton =
    App.ViewHelpers.link
        (ChangePage AboutPage)
        AboutPage
        [ class "btn btn-link navbar-link navbar-text pull-right"
        ]
        [ App.ViewHelpers.glyphicon "info-sign" ]
