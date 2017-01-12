module Main exposing (..)

import Html exposing (li, text, ul, Html)
import Html.Attributes exposing (class)


type alias Campsite =
    { name : String }


campsites =
    [ Campsite "Acacia Flats", Campsite "Alexanders Hut", Campsite "Apsley Falls" ]


main =
    ul [ class "campsite-list" ]
        (List.map campsiteListItem campsites)


campsiteListItem : Campsite -> Html msg
campsiteListItem campsite =
    li [] [ text campsite.name ]
