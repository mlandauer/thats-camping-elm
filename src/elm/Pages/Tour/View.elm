module Pages.Tour.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import App.ViewHelpers
import App.Update exposing (Msg(..))
import App.Model exposing (Page(..), CampsitesPageOption(..), TourPageId(..))


view : TourPageId -> Bool -> Html Msg
view id loaded =
    div [ class "tour" ]
        [ div [ class "container" ]
            [ div [ class "content" ]
                [ div [ class "centering-box" ]
                    [ content id
                    ]
                ]
            ]
        , nav [ class "navbar navbar-default navbar-fixed-bottom" ]
            [ div [ class "container" ]
                [ App.ViewHelpers.linkWithDisabled
                    (ChangePage (nextPage id))
                    (nextPage id)
                    (id == Edit && not loaded)
                    [ class "btn btn-default navbar-btn" ]
                    [ text (nextText id) ]
                ]
            ]
        ]


content : TourPageId -> Html Msg
content id =
    case id of
        Start ->
            div []
                [ h2 [] [ text "That's Camping" ]
                , p [] [ text "Find campsites near you with the facilities you want. Look at a simple list or look around a map." ]
                , p [] [ text "It covers camping on public, common land, initially for New South Wales, Australia." ]
                ]

        Offline ->
            div []
                [ h2 [] [ text "Works offline" ]
                , p [] [ text "Almost everything works offline too. So you can find your next campsite even when you are far away from civilisation with no phone reception." ]
                ]

        Edit ->
            div []
                [ h2 [] [ text "Coming soon... A Wikipedia for campsites" ]
                , p [] [ text "Soon, you will be able to add and update campsites and it will work even when you're offline." ]
                , p [] [ text "Get a warm and fuzzy feeling because other people will benefit from your knowledge." ]
                ]


nextPage : TourPageId -> Page
nextPage id =
    case id of
        Start ->
            TourPage Offline

        Offline ->
            TourPage Edit

        Edit ->
            CampsitesPage List


nextText : TourPageId -> String
nextText id =
    case id of
        Start ->
            "Next"

        Offline ->
            "Next"

        Edit ->
            "Next"
