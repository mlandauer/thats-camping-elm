port module Leaflet
    exposing
        ( Marker
        , Map
        , mapCommand
        )

import Location exposing (Location)
import Dict exposing (Dict)


port mapVisibility : Bool -> Cmd msg


port createOrUpdateMarker : Marker -> Cmd msg


port panMapTo : Location -> Cmd msg


type alias Marker =
    -- Do we want to get rid of the id here as it's stored elsewhere too?
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
    , markers : Dict String Marker
    }


mapCommand : Map -> Map -> Cmd msg
mapCommand oldMap newMap =
    Cmd.batch
        ((markerCommands oldMap newMap)
            ++ [ if newMap.visible /= oldMap.visible then
                    mapVisibility newMap.visible
                 else
                    Cmd.none
               , if newMap.center /= oldMap.center then
                    panMapTo newMap.center
                 else
                    Cmd.none
               ]
        )


markerCommands : Map -> Map -> List (Cmd msg)
markerCommands oldMap newMap =
    -- TODO: Also handle deleting markers
    -- TODO: Only call createOrUpdateMarker if marker has actually changed
    List.map createOrUpdateMarker (Dict.values newMap.markers)
