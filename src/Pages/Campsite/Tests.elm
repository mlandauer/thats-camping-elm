module Pages.Campsite.Tests exposing (..)

import Test exposing (..)
import Expect
import App.Model
    exposing
        ( Toilets(..)
        , PicnicTables(..)
        , Barbecues(..)
        , Showers(..)
        , DrinkingWater(..)
        )
import Pages.Campsite.View exposing (..)


all : Test
all =
    describe "Facilities text"
        [ describe "haveLists"
            [ test "example 1" <|
                \() ->
                    Expect.equal
                        { have = [ "flush toilets", "picnic tables", "wood BBQs", "hot showers", "drinking water" ]
                        , notHave = []
                        }
                        (haveLists
                            { toilets = Just FlushToilets
                            , picnicTables = Just PicnicTables
                            , barbecues = Just WoodBarbecues
                            , showers = Just HotShowers
                            , drinkingWater = Just DrinkingWater
                            }
                        )
            , test "example 2" <|
                \() ->
                    Expect.equal
                        { have = [ "non-flush toilets" ]
                        , notHave = [ "picnic tables", "showers", "drinking water" ]
                        }
                        (haveLists
                            { toilets = Just NonFlushToilets
                            , picnicTables = Just NoPicnicTables
                            , barbecues = Nothing
                            , showers = Just NoShowers
                            , drinkingWater = Just NoDrinkingWater
                            }
                        )
            , test "example 3" <|
                \() ->
                    Expect.equal
                        { have = [ "gas/electric BBQs", "cold showers" ]
                        , notHave = [ "toilets" ]
                        }
                        (haveLists
                            { toilets = Just NoToilets
                            , picnicTables = Nothing
                            , barbecues = Just GasElectricBarbecues
                            , showers = Just ColdShowers
                            , drinkingWater = Nothing
                            }
                        )
            ]
        , describe "haveAndHaveNotSentence"
            [ test "Has books" <|
                \() ->
                    Expect.equal (Just "Has books.")
                        (haveAndHaveNotSentence (Just "books") Nothing)
            , test "No oranges" <|
                \() ->
                    Expect.equal (Just "No oranges.")
                        (haveAndHaveNotSentence Nothing (Just "oranges"))
            , test "Oranges but no books" <|
                \() ->
                    Expect.equal (Just "Has oranges but no books.")
                        (haveAndHaveNotSentence (Just "oranges") (Just "books"))
            , test "nothing" <|
                \() ->
                    Expect.equal Nothing
                        (haveAndHaveNotSentence Nothing Nothing)
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
        ]
