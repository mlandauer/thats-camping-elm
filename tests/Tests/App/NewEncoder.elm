module Tests.App.NewEncoder exposing (all)

import Test exposing (..)
import Expect
import Campsite
    exposing
        ( name
        , Toilets(..)
        )
import App.NewEncoder exposing (..)
import Json.Encode exposing (object, string, null, float)
import Location exposing (Location)


all : Test
all =
    describe "NewEncoder"
        [ describe "campsite"
            [ test "test example 1" <|
                \() ->
                    let
                        c =
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

                        expected =
                            object
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
                    in
                        Expect.equal expected (campsite c)
            ]
        , describe "location"
            [ test "a location" <|
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
                        Expect.equal expected (location l)
            ]
        , describe "toilets"
            [ test "Nothing" <|
                \() ->
                    Expect.equal null (toilets Nothing)
            , test "no toilets" <|
                \() ->
                    Expect.equal (string "no") (toilets (Just NoToilets))
            , test "flush toilets" <|
                \() ->
                    Expect.equal (string "flush") (toilets (Just FlushToilets))
            , test "non flush toilets" <|
                \() ->
                    Expect.equal (string "non_flush") (toilets (Just NonFlushToilets))
            ]
        ]
