module Tests exposing (..)

import Test exposing (..)
import TestsData
import TestsLocation


all : Test
all =
    describe "Test Suite"
        [ TestsData.all
        , TestsLocation.all
        ]
