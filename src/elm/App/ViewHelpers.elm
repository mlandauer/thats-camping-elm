module App.ViewHelpers
    exposing
        ( star
        , view404
        , glyphicon
        , link
        , linkWithDisabled
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode
import App.Model exposing (Page(..))
import App.Routing


glyphicon : String -> Html msg
glyphicon name =
    span [ class ("glyphicon glyphicon-" ++ name) ] []


star : Bool -> Maybe msg -> Html msg
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


view404 : Html msg
view404 =
    -- TODO: Make this page less ugly
    div [ class "container" ]
        [ div [ class "content" ]
            [ h2 [] [ text "This is a 404" ]
            ]
        ]


link :
    msg
    -> Page
    -> List (Attribute msg)
    -> List (Html msg)
    -> Html msg
link msg page attributes html =
    a
        ([ href (App.Routing.page2url page)
         , onClickPreventDefault msg
         ]
            ++ attributes
        )
        html


linkWithDisabled :
    msg
    -> Page
    -> Bool
    -> List (Attribute msg)
    -> List (Html msg)
    -> Html msg
linkWithDisabled msg page disabled attributes html =
    if disabled then
        span
            ([ class "disabled" ] ++ attributes)
            html
    else
        link msg
            page
            attributes
            html


onClickPreventDefault : msg -> Attribute msg
onClickPreventDefault message =
    onWithOptions "click"
        { stopPropagation = True, preventDefault = True }
        (Json.Decode.succeed message)
