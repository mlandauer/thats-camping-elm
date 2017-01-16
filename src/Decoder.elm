module Decoder
    exposing
        ( locationDecoder
        , campsiteDecoder
        , campsitesDecoder
        , parkDecoder
        , parksDecoder
        )

import Json.Decode exposing (..)
import Location exposing (Location)
import Campsite exposing (Campsite)
import Park exposing (Park)


locationDecoder : Decoder (Maybe Location)
locationDecoder =
    maybe
        (map2 Location
            (field "latitude" float)
            (field "longitude" float)
        )


campsiteDecoder : Decoder Campsite
campsiteDecoder =
    map2 Campsite
        (field "shortName" string)
        locationDecoder


campsitesDecoder : Decoder (List Campsite)
campsitesDecoder =
    at [ "campsites" ] (list campsiteDecoder)


parkDecoder : Decoder Park
parkDecoder =
    map2 Park
        (field "id" int)
        (field "shortName" string)


parksDecoder : Decoder (List Park)
parksDecoder =
    at [ "parks" ] (list parkDecoder)
