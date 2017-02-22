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
            pageView (content id) (id /= "1") (nextPageId id)

        "2" ->
            pageView (content id) (id /= "1") (nextPageId id)

        _ ->
            App.ViewHelpers.view404


content : String -> Html Msg
content id =
    case id of
        "1" ->
            content1

        "2" ->
            content2

        -- TODO: Ugh. Fix this smelly thing.
        _ ->
            text ""


nextPageId : String -> String
nextPageId id =
    -- TODO: Ugh. Fix this smelly thing.
    case id of
        "1" ->
            "2"

        "2" ->
            "3"

        _ ->
            ""


content1 : Html Msg
content1 =
    Markdown.toHtml [] """
## That's Camping!

It's your first time. So we just need to grab the campsites for you in the background. It shouldn't take long.

In the meantime we’ll give you a quick tour of how you can find the perfect campsite.
"""


content2 : Html Msg
content2 =
    Markdown.toHtml [] """
## Find campsites

Find campsites near you that have the facilities that you want. Look at a simple list or look around a map.

"""


pageView : Html Msg -> Bool -> String -> Html Msg
pageView content showBack nextPageId =
    div [ class "tour" ]
        [ navBar "" showBack False
        , div [ class "container" ]
            [ div [ class "content" ]
                [ div [ class "centering-box" ] [ content ] ]
            ]
        , nav [ class "navbar navbar-default navbar-fixed-bottom" ]
            [ div [ class "container" ]
                [ link (TourPage nextPageId)
                    [ class "btn btn-default navbar-btn" ]
                    [ text "Next" ]
                ]
            ]
        ]
