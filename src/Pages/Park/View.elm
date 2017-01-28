module Pages.Park.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)


view park =
    p [] [ text ("This is a park detail page for " ++ park.shortName) ]
