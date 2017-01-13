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
                    approxEqual 1 73360 (Location.distanceInMetres (Location -34 151) (Location -33.6149 150.3553))
            ]
        , describe "bearingInDegrees"
            [ test "example" <|
                \() ->
                    approxEqual 1 305 (Location.bearingInDegrees (Location -34 151) (Location -33.6149 150.3553))
            ]
        , describe "distanceInMetresToText"
            [ test "distance in metres should be rounded to nearest integer" <|
                \() ->
                    Expect.equal "23 m" (Location.distanceInMetresToText 23.2)
            , test "distance in km should be rounded to nearest km" <|
                \() ->
                    Expect.equal "54 km" (Location.distanceInMetresToText 53850)
            ]
        ]



-- Should approxEqual really be in the Expect module?


approxEqual : Float -> Float -> Float -> Expect.Expectation
approxEqual tolerance expected actual =
    Expect.lessThan tolerance (abs (actual - expected))
