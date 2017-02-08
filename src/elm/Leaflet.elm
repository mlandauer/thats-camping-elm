port module Leaflet
    exposing
        ( mapVisibility
        , setMapMarkers
        , panMapTo
        , Marker
        )

import Location exposing (Location)


port mapVisibility : Bool -> Cmd msg


port setMapMarkers : List Marker -> Cmd msg


port panMapTo : Location -> Cmd msg


type alias Marker =
    { id : String
    , location : Location
    , html :
        -- Wish we could render a view here instead
        String
    }
