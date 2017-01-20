module App.ViewHelpers exposing (navBar, link)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import App.Model exposing (..)
import App.Update exposing (..)


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


backButton : Html Msg
backButton =
    button [ onClick PageBack, class "btn btn-link navbar-link navbar-text pull-left" ]
        [ span [ class "glyphicon glyphicon-menu-left" ] [] ]


aboutButton : Html msg
aboutButton =
    link About
        [ class "btn navbar-link navbar-text pull-right" ]
        [ span [ class "glyphicon glyphicon-info-sign" ] [] ]


link : Page -> List (Attribute msg) -> List (Html msg) -> Html msg
link page attributes html =
    a ((href (page2url page)) :: attributes) html
