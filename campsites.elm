module Main exposing (..)

import Html exposing (li, text, ul, Html)
import Html.Attributes exposing (class)


type alias Location =
    { latitude : Float, longitude : Float }


type alias Campsite =
    { name : String, location : Maybe Location }


campsites =
    [ Campsite "Acacia Flats" (Just (Location -33.6149 150.3553))
    , Campsite "Alexanders Hut" Nothing
    , Campsite "Apsley Falls" (Just (Location -31.0540415000018 151.762134053333))
    ]


main =
    ul [ class "campsite-list" ]
        (List.map campsiteListItem campsites)


campsiteListItem : Campsite -> Html msg
campsiteListItem campsite =
    li [] [ text (campsite.name ++ ", " ++ locationAsText campsite.location) ]


locationAsText : Maybe Location -> String
locationAsText location =
    case location of
        Just l ->
            toString l.latitude ++ ", " ++ toString l.longitude

        Nothing ->
            ""
