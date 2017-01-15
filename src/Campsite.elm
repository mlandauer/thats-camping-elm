module Campsite exposing (Campsite, compareCampsite)

import Location exposing (Location)


type alias Campsite =
    -- { name : String, parkName : String, location : Maybe Location }
    { name : String, location : Maybe Location }


compareCampsite : Maybe Location -> Campsite -> Campsite -> Order
compareCampsite location c1 c2 =
    let
        d1 =
            Maybe.map2 Location.distanceInMetres location c1.location

        d2 =
            Maybe.map2 Location.distanceInMetres location c2.location
    in
        case d1 of
            Just d1 ->
                case d2 of
                    Just d2 ->
                        compare d1 d2

                    Nothing ->
                        LT

            Nothing ->
                case d2 of
                    Just d2 ->
                        GT

                    Nothing ->
                        compare c1.name c2.name
