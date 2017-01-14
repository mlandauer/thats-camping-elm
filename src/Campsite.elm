module Campsite exposing (Campsite)

import Location exposing (Location)


type alias Campsite =
    -- { name : String, parkName : String, location : Maybe Location }
    { name : String, location : Maybe Location }
