module Pages.Tour.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown
import App.ViewHelpers
import App.Update exposing (Msg)
import App.Model exposing (Page(..))
import App.ViewHelpers exposing (link, navBar)


view : String -> Html Msg
view id =
    case id of
        "1" ->
            view1

        "2" ->
            view2

        _ ->
            App.ViewHelpers.view404


view1 : Html Msg
view1 =
    div [ class "tour" ]
        [ div [ class "container" ]
            [ div [ class "content" ]
                [ img [ src "apple-touch-icon.png" ] []
                , div [ class "centering-box" ]
                    [ let
                        content =
                            """
## That's Camping!

It's your first time. So we just need to grab the campsites for you in the background. It shouldn't take long.

In the meantime we’ll give you a quick tour of how you can find the perfect campsite.

"""
                      in
                        Markdown.toHtml [] content
                    ]
                ]
            ]
        , nav [ class "navbar navbar-default navbar-fixed-bottom" ]
            [ div [ class "container" ]
                [ link (TourPage "2")
                    [ class "btn btn-default navbar-btn" ]
                    [ text "Next" ]
                ]
            ]
        ]


view2 : Html Msg
view2 =
    div [ class "tour" ]
        [ navBar "" True False
        , div [ class "container" ]
            [ div [ class "content" ]
                [ div [ class "centering-box" ]
                    [ let
                        content =
                            """
## Find campsites

Find campsites near you that have the facilities that you want. Look at a simple list or look around a map.

"""
                      in
                        Markdown.toHtml [] content
                    ]
                ]
            ]
        , nav [ class "navbar navbar-default navbar-fixed-bottom" ]
            [ div [ class "container" ]
                [ link (TourPage "3")
                    [ class "btn btn-default navbar-btn" ]
                    [ text "Next" ]
                ]
            ]
        ]
