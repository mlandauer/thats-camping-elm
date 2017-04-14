port module Main exposing (..)

import Test exposing (..)
import Test.Runner.Node
import Json.Encode exposing (Value)
import Tests.App.GitHubDecoder
import Tests.App.EncoderDecoder
import Tests.Location
import Tests.Campsite
import Tests.SimpleFormat
import Tests.Pages.Campsite
import Tests.App.Update


main : Test.Runner.Node.TestProgram
main =
    Test.Runner.Node.run emit all


all : Test
all =
    describe "Test Suite"
        [ Tests.App.GitHubDecoder.all
        , Tests.App.EncoderDecoder.all
        , Tests.Location.all
        , Tests.Campsite.all
        , Tests.SimpleFormat.all
        , Tests.Pages.Campsite.all
        , Tests.App.Update.all
        ]


port emit : ( String, Value ) -> Cmd msg
