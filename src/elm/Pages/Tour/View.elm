module Pages.Tour.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown
import App.ViewHelpers
import App.Update exposing (Msg)
import App.Model exposing (Page(..), TourPageId(..))
import App.ViewHelpers exposing (link, navBar)


view : TourPageId -> Html Msg
view id =
    case id of
        Start ->
            pageView (content id) (id /= Start) (nextPageId id)

        Find ->
            pageView (content id) (id /= Start) (nextPageId id)

        Other ->
            App.ViewHelpers.view404


content : TourPageId -> Html Msg
content id =
    case id of
        Start ->
            content1

        Find ->
            content2

        Other ->
            text ""


nextPageId : TourPageId -> TourPageId
nextPageId id =
    case id of
        Start ->
            Find

        Find ->
            Other

        Other ->
            -- TODO: This is obviously wrong!
            Start


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


pageView : Html Msg -> Bool -> TourPageId -> Html Msg
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
