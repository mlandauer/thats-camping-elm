module Pages.Park.Model exposing (Model)

import App.Model exposing (Park, Location)
import Dict exposing (Dict)


type alias Model =
    { park : Park
    , parks : Dict Int Park
    , location : Maybe Location
    }
