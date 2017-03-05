module Pages.Admin.Model exposing (Model, initModel)

import Dict exposing (Dict)
import Campsite exposing (Campsite)
import Errors


type alias Model =
    { campsites : Dict String Campsite
    , errors : Errors.Model
    }


initModel : Model
initModel =
    { campsites = Dict.empty, errors = Errors.initModel }
