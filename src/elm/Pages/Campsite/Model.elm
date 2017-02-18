module Pages.Campsite.Model exposing (Model)

import Campsite exposing (Campsite)


type alias Model =
    { campsite : Campsite
    , starred : Bool
    , online : Bool
    }
