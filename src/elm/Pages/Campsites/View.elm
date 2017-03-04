module Pages.Campsites.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import App.Update exposing (Msg(..))
import App.Model exposing (Page(..), CampsitesPageOption(..))
import Pages.Campsites.Model exposing (..)
import App.ViewHelpers exposing (navBar, link)


view : Model -> Html Msg
view model =
    if List.isEmpty model.campsites then
        div [ class "loading" ]
            [ div [ class "container" ]
                [ div [ class "content" ]
                    [ div [ class "centering-box" ]
                        [ h2 [] [ text "That's Camping" ]
                        ]
                    ]
                ]
            ]
    else
        div [ class "campsite-list" ]
            [ navBar "Camping near you" False True
            , div [ class "content " ]
                [ errorsView model.errors
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


errorsView : List String -> Html Msg
errorsView errors =
    if List.isEmpty errors then
        text ""
    else
        div [ class "alert alert-warning text-center" ]
            ([ button [ class "pull-right close", onClick ClearErrors ] [ text "×" ] ]
                ++ (List.map
                        (\error ->
                            (p []
                                [ span [ class "glyphicon glyphicon-exclamation-sign" ] []
                                , text " "
                                , text error
                                ]
                            )
                        )
                        errors
                   )
            )
