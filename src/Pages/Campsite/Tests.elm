module Pages.Campsite.Tests exposing (..)

import Test exposing (..)
import Expect
import App.Model exposing (Toilets(..), PicnicTables(..), Barbecues(..))
import Pages.Campsite.View exposing (..)


all : Test
all =
    describe "Facilities text"
        [ describe "haveLists"
            [ test "example 1" <|
                \() ->
                    Expect.equal
                        { have = [ "flush toilets", "picnic tables", "wood BBQs" ]
                        , notHave = []
                        }
                        (haveLists
                            { toilets = FlushToilets
                            , picnicTables = PicnicTables
                            , barbecues = WoodBarbecues
                            }
                        )
            , test "example 2" <|
                \() ->
                    Expect.equal
                        { have = [ "non-flush toilets" ]
                        , notHave = [ "picnic tables" ]
                        }
                        (haveLists
                            { toilets = NonFlushToilets
                            , picnicTables = NoPicnicTables
                            , barbecues = UnknownBarbecues
                            }
                        )
            , test "example 3" <|
                \() ->
                    Expect.equal
                        { have = [ "gas/electric BBQs" ]
                        , notHave = [ "toilets" ]
                        }
                        (haveLists
                            { toilets = NoToilets
                            , picnicTables = UnknownPicnicTables
                            , barbecues = GasElectricBarbecues
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
        ]
