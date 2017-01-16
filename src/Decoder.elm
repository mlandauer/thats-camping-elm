module Decoder
    exposing
        ( location
        , campsite
        , campsites
        , park
        , parks
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


campsites : Decoder (List Campsite)
campsites =
    at [ "campsites" ] (list campsite)


park : Decoder Park
park =
    map2 Park
        (field "id" int)
        (field "shortName" string)


parks : Decoder (List Park)
parks =
    at [ "parks" ] (list park)


type alias ParksAndCampsites =
    { parks : List Park, campsites : List Campsite }


parksAndCampsites : Decoder { parks : List Park, campsites : List Campsite }
parksAndCampsites =
    map2 ParksAndCampsites
        (field "parks" (list park))
        (field "campsites" (list campsite))
