module Pages.Campsites.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import App.Update exposing (Msg(..))
import App.Model exposing (Page(..), CampsitesPageOption(..))
import Pages.Campsites.Model exposing (..)
import App.ViewHelpers exposing (navBar, link)
import Errors


view : Model -> Html Msg
view model =
    if List.isEmpty model.campsites then
        div [ class "loading" ]
            [ div [ class "container" ]
                [ div [ class "content" ]
                    [ div [ class "centering-box" ]
                        [ div []
                            [ img
                                [ src "/apple-touch-icon.png"
                                , width 96
                                , height 96
                                ]
                                []
                            , h2 [] [ text "That's Camping" ]
                            ]
                        ]
                    ]
                ]
            ]
    else
        div [ class "campsite-list" ]
            [ navBar "Camping near you" False True
            , div [ class "content " ]
                [ Html.map ErrorsMsg (Errors.view model.errors)
                , div [ class "content-inner" ]
                    [ case model.displayType of
                        List ->
                            App.ViewHelpers.campsiteListView model.location
                                model.campsites
                                model.starredCampsites

                        Map ->
                            {- Don't show anything because we actually have a
                               permanent map div in App.View
                            -}
                            text ""
                    ]
                ]
            , nav [ class "navbar navbar-default navbar-fixed-bottom" ]
                [ div [ class "container" ]
                    [ if model.synching then
                        div [ class "btn navbar-link navbar-text sync" ]
                            [ span [ class "glyphicon glyphicon-transfer" ] []
                            ]
                      else
                        text ""
                    , div [ class "btn-group" ]
                        [ link (CampsitesPage List)
                            [ class "btn navbar-link navbar-text" ]
                            [ span [ class "glyphicon glyphicon-list" ] [] ]
                        , link (CampsitesPage Map)
                            [ class "btn navbar-link navbar-text" ]
                            [ span [ class "glyphicon glyphicon-map-marker" ] [] ]
                        ]
                    ]
                ]
            ]
