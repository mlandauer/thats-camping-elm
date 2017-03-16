module App.CampsiteList exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Keyed
import App.Update exposing (Msg(..))
import App.Model exposing (Page(..))
import Campsite exposing (Campsite, CampsiteWithStarred)
import Location exposing (Location)
import App.ViewHelpers
import App.Routing
import Json.Decode


view : Maybe Location -> List Campsite -> List String -> Html Msg
view location campsites starredCampsites =
    Html.Keyed.node "div"
        [ class "list-group" ]
        (List.map
            (\c -> ( c.campsite.id, campsiteListItem location c ))
            (sortCampsitesWithStarred location
                (Campsite.transform campsites starredCampsites)
            )
        )


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
        compare r1.campsite.name.long r2.campsite.name.long


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


compareStarred : Bool -> Bool -> Order
compareStarred s1 s2 =
    if s1 && not s2 then
        LT
    else if not s1 && s2 then
        GT
    else
        EQ


campsiteListItem : Maybe Location -> CampsiteWithStarred -> Html Msg
campsiteListItem location c =
    App.ViewHelpers.link ChangePage
        (CampsitePage c.campsite.id)
        [ class "list-group-item" ]
        [ div [ class "campsite" ]
            ([ App.ViewHelpers.star c.starred Nothing
             , div [ class "pull-right distance" ] [ text (bearingAndDistanceAsText location c.campsite.location) ]
             , div [ class "name" ] [ text c.campsite.name.short ]
             , div [ class "park" ] [ text c.campsite.parkName.short ]
             ]
            )
        ]


bearingAndDistanceAsText : Maybe Location -> Maybe Location -> String
bearingAndDistanceAsText from to =
    Maybe.withDefault "" (Maybe.map2 Location.bearingAndDistanceText from to)
