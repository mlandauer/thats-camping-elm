module App.TestsUpdate exposing (all)

import Test exposing (..)
import Expect
import App.Update exposing (..)
import App.Model exposing (..)


all : Test
all =
    let
        defaultFlags =
            { version = "1.0"
            , standalone = False
            , starredCampsites = Nothing
            , online = True
            , location = Nothing
            }
    in
        describe "App.Update.updateWithMap"
            [ describe "ChangePage"
                [ test "sets the page" <|
                    \() ->
                        App.Update.initModel defaultFlags
                            |> App.Update.updateWithMap (ChangePage (CampsitesPage Map))
                            |> Tuple.first
                            |> .page
                            |> Expect.equal (CampsitesPage Map)
                ]
            ]
