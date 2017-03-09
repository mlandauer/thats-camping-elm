module Tests.Location exposing (all)

import Test exposing (..)
import Expect
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
        , describe "bearingToText"
            [ test "north 1" <|
                \() ->
                    Expect.equal "N" (Location.bearingToText 0)
            , test "north 2" <|
                \() ->
                    Expect.equal "N" (Location.bearingToText -22.5)
            , test "north 3" <|
                \() ->
                    Expect.equal "N" (Location.bearingToText 22.4)
            , test "north east 1" <|
                \() ->
                    Expect.equal "NE" (Location.bearingToText 22.5)
            , test "north east 2" <|
                \() ->
                    Expect.equal "NE" (Location.bearingToText 45)
            , test "north east 3" <|
                \() ->
                    Expect.equal "NE" (Location.bearingToText 67.4)
            , test "east" <|
                \() ->
                    Expect.equal "E" (Location.bearingToText 67.5)
            , test "north west" <|
                \() ->
                    Expect.equal "NW" (Location.bearingToText -22.6)
            ]
        , describe "modulo"
            [ test "number between 0 and 360" <|
                \() ->
                    Expect.equal 350 (Location.modulo 350 360)
            , test "number 360" <|
                \() ->
                    Expect.equal 0 (Location.modulo 360 360)
            , test "number between 360 and 720" <|
                \() ->
                    Expect.equal 40 (Location.modulo 400 360)
              -- We're making this more general than we strictly need to
            , test "number between 720 and 1080" <|
                \() ->
                    Expect.equal 50 (Location.modulo 770 360)
            , test "number between -360 and 0" <|
                \() ->
                    Expect.equal 10 (Location.modulo -350 360)
            , test "number -360" <|
                \() ->
                    Expect.equal 0 (Location.modulo -360 360)
            , test "number between -720 and -360" <|
                \() ->
                    Expect.equal 220 (Location.modulo -500 360)
            ]
        ]



-- Should approxEqual really be in the Expect module?


approxEqual : Float -> Float -> Float -> Expect.Expectation
approxEqual tolerance expected actual =
    Expect.lessThan tolerance (abs (actual - expected))
