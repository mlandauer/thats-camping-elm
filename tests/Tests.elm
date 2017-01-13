module Tests exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, tuple, string)
import String
import Location exposing (Location)


all : Test
all =
    describe "Location"
        [ describe "distanceInMetres"
            [ test "example" <|
                \() ->
                    Expect.lessThan 1 (abs ((Location.distanceInMetres (Location -33.6149 150.3553) (Location -34 151)) - 73360))
            ]
        , describe "bearingInDegrees"
            [ test "example" <|
                \() ->
                    Expect.lessThan 1 (abs ((Location.bearingInDegrees (Location -33.6149 150.3553) (Location -34 151)) - 305))
            ]
        ]
