module App.TestsDecoder exposing (..)

import Test exposing (..)
import Expect
import Json.Decode
import App.Decoder
import App.Model
    exposing
        ( Location
        , Campsite
        , Park
        , Toilets(..)
        , Barbecues(..)
        , Showers(..)
        , Facilities
        )


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
                    Expect.equal (Ok NonFlushToilets) (Json.Decode.decodeString App.Decoder.toilets "\"non_flush\"")
            , test "flush" <|
                \() ->
                    Expect.equal (Ok FlushToilets) (Json.Decode.decodeString App.Decoder.toilets "\"flush\"")
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
                    Expect.equal (Ok WoodBarbecues) (Json.Decode.decodeString App.Decoder.barbecues "\"wood\"")
            , test "wood_supplied" <|
                \() ->
                    Expect.equal (Ok WoodSuppliedBarbecues) (Json.Decode.decodeString App.Decoder.barbecues "\"wood_supplied\"")
            , test "wood_bring_your_own" <|
                \() ->
                    Expect.equal (Ok WoodBringYourOwnBarbecues) (Json.Decode.decodeString App.Decoder.barbecues "\"wood_bring_your_own\"")
            , test "gas_electric" <|
                \() ->
                    Expect.equal (Ok GasElectricBarbecues) (Json.Decode.decodeString App.Decoder.barbecues "\"gas_electric\"")
            , test "none" <|
                \() ->
                    Expect.equal (Ok NoBarbecues) (Json.Decode.decodeString App.Decoder.barbecues "\"none\"")
            , test "invalid value" <|
                \() ->
                    Expect.equal (Ok UnknownBarbecues) (Json.Decode.decodeString App.Decoder.barbecues "\"foo\"")
            ]
        , describe "showers"
            [ test "hot" <|
                \() ->
                    Expect.equal (Ok HotShowers) (Json.Decode.decodeString App.Decoder.showers "\"hot\"")
            , test "cold" <|
                \() ->
                    Expect.equal (Ok ColdShowers) (Json.Decode.decodeString App.Decoder.showers "\"cold\"")
            , test "none" <|
                \() ->
                    Expect.equal (Ok NoShowers) (Json.Decode.decodeString App.Decoder.showers "\"none\"")
            , test "unknown" <|
                \() ->
                    Expect.equal (Ok UnknownShowers) (Json.Decode.decodeString App.Decoder.showers "\"blah\"")
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
  "park": 12, "toilets": "flush", "picnicTables": false, "barbecues": "wood",
  "showers": "hot"
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
                                        (Facilities FlushToilets False WoodBarbecues HotShowers)
                                        12
                                    ]
                                 , parks = [ Park 15 "A park" "A long park" ]
                                 }
                                )
                    in
                        Expect.equal expected (Json.Decode.decodeString App.Decoder.parksAndCampsites json)
            ]
        ]
