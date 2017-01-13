module Location
    exposing
        ( Location
        , distanceInMetres
        , bearingInDegrees
        , toString
        )


type alias Location =
    { latitude : Float, longitude : Float }


toString : Location -> String
toString location =
    "(" ++ Basics.toString location.latitude ++ ", " ++ Basics.toString location.longitude ++ ")"


distanceInMetres : Location -> Location -> Float
distanceInMetres position1 position2 =
    let
        r =
            6371000

        dLat =
            degrees (position2.latitude - position1.latitude)

        dLon =
            degrees (position2.longitude - position1.longitude)

        a =
            sin (dLat / 2) * sin (dLat / 2) + cos (degrees (position1.latitude)) * cos (degrees (position2.latitude)) * sin (dLon / 2) * sin (dLon / 2)

        c =
            2 * atan2 (sqrt a) (sqrt (1 - a))
    in
        r * c


bearingInDegrees : Location -> Location -> Float
bearingInDegrees position1 position2 =
    let
        lon2 =
            degrees position2.longitude

        lat2 =
            degrees position2.latitude

        lon1 =
            degrees position1.longitude

        lat1 =
            degrees position1.latitude

        dLon =
            lon1 - lon2

        y =
            sin (dLon) * cos (lat1)

        x =
            cos (lat2) * sin (lat1) - sin (lat2) * cos (lat1) * cos (dLon)

        bearing =
            (atan2 y x) / pi * 180
    in
        -- This returns a number between 0 and 360
        if bearing < 0 then
            bearing + 360
        else
            bearing
