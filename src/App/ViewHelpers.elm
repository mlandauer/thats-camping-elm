module App.ViewHelpers
    exposing
        ( navBar
        , link
        , campsiteListView
        , compareCampsite
        , values
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import App.Model exposing (..)
import App.Update exposing (..)
import Location
import Dict exposing (Dict)


navBar : String -> Bool -> Bool -> Html Msg
navBar title showBack showAbout =
    -- TODO: Turn showBack and showAbout into a record for legibility
    nav [ class "navbar navbar-default navbar-fixed-top" ]
        [ div [ class "container" ]
            ((if showBack then
                [ backButton ]
              else
                []
             )
                ++ (if showAbout then
                        [ aboutButton ]
                    else
                        []
                   )
                ++ [ h1 [] [ text title ] ]
            )
        ]


backButton : Html Msg
backButton =
    button [ onClick PageBack, class "btn btn-link navbar-link navbar-text pull-left" ]
        [ span [ class "glyphicon glyphicon-menu-left" ] [] ]


aboutButton : Html msg
aboutButton =
    link About
        [ class "btn navbar-link navbar-text pull-right" ]
        [ span [ class "glyphicon glyphicon-info-sign" ] [] ]


link : Page -> List (Attribute msg) -> List (Html msg) -> Html msg
link page attributes html =
    a ((href (page2url page)) :: attributes) html


campsiteListView location campsites parks showPark =
    -- TODO: Make it not necessary to pass in all the parks here
    div [ class "list-group" ]
        (List.map (campsiteListItem location parks showPark) (sortCampsites location campsites))


sortCampsites : Maybe Location -> List Campsite -> List Campsite
sortCampsites location campsites =
    List.sortWith (compareCampsite location) campsites



-- We're being a bit flexible with the form of the campsite record so that we can make testing a little less cumbersome


compareCampsite : Maybe Location -> { c | location : Maybe Location, shortName : String } -> { c | location : Maybe Location, shortName : String } -> Order
compareCampsite userLocation c1 c2 =
    let
        d1 =
            Maybe.map2 Location.distanceInMetres userLocation c1.location

        d2 =
            Maybe.map2 Location.distanceInMetres userLocation c2.location
    in
        case d1 of
            Just d1 ->
                case d2 of
                    Just d2 ->
                        compare d1 d2

                    Nothing ->
                        LT

            Nothing ->
                case d2 of
                    Just d2 ->
                        GT

                    Nothing ->
                        compare c1.shortName c2.shortName


campsiteListItem : Maybe Location -> Dict Int Park -> Bool -> Campsite -> Html msg
campsiteListItem location parks showPark campsite =
    link (CampsitePage campsite.id)
        [ class "list-group-item" ]
        [ div [ class "campsite" ]
            ([ div [ class "pull-right distance" ] [ text (bearingAndDistanceAsText location campsite.location) ]
             , div [ class "name" ] [ text campsite.shortName ]
             ]
                ++ (if showPark then
                        [ div [ class "park" ]
                            [ text
                                (Maybe.withDefault "" (Maybe.map .shortName (park campsite parks)))
                            ]
                        ]
                    else
                        []
                   )
            )
        ]


park : Campsite -> Dict Int Park -> Maybe Park
park campsite parks =
    Dict.get campsite.parkId parks


bearingAndDistanceAsText : Maybe Location -> Maybe Location -> String
bearingAndDistanceAsText from to =
    case (Maybe.map2 Location.bearingAndDistanceText from to) of
        Just text ->
            text

        Nothing ->
            ""


values : List (Maybe a) -> List a
values l =
    -- TODO: This function doesn't really belong in view helpers
    -- Implementing something like Maybe.Extra.values
    -- Recursive so probably not efficient
    case l of
        [] ->
            []

        first :: rest ->
            case first of
                Just value ->
                    value :: (values rest)

                Nothing ->
                    values rest
