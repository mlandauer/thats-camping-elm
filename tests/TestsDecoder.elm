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
        [ describe "location"
            [ test "location data is present" <|
                \() ->
                    let
                        json =
                            """{ "latitude": -33, "longitude": 150 }"""

                        expected =
                            Ok (Just (Location -33 150))
                    in
                        Expect.equal expected (Json.Decode.decodeString Decoder.location json)
            , test "location data is absent" <|
                \() ->
                    let
                        json =
                            "{}"

                        expected =
                            Ok (Nothing)
                    in
                        Expect.equal expected (Json.Decode.decodeString Decoder.location json)
            ]
        , describe "campsite"
            [ test "example" <|
                \() ->
                    let
                        json =
                            """{ "shortName": "Campsite", "latitude": -33, "longitude": 150 }"""

                        expected =
                            Ok (Campsite "Campsite" (Just (Location -33 150)))
                    in
                        Expect.equal expected (Json.Decode.decodeString Decoder.campsite json)
            ]
        , describe "campsites"
            [ test "example" <|
                \() ->
                    let
                        json =
                            """{"campsites": [{ "shortName": "Campsite", "latitude": -33, "longitude": 150 }]}"""

                        expected =
                            Ok ([ Campsite "Campsite" (Just (Location -33 150)) ])
                    in
                        Expect.equal expected (Json.Decode.decodeString Decoder.campsites json)
            ]
        , describe "park"
            [ test "example" <|
                \() ->
                    let
                        json =
                            """{ "id": 15, "shortName": "A park" }"""

                        expected =
                            Ok (Park 15 "A park")
                    in
                        Expect.equal expected (Json.Decode.decodeString Decoder.park json)
            ]
        , describe "parks"
            [ test "example" <|
                \() ->
                    let
                        json =
                            """{"parks": [{ "id": 15, "shortName": "A park" }]}"""

                        expected =
                            Ok ([ Park 15 "A park" ])
                    in
                        Expect.equal expected (Json.Decode.decodeString Decoder.parks json)
            ]
        , describe "parksAndCampsites"
            [ test "example" <|
                \() ->
                    let
                        json =
                            """{"campsites": [{ "shortName": "Campsite", "latitude": -33, "longitude": 150 }], "parks": [{ "id": 15, "shortName": "A park" }]}"""

                        expected =
                            Ok ({ campsites = [ Campsite "Campsite" (Just (Location -33 150)) ], parks = [ Park 15 "A park" ] })
                    in
                        Expect.equal expected (Json.Decode.decodeString Decoder.parksAndCampsites json)
            ]
        ]
