port module Leaflet
    exposing
        ( Marker
        , Map
        , mapCommand
        )

import Location exposing (Location)
import Dict exposing (Dict)


port mapVisibility : Bool -> Cmd msg


port createMarker : Marker -> Cmd msg


port updateMarker : Marker -> Cmd msg


port panMapTo : Location -> Cmd msg


type alias Marker =
    -- Do we want to get rid of the id here as it's stored elsewhere too?
    { id : String
    , html :
        -- Wish we could render a view here instead
        String
    , location : Location
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
        [ if newMap.markers /= oldMap.markers then
            markerCommand oldMap newMap
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


markerCommand : Map -> Map -> Cmd msg
markerCommand oldMap newMap =
    -- TODO: Also handle deleting markers
    Cmd.batch
        ((List.map createMarker (addedMarkers oldMap.markers newMap.markers))
            ++ (List.map updateMarker (changedMarkers oldMap.markers newMap.markers))
        )



-- The following all seems very long-winded. There's bound to be a more elegant way


addedMarkers : Dict String Marker -> Dict String Marker -> List Marker
addedMarkers oldMarkers newMarkers =
    List.filter (\marker -> not (Dict.member marker.id oldMarkers))
        (Dict.values newMarkers)


deletedMarkers : Dict String Marker -> Dict String Marker -> List Marker
deletedMarkers oldMarkers newMarkers =
    -- TODO: Not currently using deletedMarkers (see markerCommand above)
    addedMarkers newMarkers oldMarkers


changedMarkers : Dict String Marker -> Dict String Marker -> List Marker
changedMarkers oldMarkers newMarkers =
    List.filter
        (\marker ->
            case Dict.get marker.id oldMarkers of
                Just m2 ->
                    m2 /= marker

                Nothing ->
                    False
        )
        (Dict.values newMarkers)
