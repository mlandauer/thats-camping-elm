port module Main exposing (..)

import Test exposing (..)
import Test.Runner.Html
import Json.Encode exposing (Value)
import TestsDecoder
import TestsLocation
import TestsCampsite


main : Test.Runner.Html.TestProgram
main =
    Test.Runner.Html.run all


all : Test
all =
    describe "Test Suite"
        [ TestsDecoder.all
        , TestsLocation.all
        , TestsCampsite.all
        ]


port emit : ( String, Value ) -> Cmd msg
