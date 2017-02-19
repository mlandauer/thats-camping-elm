module App.ViewHelpers
    exposing
        ( navBar
        , link
        , campsiteListView
        , values
        , star
        , show
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Html.Keyed
import App.Model exposing (..)
import App.Update exposing (..)
import Location exposing (Location)
import Campsite exposing (Campsite)


navBar : String -> Bool -> Bool -> Html Msg
navBar title showBack showAbout =
    -- TODO: Turn showBack and showAbout into a record for legibility
    nav [ class "navbar navbar-default navbar-fixed-top" ]
        [ div [ class "container" ]
            ([ show backButton showBack
             , show aboutButton showAbout
             , h1 [] [ text title ]
             ]
            )
        ]


show : Html Msg -> Bool -> Html Msg
show html show =
    if show then
        html
    else
        text ""


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


campsiteListView : Maybe Location -> List Campsite -> List String -> Html Msg
campsiteListView location campsites starredCampsites =
    Html.Keyed.node "div"
        [ class "list-group" ]
        (List.map
            (\c -> ( c.campsite.id, campsiteListItem location c ))
            (sortCampsitesWithStarred location (transform campsites starredCampsites))
        )


transform : List Campsite -> List String -> List CampsiteWithStarred
transform campsites starredCampsites =
    List.map
        (\campsite -> CampsiteWithStarred campsite (List.member campsite.id starredCampsites))
        campsites


type alias CampsiteWithStarred =
    { campsite : Campsite, starred : Bool }


sortCampsitesWithStarred : Maybe Location -> List CampsiteWithStarred -> List CampsiteWithStarred
sortCampsitesWithStarred location campsitesWithStarred =
    List.sortWith (compareCampsite location) campsitesWithStarred


compareCampsite :
    Maybe Location
    -> CampsiteWithStarred
    -> CampsiteWithStarred
    -> Order
compareCampsite userLocation r1 r2 =
    if (compareStarred r1.starred r2.starred) /= EQ then
        compareStarred r1.starred r2.starred
    else if (compareCampsiteByDistance userLocation r1.campsite r2.campsite) /= EQ then
        compareCampsiteByDistance userLocation r1.campsite r2.campsite
    else
        compare r1.campsite.name r2.campsite.name


compareStarred : Bool -> Bool -> Order
compareStarred s1 s2 =
    if s1 && not s2 then
        LT
    else if not s1 && s2 then
        GT
    else
        EQ


compareCampsiteByDistance :
    Maybe Location
    -> Campsite
    -> Campsite
    -> Order
compareCampsiteByDistance userLocation c1 c2 =
    compareDistance
        (Maybe.map2 Location.distanceInMetres userLocation c1.location)
        (Maybe.map2 Location.distanceInMetres userLocation c2.location)


compareDistance : Maybe Float -> Maybe Float -> Order
compareDistance d1 d2 =
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
                    EQ


campsiteListItem : Maybe Location -> CampsiteWithStarred -> Html Msg
campsiteListItem location c =
    link (CampsitePage c.campsite.id)
        [ class "list-group-item" ]
        [ div [ class "campsite" ]
            ([ star c.starred Nothing
             , div [ class "pull-right distance" ] [ text (bearingAndDistanceAsText location c.campsite.location) ]
             , div [ class "name" ] [ text (Campsite.shortenName c.campsite.name) ]
             , div [ class "park" ] [ text (Campsite.shortenName c.campsite.parkName) ]
             ]
            )
        ]


bearingAndDistanceAsText : Maybe Location -> Maybe Location -> String
bearingAndDistanceAsText from to =
    Maybe.withDefault "" (Maybe.map2 Location.bearingAndDistanceText from to)


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
