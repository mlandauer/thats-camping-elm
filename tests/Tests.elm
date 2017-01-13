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
        , describe "mod360"
            [ test "number between 0 and 360" <|
                \() ->
                    Expect.equal 350 (Location.mod360 350)
            , test "number 360" <|
                \() ->
                    Expect.equal 0 (Location.mod360 360)
            , test "number between 360 and 720" <|
                \() ->
                    Expect.equal 40 (Location.mod360 400)
              -- We're making this more general than we strictly need to
            , test "number between 720 and 1080" <|
                \() ->
                    Expect.equal 50 (Location.mod360 770)
            , test "number between -360 and 0" <|
                \() ->
                    Expect.equal 10 (Location.mod360 -350)
            , test "number -360" <|
                \() ->
                    Expect.equal 0 (Location.mod360 -360)
            , test "number between -720 and -360" <|
                \() ->
                    Expect.equal 220 (Location.mod360 -500)
            ]
        ]



-- Should approxEqual really be in the Expect module?


approxEqual : Float -> Float -> Float -> Expect.Expectation
approxEqual tolerance expected actual =
    Expect.lessThan tolerance (abs (actual - expected))
