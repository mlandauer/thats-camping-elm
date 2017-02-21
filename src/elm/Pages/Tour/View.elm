module Pages.Tour.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown
import App.ViewHelpers
import App.Update exposing (Msg)
import App.Model exposing (Page(..))
import App.ViewHelpers exposing (link)


view : String -> Html Msg
view id =
    div [ class "tour" ]
        [ div [ class "content" ]
            [ let
                content =
                    """
<img src="apple-touch-icon.png"/>

## That's Camping!

It's your first time. So we just need to grab the campsites for you in the background. It shouldn't take long.

In the meantime we’ll give you a quick tour of how you can find the perfect campsite.

"""
              in
                Markdown.toHtml [ class "container" ] content
            ]
        , nav [ class "navbar navbar-default navbar-fixed-bottom" ]
            [ div [ class "container" ]
                [ link (TourPage "2")
                    [ class "btn btn-default navbar-btn pull-right" ]
                    [ text "Next" ]
                ]
            ]
        ]
