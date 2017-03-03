module Pages.About.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import App.ViewHelpers exposing (navBar)
import App.Update exposing (Msg)
import Markdown
import Regex


view : String -> Html Msg
view version =
    div [ class "campsite-list" ]
        [ navBar "About" True False
        , div [ class "content" ]
            [ """
## About That's Camping

Find campsites near you in New South Wales, Australia. It covers camping on
public, common land such as National Parks, State Forests and Local Council
land.

It works **completely offline**, even when you're far far away from a mobile phone tower. When does that ever happen while camping?

Made by [Matthew Landauer](https://twitter.com/matthewlandauer) based on an iOS
app. It's free and [open source](https://github.com/mlandauer/thats-camping-elm)
because that's the way it ought to be.

You're currently using version [{{version}}](https://github.com/mlandauer/thats-camping-elm/commit/{{version}}).

## Things you might want to do

[Suggest a **feature** or report an **issue**](https://github.com/mlandauer/thats-camping-elm/issues)
                """
                -- Doing poor man's string interpolation here
                |>
                    replace "{{version}}" version
                |> Markdown.toHtml [ class "container" ]
            ]
        ]


replace : String -> String -> String -> String
replace a b text =
    -- Replace a with b
    (Regex.replace Regex.All (Regex.regex a) (\_ -> b) text)
