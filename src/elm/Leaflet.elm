port module Leaflet
    exposing
        ( Marker
        , Map
        , mapCommand
        , MarkerIcon(..)
        , markerClicked
        )

import Location exposing (Location)
import Dict exposing (Dict)


port mapVisibility : Bool -> Cmd msg


port createMarker : TranslatedMarker -> Cmd msg


port updateMarker : TranslatedMarker -> Cmd msg


port panMapTo : Location -> Cmd msg


port markerClicked : (String -> msg) -> Sub msg


type MarkerIcon
    = Default
    | Star


type alias TranslatedMarker =
    { id : String
    , icon : Int
    , html :
        -- Wish we could render a view here instead
        String
    , location : Location
    }


type alias Marker =
    { id : String
    , icon : MarkerIcon
    , html :
        -- Wish we could render a view here instead
        String
    , location : Location
    }


markerIconIndex : MarkerIcon -> Int
markerIconIndex icon =
    case icon of
        Default ->
            0

        Star ->
            1


translateMarker : Marker -> TranslatedMarker
translateMarker marker =
    { id = marker.id, icon = markerIconIndex marker.icon, html = marker.html, location = marker.location }


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
            markerCommand (dictify oldMap.markers) (dictify newMap.markers)
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


dictify : List Marker -> Dict String Marker
dictify markers =
    markers |> List.map (\m -> ( m.id, m )) |> Dict.fromList


markerCommand : Dict String Marker -> Dict String Marker -> Cmd msg
markerCommand oldMarkers newMarkers =
    -- TODO: Also handle deleting markers
    Cmd.batch
        ((List.map (\m -> createMarker (translateMarker m))
            (addedMarkers oldMarkers newMarkers)
         )
            ++ (List.map (\m -> updateMarker (translateMarker m))
                    (changedMarkers oldMarkers newMarkers)
               )
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
