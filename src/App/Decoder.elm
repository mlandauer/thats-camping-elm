module App.Decoder
    exposing
        ( location
        , toilets
        , barbecues
        , showers
        , facilities
        , parksAndCampsites
        )

import Json.Decode exposing (..)
import Location
import App.Model
    exposing
        ( Campsite
        , Location
        , Park
        , Toilets(..)
        , Barbecues(..)
        , Showers(..)
        , Facilities
        )


location : Decoder (Maybe Location)
location =
    maybe
        (map2 Location
            (field "latitude" float)
            (field "longitude" float)
        )


toilets : Decoder Toilets
toilets =
    map
        (\text ->
            if text == "non_flush" then
                NonFlush
            else if text == "flush" then
                Flush
            else if text == "none" then
                NoToilets
            else
                UnknownToilets
        )
        string


barbecues : Decoder Barbecues
barbecues =
    map
        (\text ->
            if text == "wood" then
                Wood
            else if text == "wood_supplied" then
                WoodSupplied
            else if text == "wood_bring_your_own" then
                WoodBringYourOwn
            else if text == "gas_electric" then
                GasElectric
            else if text == "none" then
                NoBarbecues
            else
                UnknownBarbecues
        )
        string


showers : Decoder Showers
showers =
    map
        (\text ->
            if text == "hot" then
                Hot
            else if text == "cold" then
                Cold
            else if text == "none" then
                NoShowers
            else
                UnknownShowers
        )
        string


facilities : Decoder Facilities
facilities =
    map4 Facilities
        (field "toilets" toilets)
        (field "picnicTables" bool)
        (field "barbecues" barbecues)
        (field "showers" showers)


campsite : Decoder Campsite
campsite =
    map7 Campsite
        (field "id" int)
        (field "shortName" string)
        (field "longName" string)
        (field "description" string)
        location
        facilities
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
