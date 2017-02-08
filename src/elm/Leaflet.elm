port module Leaflet
    exposing
        ( Marker
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
    { visible : Bool
    , center : Location
    , markers : List Marker
    }


mapCommand : Map -> Map -> Cmd msg
mapCommand oldMap newMap =
    Cmd.batch
        [ if newMap.markers /= oldMap.markers then
            setMapMarkers newMap.markers
          else
            Cmd.none
        , if newMap.visible /= oldMap.visible then
            mapVisibility newMap.visible
          else
            Cmd.none
        , if newMap.center /= oldMap.center then
            panMapTo newMap.center
          else
            Cmd.none
        ]
