module App.Decoder
    exposing
        ( location
        , campsite
        , park
        , parksAndCampsites
        )

import Json.Decode exposing (..)
import Location
import App.Model exposing (Campsite, Location, Park)


location : Decoder (Maybe Location)
location =
    maybe
        (map2 Location
            (field "latitude" float)
            (field "longitude" float)
        )


campsite : Decoder Campsite
campsite =
    map5 Campsite
        (field "id" int)
        (field "shortName" string)
        (field "longName" string)
        location
        (field "park" int)


park : Decoder Park
park =
    map3 Park
        (field "id" int)
        (field "shortName" string)
        (field "longName" string)


type alias ParksAndCampsites =
    { parks : List Park, campsites : List Campsite }


parksAndCampsites : Decoder { parks : List Park, campsites : List Campsite }
parksAndCampsites =
    map2 ParksAndCampsites
        (field "parks" (list park))
        (field "campsites" (list campsite))
