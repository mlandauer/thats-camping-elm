module Tests.App.NewDecoder exposing (all)

import Test exposing (..)
import Expect
import App.NewDecoder
import App.NewEncoder
import Campsite
    exposing
        ( name
        , Toilets(..)
        , PicnicTables(..)
        , Barbecues(..)
        , Showers(..)
        , DrinkingWater(..)
        , Caravans(..)
        , Trailers(..)
        , Cars(..)
        )
import Result.Extra
import Json.Encode exposing (object, string, null, float, bool, Value)
import Json.Decode exposing (Decoder)


type alias EncoderDecoder t =
    -- Represents a pair of json encoders/decoders.
    { encoder : t -> Value, decoder : Decoder t }



{- Test that we can encode something and it gives a particular result and
   when we decode it it gives the same initial result back
-}
-- TODO: Give this function a better name


testED : EncoderDecoder t -> t -> Value -> Test
testED ed v json =
    let
        jsonString =
            (Json.Encode.encode 0 json)
    in
        describe jsonString
            [ test "encode" <|
                \() -> Expect.equal json (ed.encoder v)
            , test "decode" <|
                \() ->
                    Expect.equal (Ok v)
                        (Json.Decode.decodeString ed.decoder jsonString)
            ]


all : Test
all =
    describe "NewEncoder"
        [ describe "campsite"
            [ test "A test" <|
                \() ->
                    let
                        json =
                            """{
                                    "_id": "1",
                                    "_rev": "rev",
                                    "name": "Campsite",
                                    "description": "A lovely campsite",
                                    "location": null,
                                    "facilities": {
                                      "toilets": null,
                                      "picnicTables": null,
                                      "barbecues": null,
                                      "showers": null,
                                      "drinkingWater": null
                                    },
                                    "access": {
                                      "caravans": null,
                                      "trailers": null,
                                      "cars": null
                                    },
                                    "parkName": "Park"
                                  }"""

                        expected =
                            Ok
                                { id = "1"
                                , name = name "Campsite"
                                , description = "A lovely campsite"
                                , location =
                                    Nothing
                                , facilities =
                                    { toilets = Nothing
                                    , picnicTables = Nothing
                                    , barbecues = Nothing
                                    , showers = Nothing
                                    , drinkingWater = Nothing
                                    }
                                , access =
                                    { caravans = Nothing
                                    , trailers = Nothing
                                    , cars = Nothing
                                    }
                                , parkName = name "Park"
                                , revision = Just "rev"
                                }
                    in
                        Expect.equal expected (Json.Decode.decodeString App.NewDecoder.campsite json)
            ]
        , describe "toilets"
            (let
                ed =
                    { encoder = App.NewEncoder.toilets
                    , decoder = App.NewDecoder.toilets
                    }
             in
                [ testED ed Nothing null
                , testED ed (Just NoToilets) (string "no")
                , testED ed (Just FlushToilets) (string "flush")
                , testED ed (Just NonFlushToilets) (string "non_flush")
                , test "blah" <|
                    \() ->
                        Expect.equal True
                            (Result.Extra.isErr (Json.Decode.decodeString ed.decoder "\"blah\""))
                ]
            )
        , describe "picnicTables"
            (let
                ed =
                    { encoder = App.NewEncoder.picnicTables
                    , decoder = App.NewDecoder.picnicTables
                    }
             in
                [ testED ed Nothing null
                , testED ed (Just PicnicTables) (bool True)
                , testED ed (Just NoPicnicTables) (bool False)
                ]
            )
        , describe "barbecues"
            [ test "wood" <|
                \() ->
                    Expect.equal (Ok (Just WoodBarbecues))
                        (Json.Decode.decodeString App.NewDecoder.barbecues "\"wood\"")
            , test "wood_supplied" <|
                \() ->
                    Expect.equal (Ok (Just WoodSuppliedBarbecues))
                        (Json.Decode.decodeString App.NewDecoder.barbecues "\"wood_supplied\"")
            , test "wood_bring_your_own" <|
                \() ->
                    Expect.equal (Ok (Just WoodBringYourOwnBarbecues))
                        (Json.Decode.decodeString App.NewDecoder.barbecues "\"wood_bring_your_own\"")
            , test "gas_electric" <|
                \() ->
                    Expect.equal (Ok (Just GasElectricBarbecues))
                        (Json.Decode.decodeString App.NewDecoder.barbecues "\"gas_electric\"")
            , test "no" <|
                \() ->
                    Expect.equal (Ok (Just NoBarbecues))
                        (Json.Decode.decodeString App.NewDecoder.barbecues "\"no\"")
            , test "blah" <|
                \() ->
                    Expect.equal True
                        (Result.Extra.isErr (Json.Decode.decodeString App.NewDecoder.barbecues "\"blah\""))
            , test "null" <|
                \() ->
                    Expect.equal (Ok Nothing)
                        (Json.Decode.decodeString App.NewDecoder.barbecues "null")
            ]
        , describe "barbecues"
            [ test "Nothing" <|
                \() ->
                    Expect.equal null
                        (App.NewEncoder.barbecues Nothing)
            , test "WoodBarbecues" <|
                \() ->
                    Expect.equal (string "wood")
                        (App.NewEncoder.barbecues (Just WoodBarbecues))
            , test "WoodSuppliedBarbecues" <|
                \() ->
                    Expect.equal (string "wood_supplied")
                        (App.NewEncoder.barbecues (Just WoodSuppliedBarbecues))
            , test "WoodBringYourOwnBarbecues" <|
                \() ->
                    Expect.equal (string "wood_bring_your_own")
                        (App.NewEncoder.barbecues (Just WoodBringYourOwnBarbecues))
            , test "GasElectricBarbecues" <|
                \() ->
                    Expect.equal (string "gas_electric")
                        (App.NewEncoder.barbecues (Just GasElectricBarbecues))
            , test "NoBarbecues" <|
                \() ->
                    Expect.equal (string "no")
                        (App.NewEncoder.barbecues (Just NoBarbecues))
            ]
        , describe "showers"
            [ test "hot" <|
                \() ->
                    Expect.equal (Ok (Just HotShowers))
                        (Json.Decode.decodeString App.NewDecoder.showers "\"hot\"")
            , test "cold" <|
                \() ->
                    Expect.equal (Ok (Just ColdShowers))
                        (Json.Decode.decodeString App.NewDecoder.showers "\"cold\"")
            , test "no" <|
                \() ->
                    Expect.equal (Ok (Just NoShowers))
                        (Json.Decode.decodeString App.NewDecoder.showers "\"no\"")
            , test "blah" <|
                \() ->
                    Expect.equal True
                        (Result.Extra.isErr (Json.Decode.decodeString App.NewDecoder.showers "\"blah\""))
            , test "null" <|
                \() ->
                    Expect.equal (Ok Nothing)
                        (Json.Decode.decodeString App.NewDecoder.showers "null")
            ]
        , describe "showers"
            [ test "Nothing" <|
                \() -> Expect.equal null (App.NewEncoder.showers Nothing)
            , test "NoShowers" <|
                \() -> Expect.equal (string "no") (App.NewEncoder.showers (Just NoShowers))
            , test "HotShowers" <|
                \() -> Expect.equal (string "hot") (App.NewEncoder.showers (Just HotShowers))
            , test "ColdShowers" <|
                \() -> Expect.equal (string "cold") (App.NewEncoder.showers (Just ColdShowers))
            ]
        , describe "drinkingWater"
            [ test "true" <|
                \() ->
                    Expect.equal (Ok (Just DrinkingWater))
                        (Json.Decode.decodeString App.NewDecoder.drinkingWater "true")
            , test "false" <|
                \() ->
                    Expect.equal (Ok (Just NoDrinkingWater))
                        (Json.Decode.decodeString App.NewDecoder.drinkingWater "false")
            , test "null" <|
                \() ->
                    Expect.equal (Ok Nothing)
                        (Json.Decode.decodeString App.NewDecoder.drinkingWater "null")
            ]
        , describe "caravans"
            [ test "true" <|
                \() ->
                    Expect.equal (Ok (Just Caravans))
                        (Json.Decode.decodeString App.NewDecoder.caravans "true")
            , test "false" <|
                \() ->
                    Expect.equal (Ok (Just NoCaravans))
                        (Json.Decode.decodeString App.NewDecoder.caravans "false")
            , test "null" <|
                \() ->
                    Expect.equal (Ok Nothing)
                        (Json.Decode.decodeString App.NewDecoder.caravans "null")
            ]
        , describe "trailers"
            [ test "true" <|
                \() ->
                    Expect.equal (Ok (Just Trailers))
                        (Json.Decode.decodeString App.NewDecoder.trailers "true")
            , test "false" <|
                \() ->
                    Expect.equal (Ok (Just NoTrailers))
                        (Json.Decode.decodeString App.NewDecoder.trailers "false")
            , test "null" <|
                \() ->
                    Expect.equal (Ok Nothing)
                        (Json.Decode.decodeString App.NewDecoder.trailers "null")
            ]
        , describe "cars"
            [ test "true" <|
                \() ->
                    Expect.equal (Ok (Just Cars))
                        (Json.Decode.decodeString App.NewDecoder.cars "true")
            , test "false" <|
                \() ->
                    Expect.equal (Ok (Just NoCars))
                        (Json.Decode.decodeString App.NewDecoder.cars "false")
            , test "null" <|
                \() ->
                    Expect.equal (Ok Nothing)
                        (Json.Decode.decodeString App.NewDecoder.cars "null")
            ]
        ]
