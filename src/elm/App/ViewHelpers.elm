module App.ViewHelpers
    exposing
        ( navBar
        , star
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


type alias NavBarConfig msg =
    -- If back is Nothing then don't display the back button. Same for about
    { back : Maybe msg, about : Bool, changePageMsg : Page -> msg }


navBar : String -> NavBarConfig msg -> Html msg
navBar title { back, about, changePageMsg } =
    nav [ class "navbar navbar-default navbar-fixed-top" ]
        [ div [ class "container" ]
            ([ show backButton back
             , if about then
                aboutButton changePageMsg AboutPage
               else
                text ""
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


aboutButton : (Page -> msg) -> Page -> Html msg
aboutButton changePageMsg page =
    link changePageMsg
        page
        [ class "btn btn-link navbar-link navbar-text pull-right"
        ]
        [ glyphicon "info-sign" ]


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
    (Page -> msg)
    -> Page
    -> List (Attribute msg)
    -> List (Html msg)
    -> Html msg
link changePageMsg page attributes html =
    a
        ([ href (App.Routing.page2url page)
         , onClickPreventDefault (changePageMsg page)
         ]
            ++ attributes
        )
        html


linkWithDisabled :
    (Page -> msg)
    -> Page
    -> Bool
    -> List (Attribute msg)
    -> List (Html msg)
    -> Html msg
linkWithDisabled changePageMsg page disabled attributes html =
    if disabled then
        span
            ([ class "disabled" ] ++ attributes)
            html
    else
        link changePageMsg
            page
            attributes
            html


onClickPreventDefault : msg -> Attribute msg
onClickPreventDefault message =
    onWithOptions "click"
        { stopPropagation = True, preventDefault = True }
        (Json.Decode.succeed message)
