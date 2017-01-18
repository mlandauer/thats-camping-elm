module App.View exposing (navBar)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import App.Update exposing (..)
import App.Model exposing (..)


navBar : String -> Bool -> Bool -> Html Msg
navBar title showBack showAbout =
    -- TODO: Turn showBack and showAbout into a record for legibility
    nav [ class "navbar navbar-default navbar-fixed-top" ]
        [ div [ class "container" ]
            ((if showBack then
                [ backButton ]
              else
                []
             )
                ++ (if showAbout then
                        [ aboutButton ]
                    else
                        []
                   )
                ++ [ h1 [] [ text title ] ]
            )
        ]


aboutButton : Html Msg
aboutButton =
    link About
        [ class "btn navbar-link navbar-text pull-right" ]
        [ span [ class "glyphicon glyphicon-info-sign" ] [] ]


backButton : Html Msg
backButton =
    button [ onClick PageBack, class "btn btn-link navbar-link navbar-text pull-left" ]
        [ span [ class "glyphicon glyphicon-menu-left" ] [] ]


link : Page -> List (Attribute Msg) -> List (Html Msg) -> Html Msg
link page attributes html =
    a ((href (page2url page)) :: attributes) html
