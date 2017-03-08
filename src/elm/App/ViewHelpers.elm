module App.ViewHelpers
    exposing
        ( navBar
        , star
        , view404
        , glyphicon
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, on, onWithOptions)
import Html.Keyed
import App.Model exposing (..)
import App.Update exposing (..)
import Location exposing (Location)
import Campsite exposing (Campsite, CampsiteWithStarred)


type alias NavBarConfig msg =
    -- If back is Nothing then don't display the back button. Same for about
    { back : Maybe msg, about : Maybe msg }


navBar : String -> NavBarConfig msg -> Html msg
navBar title { back, about } =
    nav [ class "navbar navbar-default navbar-fixed-top" ]
        [ div [ class "container" ]
            ([ show backButton back
             , show aboutButton about
             , h1 [] [ text title ]
             ]
            )
        ]


show : (msg -> Html msg) -> Maybe msg -> Html msg
show html msg =
    Maybe.withDefault (text "") (Maybe.map html msg)


glyphicon : String -> Html msg
glyphicon name =
    span [ class ("glyphicon glyphicon-" ++ name) ] []


backButton : msg -> Html msg
backButton msg =
    button [ onClick msg, class "btn btn-link navbar-link navbar-text pull-left" ]
        [ glyphicon "menu-left" ]


aboutButton : msg -> Html msg
aboutButton msg =
    button
        [ onClick msg
        , class "btn btn-link navbar-link navbar-text pull-right"
        ]
        [ glyphicon "info-sign" ]


star : Bool -> Maybe Msg -> Html Msg
star starred msg =
    div
        ([ class
            ("star star-"
                ++ (if starred then
                        "on"
                    else
                        "off"
                   )
            )
         ]
            ++ (case msg of
                    Just msg ->
                        [ onClick msg ]

                    Nothing ->
                        []
               )
        )
        [ glyphicon
            (if starred then
                "star"
             else
                "star-empty"
            )
        ]


view404 : Html Msg
view404 =
    -- TODO: Make this page less ugly
    p [] [ text "This is a 404" ]
