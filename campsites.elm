module Main exposing (..)

import Html exposing (li, text, ul, Html)
import Html.Attributes exposing (class)


type alias Campsite =
    { name : String }


c1 =
    Campsite "Acacia Flats"


c2 =
    Campsite "Alexanders Hut"


c3 =
    Campsite "Apsley Falls"


main =
    ul [ class "campsite-list" ]
        (List.map campsiteListItem [ c1, c2, c3 ])


campsiteListItem : Campsite -> Html msg
campsiteListItem campsite =
    li [] [ text campsite.name ]
