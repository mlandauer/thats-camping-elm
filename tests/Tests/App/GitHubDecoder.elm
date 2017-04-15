module Tests.App.GitHubDecoder exposing (all)

import Test exposing (..)
import Expect
import Json.Decode
import App.GitHubDecoder
import Campsite
    exposing
        ( Campsite
        , Facilities
        , Access
        , Tri(..)
        , BarbecuesCore(..)
        , DrinkingWaterCore(..)
        )
import Location exposing (Location)
import Result.Extra


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
                        Expect.equal expected (Json.Decode.decodeString App.GitHubDecoder.location json)
            , test "location data is absent" <|
                \() ->
                    let
                        json =
                            "{}"

                        expected =
                            Ok (Nothing)
                    in
                        Expect.equal expected (Json.Decode.decodeString App.GitHubDecoder.location json)
            ]
        , describe "toilets"
            [ test "non flush" <|
                \() ->
                    Expect.equal (Ok (Yes False))
                        (Json.Decode.decodeString App.GitHubDecoder.toilets "\"non_flush\"")
            , test "flush" <|
                \() ->
                    Expect.equal (Ok (Yes True))
                        (Json.Decode.decodeString App.GitHubDecoder.toilets "\"flush\"")
            , test "none" <|
                \() ->
                    Expect.equal (Ok No)
                        (Json.Decode.decodeString App.GitHubDecoder.toilets "\"none\"")
            , test "invalid value" <|
                \() ->
                    Expect.equal True
                        (Result.Extra.isErr (Json.Decode.decodeString App.GitHubDecoder.toilets "\"foo\""))
            ]
        , describe "picnic tables"
            [ test "true" <|
                \() ->
                    Expect.equal (Ok (Yes ())) (Json.Decode.decodeString App.GitHubDecoder.picnicTables "true")
            , test "false" <|
                \() ->
                    Expect.equal (Ok No) (Json.Decode.decodeString App.GitHubDecoder.picnicTables "false")
            ]
        , describe "barbecues"
            [ test "wood" <|
                \() ->
                    Expect.equal (Ok (Yes WoodBarbecues))
                        (Json.Decode.decodeString App.GitHubDecoder.barbecues "\"wood\"")
            , test "wood_supplied" <|
                \() ->
                    Expect.equal (Ok (Yes WoodSuppliedBarbecues))
                        (Json.Decode.decodeString App.GitHubDecoder.barbecues "\"wood_supplied\"")
            , test "wood_bring_your_own" <|
                \() ->
                    Expect.equal (Ok (Yes WoodBringYourOwnBarbecues))
                        (Json.Decode.decodeString App.GitHubDecoder.barbecues "\"wood_bring_your_own\"")
            , test "gas_electric" <|
                \() ->
                    Expect.equal (Ok (Yes GasElectricBarbecues))
                        (Json.Decode.decodeString App.GitHubDecoder.barbecues "\"gas_electric\"")
            , test "none" <|
                \() ->
                    Expect.equal (Ok No)
                        (Json.Decode.decodeString App.GitHubDecoder.barbecues "\"none\"")
            , test "invalid value" <|
                \() ->
                    Expect.equal True
                        (Result.Extra.isErr (Json.Decode.decodeString App.GitHubDecoder.barbecues "\"foo\""))
            ]
        , describe "showers"
            [ test "hot" <|
                \() ->
                    Expect.equal (Ok (Yes True))
                        (Json.Decode.decodeString App.GitHubDecoder.showers "\"hot\"")
            , test "cold" <|
                \() ->
                    Expect.equal (Ok (Yes False))
                        (Json.Decode.decodeString App.GitHubDecoder.showers "\"cold\"")
            , test "none" <|
                \() ->
                    Expect.equal (Ok No)
                        (Json.Decode.decodeString App.GitHubDecoder.showers "\"none\"")
            , test "unknown" <|
                \() ->
                    Expect.equal True
                        (Result.Extra.isErr (Json.Decode.decodeString App.GitHubDecoder.showers "\"blah\""))
            ]
        , describe "drinking water"
            [ test "true" <|
                \() ->
                    Expect.equal (Ok (Just DrinkingWater)) (Json.Decode.decodeString App.GitHubDecoder.drinkingWater "true")
            , test "false" <|
                \() ->
                    Expect.equal (Ok (Just NoDrinkingWater)) (Json.Decode.decodeString App.GitHubDecoder.drinkingWater "false")
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
                                    [ App.GitHubDecoder.Campsite
                                        "c4"
                                        "Campsite"
                                        "Long Campsite"
                                        "description"
                                        (Just (Location -33 150))
                                        (Facilities
                                            (Yes True)
                                            No
                                            (Yes WoodBarbecues)
                                            (Yes True)
                                            (Just NoDrinkingWater)
                                        )
                                        (Access
                                            No
                                            No
                                            (Yes ())
                                        )
                                        "p12"
                                    ]
                                 , parks =
                                    [ App.GitHubDecoder.Park
                                        "p15"
                                        "A park"
                                        "A long park"
                                        "It's a nice park"
                                        [ "c4" ]
                                    ]
                                 }
                                )
                    in
                        Expect.equal expected (Json.Decode.decodeString App.GitHubDecoder.parksAndCampsites json)
            ]
        ]
