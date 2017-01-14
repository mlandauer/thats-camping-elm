module TestsData exposing (..)

import Test exposing (..)
import Expect
import Json.Decode
import Data
import Location exposing (Location)
import Campsite exposing (Campsite)


all : Test
all =
    describe "Data"
        [ describe "locationDecoder"
            [ test "location data is present" <|
                \() ->
                    let
                        json =
                            """{ "latitude": -33, "longitude": 150 }"""

                        expected =
                            Ok (Just (Location -33 150))
                    in
                        Expect.equal expected (Json.Decode.decodeString Data.locationDecoder json)
            , test "location data is absent" <|
                \() ->
                    let
                        json =
                            "{}"

                        expected =
                            Ok (Nothing)
                    in
                        Expect.equal expected (Json.Decode.decodeString Data.locationDecoder json)
            ]
        , describe "campsiteDecoder"
            [ test "example" <|
                \() ->
                    let
                        json =
                            """{ "shortName": "Campsite", "latitude": -33, "longitude": 150 }"""

                        expected =
                            Ok (Campsite "Campsite" (Just (Location -33 150)))
                    in
                        Expect.equal expected (Json.Decode.decodeString Data.campsiteDecoder json)
            ]
        , describe "campsitesDecoder"
            [ test "example" <|
                \() ->
                    let
                        json =
                            """{"campsites": [{ "shortName": "Campsite", "latitude": -33, "longitude": 150 }]}"""

                        expected =
                            Ok ([ Campsite "Campsite" (Just (Location -33 150)) ])
                    in
                        Expect.equal expected (Json.Decode.decodeString Data.campsitesDecoder json)
            ]
        ]
