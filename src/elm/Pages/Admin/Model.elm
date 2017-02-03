module Pages.Admin.Model exposing (Model, initModel)

import Dict exposing (Dict)
import Campsite exposing (Campsite)


type alias Model =
    { text : Maybe String
    , campsites : Dict String Campsite
    }


initModel : Model
initModel =
    { text = Nothing, campsites = Dict.empty }
