module Pages.About.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import App.ViewHelpers exposing (navBar)


view =
    div [ class "campsite-list" ]
        [ navBar "About" True False
        , div [ class "content" ]
            [ div [ class "container" ]
                [ h2 [] [ text "About That's Camping" ]
                , p [] [ text "Find campsites near you in New South Wales, Australia. It covers camping on public, common land such as National Parks, State Forests and Local Council land." ]
                , p []
                    [ text "It works "
                    , strong [] [ text "completely offline" ]
                    , text ", even when you're far far away from a mobile phone tower. When does that ever happen while camping?"
                    ]
                , p []
                    [ text "Made by "
                    , a [ href "https://twitter.com/matthewlandauer" ] [ text "Matthew Landauer" ]
                    , text " based on an iOS app. It's free and "
                    , a [ href "https://github.com/mlandauer/thats-camping-elm" ] [ text "open source" ]
                    , text " because that's the way it ought to be."
                    ]
                  -- TODO: Show current version of the app here
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
