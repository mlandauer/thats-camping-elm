module Pages.Tour.Model exposing (Model)

import Location exposing (Location)
import Campsite exposing (Campsite)


type alias Model =
    { campsites : List Campsite
    , location : Maybe Location
    , starredCampsites : List String
    }
