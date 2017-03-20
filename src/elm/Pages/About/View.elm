module Pages.About.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import App.Update exposing (Msg(..))
import Regex
import App.Model exposing (Page(..), TourPageId(..))
import App.ViewHelpers


view : String -> Html Msg
view version =
    div [ class "campsite-list" ]
        [ div [ class "content" ]
            [ div [ class "container" ]
                [ h2 []
                    [ text "About That's Camping" ]
                , p []
                    [ text "Find campsites near you in New South Wales, Australia. It covers camping on public, common land such as National Parks, State Forests and Local Council land." ]
                , p []
                    [ text "It works "
                    , strong [] [ text "completely offline" ]
                    , text ", even when you're far far away from a mobile phone tower. When does that ever happen while camping?"
                    ]
                , p []
                    [ text "Made by "
                    , a [ href "https://twitter.com/matthewlandauer" ]
                        [ text "Matthew Landauer" ]
                    , text ". It's free and "
                    , a [ href "https://github.com/mlandauer/thats-camping-elm" ]
                        [ text "open source" ]
                    , text " because that's the way it ought to be."
                    ]
                , p []
                    [ text "You're currently using version "
                    , a [ href ("https://github.com/mlandauer/thats-camping-elm/commit/" ++ version) ]
                        [ text version ]
                    , text "."
                    ]
                , App.ViewHelpers.link
                    (ChangePage (TourPage Start))
                    (TourPage Start)
                    [ class "wide-button btn btn-default" ]
                    [ text "Tour" ]
                , h2 [] [ text "Things you might want to do" ]
                , p []
                    [ a [ href "https://github.com/mlandauer/thats-camping-elm/issues" ]
                        [ text "Suggest a "
                        , strong [] [ text "feature" ]
                        , text " or report an "
                        , strong [] [ text "issue" ]
                        ]
                    ]
                ]
            ]
        ]


replace : String -> String -> String -> String
replace a b text =
    -- Replace a with b
    (Regex.replace Regex.All (Regex.regex a) (\_ -> b) text)
