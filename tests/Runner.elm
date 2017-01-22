port module Runner exposing (..)

import Test exposing (..)
import Test.Runner.Html
import Json.Encode exposing (Value)
import App.TestsDecoder
import TestsLocation
import TestsCampsite
import Libs.SimpleFormat.Tests
import Pages.Campsite.Tests


main : Test.Runner.Html.TestProgram
main =
    Test.Runner.Html.run all


all : Test
all =
    describe "Test Suite"
        [ App.TestsDecoder.all
        , TestsLocation.all
        , TestsCampsite.all
        , Libs.SimpleFormat.Tests.all
        , Pages.Campsite.Tests.all
        ]


port emit : ( String, Value ) -> Cmd msg
