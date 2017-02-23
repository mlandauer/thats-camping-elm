module Pages.Tour.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown
import App.ViewHelpers
import App.Update exposing (Msg)
import App.Model exposing (Page(..), CampsitesPageOption(..), TourPageId(..))
import App.ViewHelpers exposing (link, navBar)


view : TourPageId -> Html Msg
view id =
    div [ class "tour" ]
        [ navBar "" (id /= Start) False
        , div [ class "container" ]
            [ div [ class "content" ]
                [ div [ class "centering-box" ]
                    [ Markdown.toHtml [] (content id)
                    ]
                ]
            ]
        , nav [ class "navbar navbar-default navbar-fixed-bottom" ]
            [ div [ class "container" ]
                [ link (nextPage id)
                    [ class "btn btn-default navbar-btn" ]
                    [ text "Next" ]
                ]
            ]
        ]


content : TourPageId -> String
content id =
    case id of
        Start ->
            """
## That's Camping!

It's your first time. So we just need to grab the campsites for you in the background. It shouldn't take long.

In the meantime we’ll give you a quick tour of how you can find the perfect campsite.
"""

        Find ->
            """
## Find campsites

Find campsites near you that have the facilities that you want. Look at a simple list or look around a map.

"""

        Offline ->
            """
## Works offline

Almost everything works offline too. So you can find your next campsite even when you are far away from civilisation with no cell phone reception.
"""

        Edit ->
            """
## Coming soon

You will be able to add and update campsites and it will work even when you're offline.

Get a warm and fuzzy feeling because other people will benefit from your knowledge.
"""

        Last ->
            """
## Loading campsites

We're just finishing loading campsites now. It shouldn't be long.
"""


nextPage : TourPageId -> Page
nextPage id =
    case id of
        Start ->
            TourPage Find

        Find ->
            TourPage Offline

        Offline ->
            TourPage Edit

        Edit ->
            TourPage Last

        Last ->
            CampsitesPage List
