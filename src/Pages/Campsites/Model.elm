module Pages.Campsites.Model exposing (Model)

import App.Model exposing (Error, Location, Park, Campsite)
import Dict exposing (Dict)


type alias Model =
    { campsites : List Campsite
    , parks : Dict Int Park
    , location : Maybe Location
    , error : Maybe Error
    }
