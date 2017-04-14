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
import App.NewEncoder
import Json.Encode exposing (object, string, null, float, bool)
import Location exposing (Location)


all : Test
all =
    describe "NewEncoder"
        []
