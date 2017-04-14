module Tests.App.NewEncoder exposing (all)

import Test exposing (..)
import Expect
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
import App.NewEncoder
import Json.Encode exposing (object, string, null, float, bool)
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
                        Expect.equal expected (App.NewEncoder.campsite c)
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
                        Expect.equal expected (App.NewEncoder.location l)
            ]
        , describe "drinkingWater"
            [ test "Nothing" <|
                \() -> Expect.equal null (App.NewEncoder.drinkingWater Nothing)
            , test "NoDrinkingWater" <|
                \() -> Expect.equal (bool False) (App.NewEncoder.drinkingWater (Just NoDrinkingWater))
            , test "DrinkingWater" <|
                \() -> Expect.equal (bool True) (App.NewEncoder.drinkingWater (Just DrinkingWater))
            ]
        , describe "caravans"
            [ test "Nothing" <|
                \() -> Expect.equal null (App.NewEncoder.caravans Nothing)
            , test "NoCaravans" <|
                \() -> Expect.equal (bool False) (App.NewEncoder.caravans (Just NoCaravans))
            , test "Caravans" <|
                \() -> Expect.equal (bool True) (App.NewEncoder.caravans (Just Caravans))
            ]
        , describe "trailers"
            [ test "Nothing" <|
                \() -> Expect.equal null (App.NewEncoder.trailers Nothing)
            , test "NoTrailers" <|
                \() -> Expect.equal (bool False) (App.NewEncoder.trailers (Just NoTrailers))
            , test "Trailers" <|
                \() -> Expect.equal (bool True) (App.NewEncoder.trailers (Just Trailers))
            ]
        , describe "cars"
            [ test "Nothing" <|
                \() -> Expect.equal null (App.NewEncoder.cars Nothing)
            , test "NoCars" <|
                \() -> Expect.equal (bool False) (App.NewEncoder.cars (Just NoCars))
            , test "Cars" <|
                \() -> Expect.equal (bool True) (App.NewEncoder.cars (Just Cars))
            ]
        ]
