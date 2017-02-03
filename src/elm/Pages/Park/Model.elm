module Pages.Park.Model exposing (Model)

import Campsite exposing (Campsite)
import Park exposing (Park)
import Location exposing (Location)
import Dict exposing (Dict)


-- TODO: Make a new campsite type that has whether it is starred in it too.
-- This should make things cleaner


type alias Model =
    { park : Park
    , campsites : List Campsite
    , parks : Dict String Park
    , location : Maybe Location
    , starredCampsites : List String
    }
