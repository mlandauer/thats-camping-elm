module TestsData exposing (..)

import Test exposing (..)
import Expect
import Json.Decode
import Data
import Location exposing (Location)


all : Test
all =
    describe "Data"
        [ describe "locationDecoder"
            [ test "location data is present" <|
                \() ->
                    let
                        json =
                            """{ "latitude": -33, "longitude": 150 }"""

                        expected =
                            Ok (Just (Location -33 150))
                    in
                        Expect.equal expected (Json.Decode.decodeString Data.locationDecoder json)
            , test "location data is absent" <|
                \() ->
                    let
                        json =
                            "{}"

                        expected =
                            Ok (Nothing)
                    in
                        Expect.equal expected (Json.Decode.decodeString Data.locationDecoder json)
            ]
        ]
