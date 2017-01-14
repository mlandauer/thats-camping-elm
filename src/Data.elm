module Data exposing (..)

import Json.Decode
import Location exposing (Location)


locationDecoder : Json.Decode.Decoder Location
locationDecoder =
    Json.Decode.map2 Location
        (Json.Decode.field "latitude" Json.Decode.float)
        (Json.Decode.field "longitude" Json.Decode.float)
