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
import App.NewEncoder exposing (..)
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
                    Expect.equal null
                        (toilets Nothing)
            , test "no toilets" <|
                \() ->
                    Expect.equal (string "no")
                        (toilets (Just NoToilets))
            , test "flush toilets" <|
                \() ->
                    Expect.equal (string "flush")
                        (toilets (Just FlushToilets))
            , test "non flush toilets" <|
                \() ->
                    Expect.equal (string "non_flush")
                        (toilets (Just NonFlushToilets))
            ]
        , describe "picnicTables"
            [ test "Nothing" <|
                \() ->
                    Expect.equal null
                        (picnicTables Nothing)
            , test "PicnicTables" <|
                \() ->
                    Expect.equal (bool True)
                        (picnicTables (Just PicnicTables))
            , test "NoPicnicTables" <|
                \() ->
                    Expect.equal (bool False)
                        (picnicTables (Just NoPicnicTables))
            ]
        , describe "barbecues"
            [ test "Nothing" <|
                \() ->
                    Expect.equal null
                        (barbecues Nothing)
            , test "WoodBarbecues" <|
                \() ->
                    Expect.equal (string "wood")
                        (barbecues (Just WoodBarbecues))
            , test "WoodSuppliedBarbecues" <|
                \() ->
                    Expect.equal (string "wood_supplied")
                        (barbecues (Just WoodSuppliedBarbecues))
            , test "WoodBringYourOwnBarbecues" <|
                \() ->
                    Expect.equal (string "wood_bring_your_own")
                        (barbecues (Just WoodBringYourOwnBarbecues))
            , test "GasElectricBarbecues" <|
                \() ->
                    Expect.equal (string "gas_electric")
                        (barbecues (Just GasElectricBarbecues))
            , test "NoBarbecues" <|
                \() ->
                    Expect.equal (string "no")
                        (barbecues (Just NoBarbecues))
            ]
        , describe "showers"
            [ test "Nothing" <|
                \() -> Expect.equal null (showers Nothing)
            , test "NoShowers" <|
                \() -> Expect.equal (string "no") (showers (Just NoShowers))
            , test "HotShowers" <|
                \() -> Expect.equal (string "hot") (showers (Just HotShowers))
            , test "ColdShowers" <|
                \() -> Expect.equal (string "cold") (showers (Just ColdShowers))
            ]
        , describe "drinkingWater"
            [ test "Nothing" <|
                \() -> Expect.equal null (drinkingWater Nothing)
            , test "NoDrinkingWater" <|
                \() -> Expect.equal (bool False) (drinkingWater (Just NoDrinkingWater))
            , test "DrinkingWater" <|
                \() -> Expect.equal (bool True) (drinkingWater (Just DrinkingWater))
            ]
        , describe "caravans"
            [ test "Nothing" <|
                \() -> Expect.equal null (caravans Nothing)
            , test "NoCaravans" <|
                \() -> Expect.equal (bool False) (caravans (Just NoCaravans))
            , test "Caravans" <|
                \() -> Expect.equal (bool True) (caravans (Just Caravans))
            ]
        , describe "trailers"
            [ test "Nothing" <|
                \() -> Expect.equal null (trailers Nothing)
            , test "NoTrailers" <|
                \() -> Expect.equal (bool False) (trailers (Just NoTrailers))
            , test "Trailers" <|
                \() -> Expect.equal (bool True) (trailers (Just Trailers))
            ]
        , describe "cars"
            [ test "Nothing" <|
                \() -> Expect.equal null (cars Nothing)
            , test "NoCars" <|
                \() -> Expect.equal (bool False) (cars (Just NoCars))
            , test "Cars" <|
                \() -> Expect.equal (bool True) (cars (Just Cars))
            ]
        ]
