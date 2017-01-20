module TestsCampsite exposing (..)

import Test exposing (..)
import Expect
import App.Model exposing (Location, Campsite)
import Pages.Campsites.View exposing (compareCampsite)


-- TODO: Move tests for compareCampsite to another module


all : Test
all =
    describe "Campsite"
        [ describe "compareCampsite"
            [ test "First campsite is closer than the second" <|
                \() ->
                    let
                        c1 =
                            Campsite 1 "campsite 1" "campsite 1" (Just (Location 1 2)) 1

                        c2 =
                            Campsite 2 "campsite 2" "campsite 2" (Just (Location 1.5 2)) 1

                        location =
                            Just (Location 1.1 2)
                    in
                        Expect.equal LT (compareCampsite location c1 c2)
            , test "Second campsite is closer than the first" <|
                \() ->
                    let
                        c1 =
                            Campsite 1 "campsite 1" "campsite 1" (Just (Location 1.5 2)) 1

                        c2 =
                            Campsite 2 "campsite 2" "campsite 2" (Just (Location 1 2)) 1

                        location =
                            Just (Location 1.1 2)
                    in
                        Expect.equal GT (compareCampsite location c1 c2)
            , test "First campsite is at an unknown location" <|
                \() ->
                    let
                        c1 =
                            Campsite 1 "campsite 1" "campsite 1" Nothing 1

                        c2 =
                            Campsite 2 "campsite 2" "campsite 2" (Just (Location 1.5 2)) 1

                        location =
                            Just (Location 1.1 2)
                    in
                        Expect.equal GT (compareCampsite location c1 c2)
            , test "Second campsite is at an unknown location" <|
                \() ->
                    let
                        c1 =
                            Campsite 1 "campsite 1" "campsite 1" (Just (Location 1 2)) 1

                        c2 =
                            Campsite 2 "campsite 2" "campsite 2" Nothing 1

                        location =
                            Just (Location 1.1 2)
                    in
                        Expect.equal LT (compareCampsite location c1 c2)
            , test "Both campsites are at an unknown location then sort alphabetically" <|
                \() ->
                    let
                        c1 =
                            Campsite 1 "campsite 1" "campsite 1" Nothing 1

                        c2 =
                            Campsite 2 "campsite 2" "campsite 2" Nothing 1

                        location =
                            Just (Location 1.1 2)
                    in
                        Expect.equal LT (compareCampsite location c1 c2)
            ]
        ]
