module Pages.Campsite.Tests exposing (..)

import Test exposing (..)
import Expect
import App.Model exposing (Toilets(..), PicnicTables(..))
import Pages.Campsite.View exposing (..)


all : Test
all =
    describe "Facilities text"
        [ describe "have lists"
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
