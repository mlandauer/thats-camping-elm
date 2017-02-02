module Location
    exposing
        ( Location
        , distanceInMetres
        , bearingInDegrees
        , distanceText
        , bearingText
        , bearingAndDistanceText
        , distanceInMetresToText
        , bearingToText
        , modulo
        )

import Array


type alias Location =
    { latitude : Float, longitude : Float }


degrees : Location -> Location
degrees location =
    Location (Basics.degrees location.latitude) (Basics.degrees location.longitude)


distanceInMetres : Location -> Location -> Float
distanceInMetres from to =
    let
        t =
            degrees to

        f =
            degrees from

        r =
            6371000

        dLat =
            f.latitude - t.latitude

        dLon =
            f.longitude - t.longitude

        a =
            sin (dLat / 2) * sin (dLat / 2) + cos (t.latitude) * cos (f.latitude) * sin (dLon / 2) * sin (dLon / 2)

        c =
            2 * atan2 (sqrt a) (sqrt (1 - a))
    in
        r * c


bearingInDegrees : Location -> Location -> Float
bearingInDegrees from to =
    let
        t =
            degrees to

        f =
            degrees from

        dLon =
            t.longitude - f.longitude

        y =
            sin (dLon) * cos (t.latitude)

        x =
            cos (f.latitude) * sin (t.latitude) - sin (f.latitude) * cos (t.latitude) * cos (dLon)

        bearing =
            (atan2 y x) / pi * 180
    in
        modulo bearing 360


modulo : Float -> Float -> Float
modulo value mod =
    value - mod * toFloat (floor (value / mod))



-- TODO: Use type to represent distance in metres


distanceInMetresToText : Float -> String
distanceInMetresToText distance =
    if distance > 1000 then
        (toString (round (distance / 1000))) ++ " km"
    else
        (toString (round distance)) ++ " m"


distanceText : Location -> Location -> String
distanceText from to =
    distanceInMetresToText (distanceInMetres from to)



-- TODO: Use type to represent bearing in degrees


bearingToText : Float -> String
bearingToText bearing =
    let
        -- Dividing the compass into 8 sectors that are centred on north
        sector =
            round (bearing * 8 / 360) % 8

        sectorNames =
            Array.fromList [ "N", "NE", "E", "SE", "S", "SW", "W", "NW" ]
    in
        case (Array.get sector sectorNames) of
            Just v ->
                v

            Nothing ->
                -- We should never reach this code
                ""


bearingText : Location -> Location -> String
bearingText from to =
    bearingToText (bearingInDegrees from to)


bearingAndDistanceText : Location -> Location -> String
bearingAndDistanceText from to =
    (distanceText from to) ++ " " ++ (bearingText from to)
