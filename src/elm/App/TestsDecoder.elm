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
        , PicnicTables(..)
        , Barbecues(..)
        , Showers(..)
        , DrinkingWater(..)
        , Facilities
        , Access
        , Caravans(..)
        , Trailers(..)
        , Cars(..)
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
                    Expect.equal (Ok (Just NonFlushToilets)) (Json.Decode.decodeString App.Decoder.toilets "\"non_flush\"")
            , test "flush" <|
                \() ->
                    Expect.equal (Ok (Just FlushToilets)) (Json.Decode.decodeString App.Decoder.toilets "\"flush\"")
            , test "none" <|
                \() ->
                    Expect.equal (Ok (Just NoToilets)) (Json.Decode.decodeString App.Decoder.toilets "\"none\"")
            , test "invalid value" <|
                \() ->
                    Expect.equal (Ok Nothing) (Json.Decode.decodeString App.Decoder.toilets "\"foo\"")
            ]
        , describe "picnic tables"
            [ test "true" <|
                \() ->
                    Expect.equal (Ok (Just PicnicTables)) (Json.Decode.decodeString App.Decoder.picnicTables "true")
            , test "false" <|
                \() ->
                    Expect.equal (Ok (Just NoPicnicTables)) (Json.Decode.decodeString App.Decoder.picnicTables "false")
            ]
        , describe "barbecues"
            [ test "wood" <|
                \() ->
                    Expect.equal (Ok (Just WoodBarbecues)) (Json.Decode.decodeString App.Decoder.barbecues "\"wood\"")
            , test "wood_supplied" <|
                \() ->
                    Expect.equal (Ok (Just WoodSuppliedBarbecues)) (Json.Decode.decodeString App.Decoder.barbecues "\"wood_supplied\"")
            , test "wood_bring_your_own" <|
                \() ->
                    Expect.equal (Ok (Just WoodBringYourOwnBarbecues)) (Json.Decode.decodeString App.Decoder.barbecues "\"wood_bring_your_own\"")
            , test "gas_electric" <|
                \() ->
                    Expect.equal (Ok (Just GasElectricBarbecues)) (Json.Decode.decodeString App.Decoder.barbecues "\"gas_electric\"")
            , test "none" <|
                \() ->
                    Expect.equal (Ok (Just NoBarbecues)) (Json.Decode.decodeString App.Decoder.barbecues "\"none\"")
            , test "invalid value" <|
                \() ->
                    Expect.equal (Ok Nothing) (Json.Decode.decodeString App.Decoder.barbecues "\"foo\"")
            ]
        , describe "showers"
            [ test "hot" <|
                \() ->
                    Expect.equal (Ok (Just HotShowers)) (Json.Decode.decodeString App.Decoder.showers "\"hot\"")
            , test "cold" <|
                \() ->
                    Expect.equal (Ok (Just ColdShowers)) (Json.Decode.decodeString App.Decoder.showers "\"cold\"")
            , test "none" <|
                \() ->
                    Expect.equal (Ok (Just NoShowers)) (Json.Decode.decodeString App.Decoder.showers "\"none\"")
            , test "unknown" <|
                \() ->
                    Expect.equal (Ok Nothing) (Json.Decode.decodeString App.Decoder.showers "\"blah\"")
            ]
        , describe "drinking water"
            [ test "true" <|
                \() ->
                    Expect.equal (Ok (Just DrinkingWater)) (Json.Decode.decodeString App.Decoder.drinkingWater "true")
            , test "false" <|
                \() ->
                    Expect.equal (Ok (Just NoDrinkingWater)) (Json.Decode.decodeString App.Decoder.drinkingWater "false")
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
  "showers": "hot", "drinkingWater": false, "caravans": false, "trailers": false,
  "car": true
  }],
"parks": [{
  "id": 15, "shortName": "A park", "longName": "A long park",
  "description": "It's a nice park", "campsites": [4]
  }]
}
                            """

                        expected =
                            Ok
                                ({ campsites =
                                    [ Campsite "4"
                                        "Campsite"
                                        "Long Campsite"
                                        "description"
                                        (Just (Location -33 150))
                                        (Facilities
                                            (Just FlushToilets)
                                            (Just NoPicnicTables)
                                            (Just WoodBarbecues)
                                            (Just HotShowers)
                                            (Just NoDrinkingWater)
                                        )
                                        (Access
                                            (Just NoCaravans)
                                            (Just NoTrailers)
                                            (Just Cars)
                                        )
                                        "12"
                                    ]
                                 , parks = [ Park "15" "A park" "A long park" "It's a nice park" [ "4" ] ]
                                 }
                                )
                    in
                        Expect.equal expected (Json.Decode.decodeString App.Decoder.parksAndCampsites json)
            ]
        ]
