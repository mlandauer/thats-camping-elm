module Main exposing (..)

import Html exposing (li, text, ul, Html)
import Html.Attributes exposing (class)


type alias Campsite =
    { name : String, latitude : Maybe Float, longitude : Maybe Float }


campsites =
    [ Campsite "Acacia Flats" (Just -33.6149) (Just 150.3553)
    , Campsite "Alexanders Hut" Nothing Nothing
    , Campsite "Apsley Falls" (Just -31.0540415000018) (Just 151.762134053333)
    ]


main =
    ul [ class "campsite-list" ]
        (List.map campsiteListItem campsites)


campsiteListItem : Campsite -> Html msg
campsiteListItem campsite =
    li [] [ text campsite.name ]
