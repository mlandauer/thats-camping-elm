module App.TestsUpdate exposing (all)

import Test exposing (..)
import Expect
import App.Update exposing (..)
import App.Model exposing (..)


all : Test
all =
    describe "App.Update.updateWithMap"
        [ describe "ChangePage"
            [ test "sets the page" <|
                \() ->
                    let
                        model =
                            App.Update.initModel
                                { version = "1.0"
                                , standalone = False
                                , starredCampsites = Nothing
                                , online = True
                                , location = Nothing
                                }
                    in
                        Expect.equal (CampsitesPage Map) <|
                            .page <|
                                Tuple.first <|
                                    App.Update.updateWithMap (ChangePage (CampsitesPage Map))
                                        model
            ]
        ]
