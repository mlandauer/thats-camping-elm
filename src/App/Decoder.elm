module App.Decoder
    exposing
        ( location
        , toilets
        , picnicTables
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
        , PicnicTables(..)
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
                NonFlushToilets
            else if text == "flush" then
                FlushToilets
            else if text == "none" then
                NoToilets
            else
                UnknownToilets
        )
        string


picnicTables : Decoder PicnicTables
picnicTables =
    map
        (\present ->
            if present then
                PicnicTables
            else
                NoPicnicTables
        )
        bool


barbecues : Decoder Barbecues
barbecues =
    map
        (\text ->
            if text == "wood" then
                WoodBarbecues
            else if text == "wood_supplied" then
                WoodSuppliedBarbecues
            else if text == "wood_bring_your_own" then
                WoodBringYourOwnBarbecues
            else if text == "gas_electric" then
                GasElectricBarbecues
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
                HotShowers
            else if text == "cold" then
                ColdShowers
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
        (field "picnicTables" picnicTables)
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
