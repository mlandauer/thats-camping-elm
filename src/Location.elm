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


degrees : Location -> Location
degrees location =
    Location (Basics.degrees location.latitude) (Basics.degrees location.longitude)


distanceInMetres : Location -> Location -> Float
distanceInMetres position1 position2 =
    let
        p1 =
            degrees position1

        p2 =
            degrees position2

        r =
            6371000

        dLat =
            p2.latitude - p1.latitude

        dLon =
            p2.longitude - p1.longitude

        a =
            sin (dLat / 2) * sin (dLat / 2) + cos (p1.latitude) * cos (p2.latitude) * sin (dLon / 2) * sin (dLon / 2)

        c =
            2 * atan2 (sqrt a) (sqrt (1 - a))
    in
        r * c


bearingInDegrees : Location -> Location -> Float
bearingInDegrees position1 position2 =
    let
        p1 =
            degrees position1

        p2 =
            degrees position2

        dLon =
            p1.longitude - p2.longitude

        y =
            sin (dLon) * cos (p1.latitude)

        x =
            cos (p2.latitude) * sin (p1.latitude) - sin (p2.latitude) * cos (p1.latitude) * cos (dLon)

        bearing =
            (atan2 y x) / pi * 180
    in
        -- This returns a number between 0 and 360
        if bearing < 0 then
            bearing + 360
        else
            bearing
