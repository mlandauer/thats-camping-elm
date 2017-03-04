module Pages.Tour.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown
import App.ViewHelpers
import App.Update exposing (Msg)
import App.Model exposing (Page(..), CampsitesPageOption(..), TourPageId(..))
import App.ViewHelpers exposing (link, navBar)


view : TourPageId -> Bool -> Html Msg
view id loaded =
    div [ class "tour" ]
        [ navBar "" (id /= Find) False
        , div [ class "container" ]
            [ div [ class "content" ]
                [ div [ class "centering-box" ]
                    [ Markdown.toHtml [] (content id)
                    ]
                ]
            ]
        , nav [ class "navbar navbar-default navbar-fixed-bottom" ]
            [ div [ class "container" ]
                [ if id /= Edit || loaded then
                    link (nextPage id)
                        [ class "btn btn-default navbar-btn" ]
                        [ text (nextText id) ]
                  else
                    span [ class "btn btn-default navbar-btn disabled" ]
                        [ text (nextText id) ]
                ]
            ]
        ]


content : TourPageId -> String
content id =
    case id of
        Find ->
            """
## That's Camping

Find campsites near you with the facilities you want. Look at a simple list or look around a map.

It covers camping on public, common land, initially for New South Wales, Australia.

"""

        Offline ->
            """
## Works offline

Almost everything works offline too. So you can find your next campsite even when you are far away from civilisation with no phone reception.
"""

        Edit ->
            """
## A Wikipedia for campsites

Soon, you will be able to add and update campsites and it will work even when you're offline.

Get a warm and fuzzy feeling because other people will benefit from your knowledge.
"""


nextPage : TourPageId -> Page
nextPage id =
    case id of
        Find ->
            TourPage Offline

        Offline ->
            TourPage Edit

        Edit ->
            CampsitesPage List


nextText : TourPageId -> String
nextText id =
    case id of
        Find ->
            "Next"

        Offline ->
            "Next"

        Edit ->
            "Next"
