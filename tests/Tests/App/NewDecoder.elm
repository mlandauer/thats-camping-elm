module Tests.App.NewDecoder exposing (all)

import Test exposing (..)
import Expect
import Json.Decode
import App.NewDecoder exposing (..)
import Campsite
    exposing
        ( name
        , Toilets(..)
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
             --                       "_id": "1",
             --                       "_rev": "rev",
             --                       "name": "Campsite",
             --                       "description": "A lovely campsite",
             --                       "location": null,
             --                       "facilities": {
             --                         "toilets": null,
             --                         "picnicTables": null,
             --                         "barbecues": null,
             --                         "showers": null,
             --                         "drinkingWater": null
             --                       },
             --                       "access": {
             --                         "caravans": null,
             --                         "trailers": null,
             --                         "cars": null
             --                       },
             --                       "parkName": "Park"
             --                     }"""
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
        ]
