module Data exposing (locationDecoder)

import Json.Decode
import Location exposing (Location)


locationDecoder : Json.Decode.Decoder (Maybe Location)
locationDecoder =
    Json.Decode.maybe
        (Json.Decode.map2 Location
            (Json.Decode.field "latitude" Json.Decode.float)
            (Json.Decode.field "longitude" Json.Decode.float)
        )
