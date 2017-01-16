module Decoder
    exposing
        ( location
        , campsite
        , park
        , parksAndCampsites
        )

import Json.Decode exposing (..)
import Location exposing (Location)
import Campsite exposing (Campsite)
import Park exposing (Park)


location : Decoder (Maybe Location)
location =
    maybe
        (map2 Location
            (field "latitude" float)
            (field "longitude" float)
        )


campsite : Decoder Campsite
campsite =
    map2 Campsite
        (field "shortName" string)
        location


park : Decoder Park
park =
    map2 Park
        (field "id" int)
        (field "shortName" string)


type alias ParksAndCampsites =
    { parks : List Park, campsites : List Campsite }


parksAndCampsites : Decoder { parks : List Park, campsites : List Campsite }
parksAndCampsites =
    map2 ParksAndCampsites
        (field "parks" (list park))
        (field "campsites" (list campsite))
