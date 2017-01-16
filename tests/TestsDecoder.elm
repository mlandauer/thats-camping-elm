module TestsDecoder exposing (..)

import Test exposing (..)
import Expect
import Json.Decode
import Decoder
import Location exposing (Location)
import Campsite exposing (Campsite)
import Park exposing (Park)


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
                        Expect.equal expected (Json.Decode.decodeString Decoder.locationDecoder json)
            , test "location data is absent" <|
                \() ->
                    let
                        json =
                            "{}"

                        expected =
                            Ok (Nothing)
                    in
                        Expect.equal expected (Json.Decode.decodeString Decoder.locationDecoder json)
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
                        Expect.equal expected (Json.Decode.decodeString Decoder.campsiteDecoder json)
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
                        Expect.equal expected (Json.Decode.decodeString Decoder.campsitesDecoder json)
            ]
        , describe "parkDecoder"
            [ test "example" <|
                \() ->
                    let
                        json =
                            """{ "id": 15, "shortName": "A park" }"""

                        expected =
                            Ok (Park 15 "A park")
                    in
                        Expect.equal expected (Json.Decode.decodeString Decoder.parkDecoder json)
            ]
        , describe "parksDecoder"
            [ test "example" <|
                \() ->
                    let
                        json =
                            """{"parks": [{ "id": 15, "shortName": "A park" }]}"""

                        expected =
                            Ok ([ Park 15 "A park" ])
                    in
                        Expect.equal expected (Json.Decode.decodeString Decoder.parksDecoder json)
            ]
        ]
