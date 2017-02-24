module App.NewDecoder exposing (campsite)

import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, requiredAt)
import Campsite
    exposing
        ( Facilities
        , Access
        , DrinkingWater(..)
        , Showers(..)
        , Barbecues(..)
        , PicnicTables(..)
        , Toilets(..)
        )
import Location exposing (Location)


-- TODO: Use Json.Decode.Pipeline everywhere for consistency and simplicity


campsite : Decoder Campsite.Campsite
campsite =
    decode Campsite.Campsite
        |> required "_id" string
        |> required "name" (map Campsite.name string)
        |> required "description" string
        |> required "location" (nullable location)
        |> required "facilities" facilities
        |> required "access" access
        |> required "parkName" (map Campsite.name string)
        |> required "_rev" (nullable string)


location : Decoder Location
location =
    (map2 Location
        (field "latitude" float)
        (field "longitude" float)
    )


facilities : Decoder Facilities
facilities =
    map5 Facilities
        (field "toilets" toilets)
        (field "picnicTables" picnicTables)
        (field "barbecues" barbecues)
        (field "showers" showers)
        (field "drinkingWater" drinkingWater)


toilets : Decoder (Maybe Toilets)
toilets =
    map
        (\text ->
            if text == "non_flush" then
                Just NonFlushToilets
            else if text == "flush" then
                Just FlushToilets
            else if text == "no" then
                Just NoToilets
            else
                Nothing
        )
        string


picnicTables : Decoder (Maybe PicnicTables)
picnicTables =
    map
        (\present ->
            if present then
                Just PicnicTables
            else
                Just NoPicnicTables
        )
        bool


barbecues : Decoder (Maybe Barbecues)
barbecues =
    map
        (\text ->
            if text == "wood" then
                Just WoodBarbecues
            else if text == "wood_supplied" then
                Just WoodSuppliedBarbecues
            else if text == "wood_bring_your_own" then
                Just WoodBringYourOwnBarbecues
            else if text == "gas_electric" then
                Just GasElectricBarbecues
            else if text == "no" then
                Just NoBarbecues
            else
                Nothing
        )
        string


showers : Decoder (Maybe Showers)
showers =
    map
        (\text ->
            if text == "hot" then
                Just HotShowers
            else if text == "cold" then
                Just ColdShowers
            else if text == "no" then
                Just NoShowers
            else
                Nothing
        )
        string


drinkingWater : Decoder (Maybe DrinkingWater)
drinkingWater =
    map
        (\present ->
            if present then
                Just DrinkingWater
            else
                Just NoDrinkingWater
        )
        bool


access : Decoder Access
access =
    succeed (Access Nothing Nothing Nothing)
