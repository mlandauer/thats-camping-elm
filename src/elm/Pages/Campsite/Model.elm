module Pages.Campsite.Model exposing (Model)

import Campsite exposing (Campsite)
import Park exposing (Park)


type alias Model =
    { campsite : Campsite
    , park : Maybe Park
    }
