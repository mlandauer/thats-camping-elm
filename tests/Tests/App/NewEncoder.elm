module Tests.App.NewEncoder exposing (all)

import Test exposing (..)
import Expect
import Campsite exposing (name)
import App.NewEncoder
import Json.Encode exposing (object, string, null, float)
import Location exposing (Location)


all : Test
all =
    describe "NewEncoder"
        [ describe "campsite"
            [ test "test example 1" <|
                \() ->
                    let
                        campsite =
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
                            , revision = Nothing
                            }

                        expected =
                            object
                                [ ( "_id", string "1" )
                                , ( "_rev", null )
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
                        Expect.equal expected (App.NewEncoder.campsite campsite)
            ]
        , describe "revision"
            [ test "Nothing" <|
                \() ->
                    Expect.equal null (App.NewEncoder.revision Nothing)
            , test "1" <|
                \() ->
                    Expect.equal (string "1") (App.NewEncoder.revision (Just "1"))
            ]
        , describe "maybeLocation"
            [ test "Nothing" <|
                \() ->
                    Expect.equal null (App.NewEncoder.maybeLocation Nothing)
            , test "a location" <|
                \() ->
                    let
                        location =
                            Just (Location 1.0 2.0)

                        expected =
                            object
                                [ ( "latitude", float 1 )
                                , ( "longitude", float 2 )
                                ]
                    in
                        Expect.equal expected (App.NewEncoder.maybeLocation location)
            ]
        ]
