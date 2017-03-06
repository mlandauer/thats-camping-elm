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

        standaloneFlags =
            { defaultFlags | standalone = True }
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
                , test "when standalone always go to the home page" <|
                    \() ->
                        App.Update.initModel standaloneFlags
                            |> App.Update.updateWithMap (ChangePage AboutPage)
                            |> Tuple.first
                            |> .page
                            |> Expect.equal (CampsitesPage List)
                , test "when standalone go to the requested page subsequently" <|
                    \() ->
                        App.Update.initModel standaloneFlags
                            |> App.Update.updateWithMap (ChangePage AboutPage)
                            |> Tuple.first
                            |> App.Update.updateWithMap (ChangePage AboutPage)
                            |> Tuple.first
                            |> .page
                            |> Expect.equal AboutPage
                ]
            ]
