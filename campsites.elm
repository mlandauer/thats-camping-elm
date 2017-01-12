import Html exposing (li, text, ul)
import Html.Attributes exposing (class)

main =
  ul [class "campsite-list"]
    [ campsiteListItem {name = "Acacia Flats"}
    , campsiteListItem {name = "Alexanders Hut"}
    , campsiteListItem {name = "Apsley Falls"}
    ]

campsiteListItem campsite =
  li [] [text campsite.name]
