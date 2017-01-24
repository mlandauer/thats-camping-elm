module Pages.Campsite.Tests exposing (..)

import Test exposing (..)
import Expect
import App.Model exposing (Toilets(..), PicnicTables(..))
import Pages.Campsite.View exposing (..)


all : Test
all =
    describe "Facilities text"
        [ describe "toiletsText"
            [ test "flush toilet" <|
                \() ->
                    Expect.equal "Has flush toilets." (toiletsText FlushToilets)
            , test "non-flush toilets" <|
                \() ->
                    Expect.equal "Has non-flush toilets." (toiletsText NonFlushToilets)
            , test "no toilets" <|
                \() ->
                    Expect.equal "No toilets." (toiletsText NoToilets)
            , test "unknown toilets" <|
                \() ->
                    Expect.equal "" (toiletsText UnknownToilets)
            ]
        , describe "picnicTablesText"
            [ test "picnic tables" <|
                \() ->
                    Expect.equal "Has picnic tables." (picnicTablesText PicnicTables)
            , test "no picnic tables" <|
                \() ->
                    Expect.equal "No picnic tables." (picnicTablesText NoPicnicTables)
            , test "unknown picnic tables" <|
                \() ->
                    Expect.equal "" (picnicTablesText UnknownPicnicTables)
            ]
        , describe "have lists"
            [ test "example 1" <|
                \() ->
                    Expect.equal
                        { have = [ "flush toilets", "picnic tables" ]
                        , notHave = []
                        }
                        (haveLists
                            { toilets = FlushToilets
                            , picnicTables = PicnicTables
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
                            }
                        )
            , test "example 3" <|
                \() ->
                    Expect.equal
                        { have = []
                        , notHave = [ "toilets" ]
                        }
                        (haveLists
                            { toilets = NoToilets
                            , picnicTables = UnknownPicnicTables
                            }
                        )
            ]
        ]
