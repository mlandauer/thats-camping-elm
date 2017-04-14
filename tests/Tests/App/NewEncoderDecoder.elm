module Tests.App.NewEncoderDecoder exposing (all)

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
import Location exposing (Location)


type alias EncoderDecoder t =
    -- Represents a pair of json encoders/decoders.
    { encoder : t -> Value, decoder : Decoder t }



{- Test that we can encode something and it gives a particular result and
   when we decode it it gives the same initial result back
-}
-- TODO: Give this function a better name


testED : EncoderDecoder t -> t -> Value -> Test
testED ed v json =
    describe (Json.Encode.encode 0 json)
        [ test "encode" <|
            \() ->
                Expect.equal json (ed.encoder v)
        , test "decode" <|
            \() ->
                Expect.equal (Ok v) (Json.Decode.decodeValue ed.decoder json)
        ]


all : Test
all =
    describe "NewEncoderDecoder"
        [ describe "campsite"
            [ testED
                { encoder = App.NewEncoder.campsite
                , decoder = App.NewDecoder.campsite
                }
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
                (object
                    [ ( "_id", string "1" )
                    , ( "_rev", string "rev" )
                    , ( "name", string "Campsite" )
                    , ( "description", string "A lovely campsite" )
                    , ( "location", null )
                    , ( "facilities"
                      , object
                            [ ( "toilets", null )
                            , ( "picnicTables", null )
                            , ( "barbecues", null )
                            , ( "showers", null )
                            , ( "drinkingWater", null )
                            ]
                      )
                    , ( "access"
                      , object
                            [ ( "caravans", null )
                            , ( "trailers", null )
                            , ( "cars", null )
                            ]
                      )
                    , ( "parkName", string "Park" )
                    ]
                )
            ]
        , describe "location"
            [ testED
                { encoder = App.NewEncoder.location, decoder = App.NewDecoder.location }
                (Location 1.0 2.0)
                (object
                    [ ( "latitude", float 1 )
                    , ( "longitude", float 2 )
                    ]
                )
            , test "a location" <|
                \() ->
                    let
                        l =
                            Location 1.0 2.0

                        expected =
                            object
                                [ ( "latitude", float 1 )
                                , ( "longitude", float 2 )
                                ]
                    in
                        Expect.equal expected (App.NewEncoder.location l)
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
            (let
                ed =
                    { encoder = App.NewEncoder.showers
                    , decoder = App.NewDecoder.showers
                    }

                test =
                    testED ed
             in
                [ test (Just HotShowers) (string "hot")
                , test (Just ColdShowers) (string "cold")
                , test (Just NoShowers) (string "no")
                , test Nothing null
                , Test.test "blah" <|
                    \() ->
                        Expect.equal True
                            (Result.Extra.isErr (Json.Decode.decodeString ed.decoder "\"blah\""))
                ]
            )
        , describe "drinkingWater"
            (let
                test =
                    testED
                        { encoder = App.NewEncoder.drinkingWater
                        , decoder = App.NewDecoder.drinkingWater
                        }
             in
                [ test Nothing null
                , test (Just NoDrinkingWater) (bool False)
                , test (Just DrinkingWater) (bool True)
                ]
            )
        , describe "caravans"
            (let
                test =
                    testED
                        { encoder = App.NewEncoder.caravans
                        , decoder = App.NewDecoder.caravans
                        }
             in
                [ test Nothing null
                , test (Just NoCaravans) (bool False)
                , test (Just Caravans) (bool True)
                ]
            )
        , describe "trailers"
            (let
                test =
                    testED
                        { encoder = App.NewEncoder.trailers
                        , decoder = App.NewDecoder.trailers
                        }
             in
                [ test Nothing null
                , test (Just NoTrailers) (bool False)
                , test (Just Trailers) (bool True)
                ]
            )
        , describe "cars"
            (let
                test =
                    testED
                        { encoder = App.NewEncoder.cars
                        , decoder = App.NewDecoder.cars
                        }
             in
                [ test Nothing null
                , test (Just NoCars) (bool False)
                , test (Just Cars) (bool True)
                ]
            )
        ]
