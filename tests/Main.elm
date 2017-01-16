port module Main exposing (..)

import Test exposing (..)
import Test.Runner.Node exposing (run, TestProgram)
import Json.Encode exposing (Value)
import TestsDecoder
import TestsLocation
import TestsCampsite


main : TestProgram
main =
    run emit all


all : Test
all =
    describe "Test Suite"
        [ TestsDecoder.all
        , TestsLocation.all
        , TestsCampsite.all
        ]


port emit : ( String, Value ) -> Cmd msg
