module Data
    exposing
        ( locationDecoder
        , campsiteDecoder
        , campsitesDecoder
        )

import Json.Decode
import Location exposing (Location)
import Campsite exposing (Campsite)


locationDecoder : Json.Decode.Decoder (Maybe Location)
locationDecoder =
    Json.Decode.maybe
        (Json.Decode.map2 Location
            (Json.Decode.field "latitude" Json.Decode.float)
            (Json.Decode.field "longitude" Json.Decode.float)
        )


campsiteDecoder : Json.Decode.Decoder Campsite
campsiteDecoder =
    Json.Decode.map2 Campsite
        (Json.Decode.field "shortName" Json.Decode.string)
        locationDecoder


campsitesDecoder : Json.Decode.Decoder (List Campsite)
campsitesDecoder =
    Json.Decode.at [ "campsites" ] (Json.Decode.list campsiteDecoder)
