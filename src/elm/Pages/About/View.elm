module Pages.About.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import App.ViewHelpers exposing (navBar)
import App.Update exposing (Msg(..))
import Markdown
import Regex
import App.Model exposing (Page(..), TourPageId(..))


view : String -> Html Msg
view version =
    div [ class "campsite-list" ]
        [ navBar "About"
            { back = Just PageBack, about = Nothing }
        , div [ class "content" ]
            [ div [ class "container" ]
                [ """
## About That's Camping

Find campsites near you in New South Wales, Australia. It covers camping on
public, common land such as National Parks, State Forests and Local Council
land.

It works **completely offline**, even when you're far far away from a mobile phone tower. When does that ever happen while camping?

Made by [Matthew Landauer](https://twitter.com/matthewlandauer). It's free and [open source](https://github.com/mlandauer/thats-camping-elm)
because that's the way it ought to be.

You're currently using version [{{version}}](https://github.com/mlandauer/thats-camping-elm/commit/{{version}}).
                """
                    -- Doing poor man's string interpolation here
                    |>
                        replace "{{version}}" version
                    |> Markdown.toHtml []
                , button
                    [ class "wide-button btn btn-default"
                    , onClick (ChangePage (TourPage Start))
                    ]
                    [ text "Tour" ]
                , """
## Things you might want to do

[Suggest a **feature** or report an **issue**](https://github.com/mlandauer/thats-camping-elm/issues)
                  """
                    |> Markdown.toHtml []
                ]
            ]
        ]


replace : String -> String -> String -> String
replace a b text =
    -- Replace a with b
    (Regex.replace Regex.All (Regex.regex a) (\_ -> b) text)
