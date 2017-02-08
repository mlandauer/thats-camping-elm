port module Leaflet
    exposing
        ( panMapTo
        , Marker
        , Map
        , mapCommand
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


type alias Map =
    -- Holds the whole state for a map in one lump
    -- We're not including the center of the map because that can be changed by the user too
    { visible : Bool
    , markers : List Marker
    }


mapCommand : Map -> Cmd msg
mapCommand map =
    -- We're updating mostly EVERYTHING to do with the map on ANY change
    -- TODO: Do some optimisation
    Cmd.batch
        [ setMapMarkers map.markers
        , mapVisibility map.visible
        ]
