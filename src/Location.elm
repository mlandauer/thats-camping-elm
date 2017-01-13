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
