module TestsCampsite exposing (..)

import Test exposing (..)
import Expect
import Location exposing (Location)
import Campsite exposing (Campsite)
import App.ViewHelpers exposing (compareCampsite)


-- TODO: Move tests for compareCampsite to another module


all : Test
all =
    describe "Campsite"
        [ describe "compareCampsite"
            [ test "First campsite is closer than the second" <|
                \() ->
                    let
                        c1 =
                            { location = (Just (Location 1 2)), shortName = "" }

                        c2 =
                            { location = (Just (Location 1.5 2)), shortName = "" }

                        location =
                            Just (Location 1.1 2)
                    in
                        Expect.equal LT (compareCampsite location c1 c2)
            , test "Second campsite is closer than the first" <|
                \() ->
                    let
                        c1 =
                            { location = (Just (Location 1.5 2)), shortName = "" }

                        c2 =
                            { location = (Just (Location 1 2)), shortName = "" }

                        location =
                            Just (Location 1.1 2)
                    in
                        Expect.equal GT (compareCampsite location c1 c2)
            , test "First campsite is at an unknown location" <|
                \() ->
                    let
                        c1 =
                            { location = Nothing, shortName = "" }

                        c2 =
                            { location = (Just (Location 1.5 2)), shortName = "" }

                        location =
                            Just (Location 1.1 2)
                    in
                        Expect.equal GT (compareCampsite location c1 c2)
            , test "Second campsite is at an unknown location" <|
                \() ->
                    let
                        c1 =
                            { location = (Just (Location 1 2)), shortName = "" }

                        c2 =
                            { location = Nothing, shortName = "" }

                        location =
                            Just (Location 1.1 2)
                    in
                        Expect.equal LT (compareCampsite location c1 c2)
            , test "Both campsites are at an unknown location then sort alphabetically" <|
                \() ->
                    let
                        c1 =
                            { location = Nothing, shortName = "campsite 1" }

                        c2 =
                            { location = Nothing, shortName = "campsite 2" }

                        location =
                            Just (Location 1.1 2)
                    in
                        Expect.equal LT (compareCampsite location c1 c2)
            ]
        ]
