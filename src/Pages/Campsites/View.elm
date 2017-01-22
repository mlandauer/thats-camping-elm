module Pages.Campsites.View exposing (view, compareCampsite)

import Html exposing (..)
import Html.Attributes exposing (..)
import App.Model exposing (Campsite, Location, Park, Page(..))
import Dict exposing (Dict)
import Location
import Geolocation
import App.Update exposing (Msg)
import Pages.Campsites.Model exposing (..)
import App.ViewHelpers exposing (navBar, link)


view : Model -> Html Msg
view model =
    div [ class "campsite-list" ]
        [ navBar "Camping near you" False True
        , div [ class "content" ]
            -- TODO: Place all the errors under a single div
            ((List.map (\error -> (div [] [ text error ])) model.errors)
                ++ [ div [ class "list-group" ]
                        (List.map (campsiteListItem model.location model.parks) (sortCampsites model.location model.campsites))
                   ]
            )
        ]


campsiteListItem : Maybe Location -> Dict Int Park -> Campsite -> Html msg
campsiteListItem location parks campsite =
    link (CampsitePage campsite.id)
        [ class "list-group-item" ]
        [ div [ class "campsite" ]
            [ div [ class "pull-right distance" ] [ text (bearingAndDistanceAsText location campsite.location) ]
            , div [ class "name" ] [ text campsite.shortName ]
            , div [ class "park" ] [ text (parkNameFromId campsite.parkId parks) ]
            ]
        ]


sortCampsites : Maybe Location -> List Campsite -> List Campsite
sortCampsites location campsites =
    List.sortWith (compareCampsite location) campsites


parkNameFromId : Int -> Dict Int Park -> String
parkNameFromId id parks =
    case Dict.get id parks of
        Just park ->
            park.shortName

        Nothing ->
            ""


bearingAndDistanceAsText : Maybe Location -> Maybe Location -> String
bearingAndDistanceAsText from to =
    case (Maybe.map2 Location.bearingAndDistanceText from to) of
        Just text ->
            text

        Nothing ->
            ""



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
