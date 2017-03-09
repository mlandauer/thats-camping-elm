port module Main exposing (..)

import Test exposing (..)
import Test.Runner.Node
import Json.Encode exposing (Value)
import App.TestsDecoder
import TestsLocation
import TestsCampsite
import TestsSimpleFormat
import Pages.Campsite.Tests
import App.TestsUpdate


main : Test.Runner.Node.TestProgram
main =
    Test.Runner.Node.run emit all


all : Test
all =
    describe "Test Suite"
        [ App.TestsDecoder.all
        , TestsLocation.all
        , TestsCampsite.all
        , TestsSimpleFormat.all
        , Pages.Campsite.Tests.all
        , App.TestsUpdate.all
        ]


port emit : ( String, Value ) -> Cmd msg
