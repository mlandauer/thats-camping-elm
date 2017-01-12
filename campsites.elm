import Html exposing (li, text, ul)
import Html.Attributes exposing (class)

c1 = {name = "Acacia Flats"}
c2 = {name = "Alexanders Hut"}
c3 = {name = "Apsley Falls"}

main =
  ul [class "campsite-list"]
    [ campsiteListItem c1
    , campsiteListItem c2
    , campsiteListItem c3
    ]

campsiteListItem campsite =
  li [] [text campsite.name]
