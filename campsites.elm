import Html exposing (li, text, ul)
import Html.Attributes exposing (class)

type alias Campsite = {name: String}

c1 = Campsite "Acacia Flats"
c2 = Campsite "Alexanders Hut"
c3 = Campsite "Apsley Falls"

main =
  ul [class "campsite-list"]
    [ campsiteListItem c1
    , campsiteListItem c2
    , campsiteListItem c3
    ]

campsiteListItem campsite =
  li [] [text campsite.name]
