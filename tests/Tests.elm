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
                    approxEqual 1 73360 (Location.distanceInMetres (Location -33.6149 150.3553) (Location -34 151))
            ]
        , describe "bearingInDegrees"
            [ test "example" <|
                \() ->
                    approxEqual 1 305 (Location.bearingInDegrees (Location -33.6149 150.3553) (Location -34 151))
            ]
        ]



-- Should approxEqual really be in the Expect module?


approxEqual : Float -> Float -> Float -> Expect.Expectation
approxEqual tolerance expected actual =
    Expect.lessThan tolerance (abs (actual - expected))
