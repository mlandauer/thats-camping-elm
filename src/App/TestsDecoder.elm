module App.TestsDecoder exposing (..)

import Test exposing (..)
import Expect
import Json.Decode
import App.Decoder
import App.Model exposing (Location, Campsite, Park, Toilets(..), Facilities)


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
                        Expect.equal expected (Json.Decode.decodeString App.Decoder.location json)
            , test "location data is absent" <|
                \() ->
                    let
                        json =
                            "{}"

                        expected =
                            Ok (Nothing)
                    in
                        Expect.equal expected (Json.Decode.decodeString App.Decoder.location json)
            ]
        , describe "toilets"
            [ test "non flush" <|
                \() ->
                    Expect.equal (Ok NonFlush) (Json.Decode.decodeString App.Decoder.toilets "\"non_flush\"")
            , test "flush" <|
                \() ->
                    Expect.equal (Ok Flush) (Json.Decode.decodeString App.Decoder.toilets "\"flush\"")
            , test "none" <|
                \() ->
                    Expect.equal (Ok None) (Json.Decode.decodeString App.Decoder.toilets "\"none\"")
            , test "invalid value" <|
                \() ->
                    Expect.equal (Ok Unknown) (Json.Decode.decodeString App.Decoder.toilets "\"foo\"")
            ]
        , describe "parksAndCampsites"
            [ test "example" <|
                \() ->
                    let
                        json =
                            """
{
"campsites": [{
  "id": 4, "shortName": "Campsite", "longName":"Long Campsite",
  "description": "description", "latitude": -33, "longitude": 150,
  "park": 12, "toilets": "flush", "picnicTables": false
  }],
"parks": [{
  "id": 15, "shortName": "A park", "longName": "A long park"
  }]
}
                            """

                        expected =
                            Ok
                                ({ campsites =
                                    [ Campsite 4
                                        "Campsite"
                                        "Long Campsite"
                                        "description"
                                        (Just (Location -33 150))
                                        (Facilities Flush False)
                                        12
                                    ]
                                 , parks = [ Park 15 "A park" "A long park" ]
                                 }
                                )
                    in
                        Expect.equal expected (Json.Decode.decodeString App.Decoder.parksAndCampsites json)
            ]
        ]
