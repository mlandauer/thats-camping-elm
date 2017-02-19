module TestsCampsite exposing (..)

import Test exposing (..)
import Expect
import Campsite exposing (..)


all : Test
all =
    describe "Campsite"
        [ describe "shortenCampsiteName"
            [ test "A short name" <|
                \() ->
                    Expect.equal "A short name"
                        (shortenCampsiteName "A short name")
            , test "Behrs Flat campground" <|
                \() ->
                    Expect.equal "Behrs Flat"
                        (shortenCampsiteName "Behrs Flat campground")
            , test "Heartbreak Hill camping area" <|
                \() ->
                    Expect.equal "Heartbreak Hill"
                        (shortenCampsiteName "Heartbreak Hill camping area")
            ]
        ]
