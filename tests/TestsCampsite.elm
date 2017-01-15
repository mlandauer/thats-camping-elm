module TestsCampsite exposing (..)

import Test exposing (..)
import Expect
import Location exposing (Location)
import Campsite exposing (Campsite)


all : Test
all =
    describe "Campsite"
        [ describe "compareCampsite"
            [ test "First campsite is closer than the second" <|
                \() ->
                    let
                        c1 =
                            Campsite "campsite 1" (Just (Location 1 2))

                        c2 =
                            Campsite "campsite 2" (Just (Location 1.5 2))

                        location =
                            Just (Location 1.1 2)
                    in
                        Expect.equal LT (Campsite.compareCampsite location c1 c2)
            , test "Second campsite is closer than the first" <|
                \() ->
                    let
                        c1 =
                            Campsite "campsite 1" (Just (Location 1.5 2))

                        c2 =
                            Campsite "campsite 2" (Just (Location 1 2))

                        location =
                            Just (Location 1.1 2)
                    in
                        Expect.equal GT (Campsite.compareCampsite location c1 c2)
            , test "First campsite is at an unknown location" <|
                \() ->
                    let
                        c1 =
                            Campsite "campsite 1" Nothing

                        c2 =
                            Campsite "campsite 2" (Just (Location 1.5 2))

                        location =
                            Just (Location 1.1 2)
                    in
                        Expect.equal GT (Campsite.compareCampsite location c1 c2)
            , test "Second campsite is at an unknown location" <|
                \() ->
                    let
                        c1 =
                            Campsite "campsite 1" (Just (Location 1 2))

                        c2 =
                            Campsite "campsite 2" Nothing

                        location =
                            Just (Location 1.1 2)
                    in
                        Expect.equal LT (Campsite.compareCampsite location c1 c2)
            , test "Both campsites are at an unknown location then sort alphabetically" <|
                \() ->
                    let
                        c1 =
                            Campsite "campsite 1" Nothing

                        c2 =
                            Campsite "campsite 2" Nothing

                        location =
                            Just (Location 1.1 2)
                    in
                        Expect.equal LT (Campsite.compareCampsite location c1 c2)
            ]
        ]
