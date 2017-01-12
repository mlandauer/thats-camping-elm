import Html exposing (li, text, ul)
import Html.Attributes exposing (class)

main =
  ul [class "campsite-list"]
    [ campsiteListItem "Acacia Flats"
    , campsiteListItem "Alexanders Hut"
    , campsiteListItem "Apsley Falls"
    ]

campsiteListItem name =
  li [] [text name]
