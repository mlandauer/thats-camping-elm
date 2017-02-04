module App.ViewHelpers
    exposing
        ( navBar
        , link
        , campsiteListView
        , compareCampsite
        , values
        , star
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import App.Model exposing (..)
import App.Update exposing (..)
import Location
import Dict exposing (Dict)
import Location exposing (Location)
import Park exposing (Park)
import Campsite exposing (Campsite)


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
    link AboutPage
        [ class "btn navbar-link navbar-text pull-right" ]
        [ span [ class "glyphicon glyphicon-info-sign" ] [] ]


link : Page -> List (Attribute msg) -> List (Html msg) -> Html msg
link page attributes html =
    a ((href (page2url page)) :: attributes) html


campsiteListView : Maybe Location -> List Campsite -> Dict String Park -> Bool -> List String -> Html Msg
campsiteListView location campsites parks showPark starredCampsites =
    -- TODO: Make it not necessary to pass in all the parks here
    div [ class "list-group" ]
        (List.map
            (\c ->
                campsiteListItem location parks showPark c.campsite c.starred
            )
            (sortCampsites2 location (transform campsites starredCampsites))
        )


transform : List Campsite -> List String -> List CampsiteWithStarred
transform campsites starredCampsites =
    List.map
        (\campsite -> CampsiteWithStarred campsite (List.member campsite.id starredCampsites))
        campsites


type alias CampsiteWithStarred =
    { campsite : Campsite, starred : Bool }


sortCampsites2 : Maybe Location -> List CampsiteWithStarred -> List CampsiteWithStarred
sortCampsites2 location campsitesWithStarred =
    List.sortWith (compareCampsite2 location) campsitesWithStarred


sortCampsites : Maybe Location -> List Campsite -> List Campsite
sortCampsites location campsites =
    List.sortWith (compareCampsite location) campsites


compareCampsite2 :
    Maybe Location
    -> CampsiteWithStarred
    -> CampsiteWithStarred
    -> Order
compareCampsite2 userLocation c1 c2 =
    if c1.starred && not c2.starred then
        LT
    else if not c1.starred && c2.starred then
        GT
    else
        compareCampsite userLocation c1.campsite c2.campsite



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


campsiteListItem :
    Maybe Location
    -> Dict String Park
    -> Bool
    -> Campsite
    -> Bool
    -> Html Msg
campsiteListItem location parks showPark campsite starred =
    link (CampsitePage campsite.id)
        [ class "list-group-item" ]
        [ div [ class "campsite" ]
            ([ star starred Nothing
             , div [ class "pull-right distance" ] [ text (bearingAndDistanceAsText location campsite.location) ]
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


park : Campsite -> Dict String Park -> Maybe Park
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


star : Bool -> Maybe Msg -> Html Msg
star starred msg =
    div
        ([ class
            ("star star-"
                ++ (if starred then
                        "on"
                    else
                        "off"
                   )
            )
         ]
            ++ (case msg of
                    Just msg ->
                        [ onClick msg ]

                    Nothing ->
                        []
               )
        )
        [ span
            [ class
                ("glyphicon glyphicon-"
                    ++ (if starred then
                            "star"
                        else
                            "star-empty"
                       )
                )
            ]
            []
        ]
