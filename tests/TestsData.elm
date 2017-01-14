module TestsData exposing (..)

import Test exposing (..)
import Expect
import Json.Decode
import Data


all : Test
all =
    describe "Data"
        [ describe "locationDecoder"
            [ test "example" <|
                \() ->
                    Expect.equal (Ok { latitude = -33, longitude = 150 }) (Json.Decode.decodeString Data.locationDecoder """{ "latitude": -33, "longitude": 150 }""")
            ]
        ]
