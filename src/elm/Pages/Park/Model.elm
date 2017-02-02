module Pages.Park.Model exposing (Model)

import Campsite exposing (Campsite)
import Park exposing (Park)
import Location exposing (Location)
import Dict exposing (Dict)


type alias Model =
    { park : Park
    , campsites : List Campsite
    , parks : Dict String Park
    , location : Maybe Location
    }
