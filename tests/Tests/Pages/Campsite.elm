module Tests.Pages.Campsite exposing (all)

import Test exposing (..)
import Expect
import Campsite
    exposing
        ( ToiletsCore(..)
        , PicnicTablesCore(..)
        , Tri(..)
        , BarbecuesCore(..)
        , ShowersCore(..)
        , DrinkingWaterCore(..)
        , TrailersCore(..)
        , CarsCore(..)
        )
import Pages.Campsite.View exposing (..)


all : Test
all =
    describe "Pages.Campsite.View"
        [ describe "facilitiesText"
            [ test "example 1" <|
                \() ->
                    Expect.equal
                        "Has flush toilets, picnic tables, wood BBQs, hot showers and drinking water."
                        (facilitiesText
                            { toilets = Yes FlushToilets
                            , picnicTables = Just PicnicTables
                            , barbecues = Yes WoodBarbecues
                            , showers = Just HotShowers
                            , drinkingWater = Just DrinkingWater
                            }
                        )
            , test "example 2" <|
                \() ->
                    Expect.equal
                        "Has non-flush toilets but no picnic tables, showers and drinking water."
                        (facilitiesText
                            { toilets = Yes NonFlushToilets
                            , picnicTables = Just NoPicnicTables
                            , barbecues = Unknown
                            , showers = Just NoShowers
                            , drinkingWater = Just NoDrinkingWater
                            }
                        )
            , test "example 3" <|
                \() ->
                    Expect.equal
                        "Has gas/electric BBQs and cold showers but no toilets."
                        (facilitiesText
                            { toilets = No
                            , picnicTables = Nothing
                            , barbecues = Yes GasElectricBarbecues
                            , showers = Just ColdShowers
                            , drinkingWater = Nothing
                            }
                        )
            ]
        , describe "haveAndHaveNotSentence"
            [ test "Has books" <|
                \() ->
                    Expect.equal (Just "Has books.")
                        (haveAndHaveNotSentence
                            "has"
                            (Just "books")
                            "but"
                            "no"
                            Nothing
                        )
            , test "No oranges" <|
                \() ->
                    Expect.equal (Just "No oranges.")
                        (haveAndHaveNotSentence
                            "has"
                            Nothing
                            "but"
                            "no"
                            (Just "oranges")
                        )
            , test "Oranges but no books" <|
                \() ->
                    Expect.equal (Just "Has oranges but no books.")
                        (haveAndHaveNotSentence
                            "has"
                            (Just "oranges")
                            "but"
                            "no"
                            (Just "books")
                        )
            , test "nothing" <|
                \() ->
                    Expect.equal Nothing
                        (haveAndHaveNotSentence
                            "has"
                            Nothing
                            "but"
                            "no"
                            Nothing
                        )
            ]
        , describe "listAsText"
            [ test "list of length zero" <|
                \() ->
                    Expect.equal Nothing (listAsText [])
            , test "list of length one" <|
                \() ->
                    Expect.equal (Just "oranges") (listAsText [ "oranges" ])
            , test "list of length two" <|
                \() ->
                    Expect.equal (Just "oranges and books") (listAsText [ "oranges", "books" ])
            , test "list of length three" <|
                \() ->
                    Expect.equal (Just "oranges, books and kiwis") (listAsText [ "oranges", "books", "kiwis" ])
            ]
        , describe "accessText"
            [ test "example 1" <|
                \() ->
                    Expect.equal
                        "For caravans, trailers and car camping."
                        (accessText
                            { caravans = Yes ()
                            , trailers = Just Trailers
                            , cars = Just Cars
                            }
                        )
            , test "example 2" <|
                \() ->
                    Expect.equal
                        "Not for caravans, trailers and car camping."
                        (accessText
                            { caravans = No
                            , trailers = Just NoTrailers
                            , cars = Just NoCars
                            }
                        )
            , test "example 3" <|
                \() ->
                    Expect.equal
                        "For trailers and car camping but not for caravans."
                        (accessText
                            { caravans = No
                            , trailers = Just Trailers
                            , cars = Just Cars
                            }
                        )
            ]
        ]
