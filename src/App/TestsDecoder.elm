module App.TestsDecoder exposing (..)

import Test exposing (..)
import Expect
import Json.Decode
import App.Decoder
import App.Model exposing (Location, Campsite, Park, Toilets(..), Barbecues(..), Facilities)


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
                    Expect.equal (Ok NoToilets) (Json.Decode.decodeString App.Decoder.toilets "\"none\"")
            , test "invalid value" <|
                \() ->
                    Expect.equal (Ok UnknownToilets) (Json.Decode.decodeString App.Decoder.toilets "\"foo\"")
            ]
        , describe "barbecues"
            [ test "wood" <|
                \() ->
                    Expect.equal (Ok Wood) (Json.Decode.decodeString App.Decoder.barbecues "\"wood\"")
            , test "wood_supplied" <|
                \() ->
                    Expect.equal (Ok WoodSupplied) (Json.Decode.decodeString App.Decoder.barbecues "\"wood_supplied\"")
            , test "wood_bring_your_own" <|
                \() ->
                    Expect.equal (Ok WoodBringYourOwn) (Json.Decode.decodeString App.Decoder.barbecues "\"wood_bring_your_own\"")
            , test "gas_electric" <|
                \() ->
                    Expect.equal (Ok GasElectric) (Json.Decode.decodeString App.Decoder.barbecues "\"gas_electric\"")
            , test "none" <|
                \() ->
                    Expect.equal (Ok NoBarbecues) (Json.Decode.decodeString App.Decoder.barbecues "\"none\"")
            , test "invalid value" <|
                \() ->
                    Expect.equal (Ok UnknownBarbecues) (Json.Decode.decodeString App.Decoder.barbecues "\"foo\"")
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
  "park": 12, "toilets": "flush", "picnicTables": false, "barbecues": "wood"
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
                                        (Facilities Flush False Wood)
                                        12
                                    ]
                                 , parks = [ Park 15 "A park" "A long park" ]
                                 }
                                )
                    in
                        Expect.equal expected (Json.Decode.decodeString App.Decoder.parksAndCampsites json)
            ]
        ]
