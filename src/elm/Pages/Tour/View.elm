module Pages.Tour.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import App.Update exposing (Msg)
import App.Model exposing (Page(..), CampsitesPageOption(..))
import Pages.Tour.Model exposing (..)
import App.ViewHelpers exposing (navBar, link)


view : Model -> Html Msg
view model =
    div [ class "campsite-list" ]
        [ navBar "Camping near you" False True
        , div [ class "content " ]
            [ modal
            , div [ class "content-inner" ]
                [ App.ViewHelpers.campsiteListView model.location
                    model.campsites
                    model.starredCampsites
                ]
            ]
        , nav [ class "navbar navbar-default navbar-fixed-bottom" ]
            [ div [ class "container" ]
                [ div [ class "btn-group" ]
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


modal =
    div []
        [ div [ class "modal-backdrop fade in" ] []
        , div
            [ class "modal fade bs-example-modal-sm in"
            , attribute "role" "dialog"
            , tabindex -1
            , attribute "aria-labelledby" "mySmallModalLabel"
            , style [ ( "display", "block" ) ]
            ]
            [ div [ class "modal-dialog modal-sm", attribute "role" "document" ]
                [ div [ class "modal-content" ]
                    [ div [ class "modal-header" ]
                        [ button
                            [ attribute "type" "button"
                            , class "close"
                            , attribute "data-dismiss" "modal"
                            , attribute "aria-label" "Close"
                            ]
                            [ span [ attribute "aria-hidden" "true" ] [ text "x" ]
                            ]
                        , h4 [ class "modal-title", id "mySmallModalLabel" ]
                            [ text "Small modal"
                            ]
                        ]
                    , div [ class "modal-body" ] [ text "..." ]
                    ]
                ]
            ]
        ]
