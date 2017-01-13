module Location
    exposing
        ( Location
        , distanceInMetres
        , bearingInDegrees
        , distanceText
        , bearingText
        , distanceInMetresToText
        )


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
        -- This returns a number between 0 and 360
        if bearing < 0 then
            bearing + 360
        else
            bearing



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
    (toString bearing) ++ " degrees"


bearingText : Location -> Location -> String
bearingText from to =
    bearingToText (bearingInDegrees from to)
