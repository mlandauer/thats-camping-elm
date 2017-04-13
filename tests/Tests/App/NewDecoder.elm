module Tests.App.NewDecoder exposing (all)

import Test exposing (..)
import Expect
import Json.Decode
import App.NewDecoder exposing (..)
import Campsite
    exposing
        ( name
        , Toilets(..)
        , PicnicTables(..)
        , Barbecues(..)
        , Showers(..)
        )
import Result.Extra


all : Test
all =
    describe "NewEncoder"
        [ describe "campsite"
            [-- test "A test" <|
             --     \() ->
             --         let
             --             json =
             --                 """{
             --                        "_id": "1",
             --                        "_rev": "rev",
             --                        "name": "Campsite",
             --                        "description": "A lovely campsite",
             --                        "location": null,
             --                        "facilities": {
             --                          "toilets": null,
             --                          "picnicTables": null,
             --                          "barbecues": null,
             --                          "showers": null,
             --                          "drinkingWater": null
             --                        },
             --                        "access": {
             --                          "caravans": null,
             --                          "trailers": null,
             --                          "cars": null
             --                        },
             --                        "parkName": "Park"
             --                      }"""
             --
             --             expected =
             --                 Ok
             --                     { id = "1"
             --                     , name = name "Campsite"
             --                     , description = "A lovely campsite"
             --                     , location =
             --                         Nothing
             --                     , facilities =
             --                         { toilets = Nothing
             --                         , picnicTables = Nothing
             --                         , barbecues = Nothing
             --                         , showers = Nothing
             --                         , drinkingWater = Nothing
             --                         }
             --                     , access =
             --                         { caravans = Nothing
             --                         , trailers = Nothing
             --                         , cars = Nothing
             --                         }
             --                     , parkName = name "Park"
             --                     , revision = Just "rev"
             --                     }
             --         in
             --             Expect.equal expected (Json.Decode.decodeString campsite json)
            ]
        , describe "toilets"
            [ test "non_flush" <|
                \() ->
                    Expect.equal (Ok (Just NonFlushToilets))
                        (Json.Decode.decodeString toilets "\"non_flush\"")
            , test "flush" <|
                \() ->
                    Expect.equal (Ok (Just FlushToilets))
                        (Json.Decode.decodeString toilets "\"flush\"")
            , test "no" <|
                \() ->
                    Expect.equal (Ok (Just NoToilets))
                        (Json.Decode.decodeString toilets "\"no\"")
            , test "null" <|
                \() ->
                    Expect.equal (Ok Nothing)
                        (Json.Decode.decodeString toilets "null")
            , test "blah" <|
                \() ->
                    Expect.equal True
                        (Result.Extra.isErr (Json.Decode.decodeString toilets "\"blah\""))
            ]
        , describe "picnicTables"
            [ test "true" <|
                \() ->
                    Expect.equal (Ok (Just PicnicTables))
                        (Json.Decode.decodeString picnicTables "true")
            , test "false" <|
                \() ->
                    Expect.equal (Ok (Just NoPicnicTables))
                        (Json.Decode.decodeString picnicTables "false")
            , test "null" <|
                \() ->
                    Expect.equal (Ok Nothing)
                        (Json.Decode.decodeString picnicTables "null")
            ]
        , describe "barbecues"
            [ test "wood" <|
                \() ->
                    Expect.equal (Ok (Just WoodBarbecues))
                        (Json.Decode.decodeString barbecues "\"wood\"")
            , test "wood_supplied" <|
                \() ->
                    Expect.equal (Ok (Just WoodSuppliedBarbecues))
                        (Json.Decode.decodeString barbecues "\"wood_supplied\"")
            , test "wood_bring_your_own" <|
                \() ->
                    Expect.equal (Ok (Just WoodBringYourOwnBarbecues))
                        (Json.Decode.decodeString barbecues "\"wood_bring_your_own\"")
            , test "gas_electric" <|
                \() ->
                    Expect.equal (Ok (Just GasElectricBarbecues))
                        (Json.Decode.decodeString barbecues "\"gas_electric\"")
            , test "no" <|
                \() ->
                    Expect.equal (Ok (Just NoBarbecues))
                        (Json.Decode.decodeString barbecues "\"no\"")
            , test "blah" <|
                \() ->
                    Expect.equal True
                        (Result.Extra.isErr (Json.Decode.decodeString barbecues "\"blah\""))
            , test "null" <|
                \() ->
                    Expect.equal (Ok Nothing)
                        (Json.Decode.decodeString barbecues "null")
            ]
        , describe "showers"
            [ test "hot" <|
                \() ->
                    Expect.equal (Ok (Just HotShowers))
                        (Json.Decode.decodeString showers "\"hot\"")
            , test "cold" <|
                \() ->
                    Expect.equal (Ok (Just ColdShowers))
                        (Json.Decode.decodeString showers "\"cold\"")
            , test "no" <|
                \() ->
                    Expect.equal (Ok (Just NoShowers))
                        (Json.Decode.decodeString showers "\"no\"")
            , test "blah" <|
                \() ->
                    Expect.equal True
                        (Result.Extra.isErr (Json.Decode.decodeString showers "\"blah\""))
            , test "null" <|
                \() ->
                    Expect.equal (Ok Nothing)
                        (Json.Decode.decodeString showers "null")
            ]
        ]
