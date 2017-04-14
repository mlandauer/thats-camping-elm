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

                test =
                    testED ed
             in
                [ test Nothing null
                , test (Just NoToilets) (string "no")
                , test (Just FlushToilets) (string "flush")
                , test (Just NonFlushToilets) (string "non_flush")
                , Test.test "blah" <|
                    \() ->
                        Expect.equal True
                            (Result.Extra.isErr (Json.Decode.decodeString ed.decoder "\"blah\""))
                ]
            )
        , describe "picnicTables"
            (let
                test =
                    testED
                        { encoder = App.NewEncoder.picnicTables
                        , decoder = App.NewDecoder.picnicTables
                        }
             in
                [ test Nothing null
                , test (Just PicnicTables) (bool True)
                , test (Just NoPicnicTables) (bool False)
                ]
            )
        , describe "barbecues"
            (let
                ed =
                    { encoder = App.NewEncoder.barbecues
                    , decoder = App.NewDecoder.barbecues
                    }

                test =
                    testED ed
             in
                [ test Nothing null
                , test (Just WoodBarbecues) (string "wood")
                , test (Just WoodSuppliedBarbecues) (string "wood_supplied")
                , test (Just WoodBringYourOwnBarbecues) (string "wood_bring_your_own")
                , test (Just GasElectricBarbecues) (string "gas_electric")
                , test (Just NoBarbecues) (string "no")
                , Test.test "blah" <|
                    \() ->
                        Expect.equal True
                            (Result.Extra.isErr (Json.Decode.decodeString ed.decoder "\"blah\""))
                ]
            )
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
