import Html exposing (li, text, ul)
import Html.Attributes exposing (class)

main =
  ul [class "campsite-list"]
    [ li [] [text "Acacia Flats"]
    , li [] [text "Alexanders Hut"]
    , li [] [text "Apsley Falls"]
    ]
