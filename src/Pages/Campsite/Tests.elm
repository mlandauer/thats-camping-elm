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
            [ test "example" <|
                \() ->
                    Expect.equal [ "flush toilets", "picnic tables" ]
                        (haveList
                            { toilets = FlushToilets
                            , picnicTables = PicnicTables
                            }
                        )
            ]
        ]
