module Tests.App.EncoderDecoder exposing (all)

import Test exposing (..)
import Expect
import App.Decoder
import App.Encoder
import Campsite
    exposing
        ( name
        , ToiletsCore(..)
        , Tri(..)
        , BarbecuesCore(..)
        , ShowersCore(..)
        , DrinkingWaterCore(..)
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
                { encoder = App.Encoder.campsite
                , decoder = App.Decoder.campsite
                }
                { id = "1"
                , name = name "Campsite"
                , description = "A lovely campsite"
                , location =
                    Nothing
                , facilities =
                    { toilets = Unknown
                    , picnicTables = Unknown
                    , barbecues = Unknown
                    , showers = Unknown
                    , drinkingWater = Nothing
                    }
                , access =
                    { caravans = Unknown
                    , trailers = Unknown
                    , cars = Unknown
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
                { encoder = App.Encoder.location, decoder = App.Decoder.location }
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
                        Expect.equal expected (App.Encoder.location l)
            ]
        , describe "toilets"
            (let
                ed =
                    { encoder = App.Encoder.toilets
                    , decoder = App.Decoder.toilets
                    }

                test =
                    testED ed
             in
                [ test Unknown null
                , test No (string "no")
                , test (Yes FlushToilets) (string "flush")
                , test (Yes NonFlushToilets) (string "non_flush")
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
                        { encoder = App.Encoder.picnicTables
                        , decoder = App.Decoder.picnicTables
                        }
             in
                [ test Unknown null
                , test (Yes ()) (bool True)
                , test No (bool False)
                ]
            )
        , describe "barbecues"
            (let
                ed =
                    { encoder = App.Encoder.barbecues
                    , decoder = App.Decoder.barbecues
                    }

                test =
                    testED ed
             in
                [ test Unknown null
                , test (Yes WoodBarbecues) (string "wood")
                , test (Yes WoodSuppliedBarbecues) (string "wood_supplied")
                , test (Yes WoodBringYourOwnBarbecues) (string "wood_bring_your_own")
                , test (Yes GasElectricBarbecues) (string "gas_electric")
                , test No (string "no")
                , Test.test "blah" <|
                    \() ->
                        Expect.equal True
                            (Result.Extra.isErr (Json.Decode.decodeString ed.decoder "\"blah\""))
                ]
            )
        , describe "showers"
            (let
                ed =
                    { encoder = App.Encoder.showers
                    , decoder = App.Decoder.showers
                    }

                test =
                    testED ed
             in
                [ test (Yes HotShowers) (string "hot")
                , test (Yes ColdShowers) (string "cold")
                , test No (string "no")
                , test Unknown null
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
                        { encoder = App.Encoder.drinkingWater
                        , decoder = App.Decoder.drinkingWater
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
                        { encoder = App.Encoder.caravans
                        , decoder = App.Decoder.caravans
                        }
             in
                [ test Unknown null
                , test No (bool False)
                , test (Yes ()) (bool True)
                ]
            )
        , describe "trailers"
            (let
                test =
                    testED
                        { encoder = App.Encoder.trailers
                        , decoder = App.Decoder.trailers
                        }
             in
                [ test Unknown null
                , test No (bool False)
                , test (Yes ()) (bool True)
                ]
            )
        , describe "cars"
            (let
                test =
                    testED
                        { encoder = App.Encoder.cars
                        , decoder = App.Decoder.cars
                        }
             in
                [ test Unknown null
                , test No (bool False)
                , test (Yes ()) (bool True)
                ]
            )
        ]
