module App.NewDecoder exposing (park, campsite, parkOrCampsite, ParkOrCampsite(..))

import Json.Decode exposing (..)
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
import Park
import Location exposing (Location)


type ParkOrCampsite
    = Park Park.Park
    | Campsite Campsite.Campsite


parkOrCampsite : Decoder ParkOrCampsite
parkOrCampsite =
    -- Based on the value of "type" interpret as a campsite or park
    field "type" string
        |> andThen parkOrCampsiteHelp


parkOrCampsiteHelp : String -> Decoder ParkOrCampsite
parkOrCampsiteHelp t =
    case t of
        "campsite" ->
            map Campsite campsite

        "park" ->
            map Park park

        _ ->
            fail "Unsupported type"


park : Decoder Park.Park
park =
    map5 Park.Park
        (field "_id" string)
        (field "shortName" string)
        (field "longName" string)
        (field "description" string)
        (field "campsiteIds" (list string))


campsite : Decoder Campsite.Campsite
campsite =
    map8 Campsite.Campsite
        (field "_id" string)
        (field "shortName" string)
        (field "longName" string)
        (field "description" string)
        (field "location" (nullable location))
        (field "facilities" facilities)
        (field "access" access)
        (field "parkId" string)


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
