module App.Decoder
    exposing
        ( location
        , toilets
        , picnicTables
        , barbecues
        , showers
        , drinkingWater
        , facilities
        , parksAndCampsites
        )

import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, custom, hardcoded)
import Park exposing (Park)
import Location exposing (Location)
import Campsite
    exposing
        ( Campsite
        , Facilities
        , Access
        , Toilets(..)
        , PicnicTables(..)
        , Barbecues(..)
        , Showers(..)
        , DrinkingWater(..)
        , Caravans(..)
        , Trailers(..)
        , Cars(..)
        )


location : Decoder (Maybe Location)
location =
    maybe
        (map2 Location
            (field "latitude" float)
            (field "longitude" float)
        )


toilets : Decoder (Maybe Toilets)
toilets =
    map
        (\text ->
            if text == "non_flush" then
                Just NonFlushToilets
            else if text == "flush" then
                Just FlushToilets
            else if text == "none" then
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
            else if text == "none" then
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
            else if text == "none" then
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


caravans : Decoder (Maybe Caravans)
caravans =
    map
        (\present ->
            if present then
                Just Caravans
            else
                Just NoCaravans
        )
        bool


trailers : Decoder (Maybe Trailers)
trailers =
    map
        (\present ->
            if present then
                Just Trailers
            else
                Just NoTrailers
        )
        bool


cars : Decoder (Maybe Cars)
cars =
    map
        (\present ->
            if present then
                Just Cars
            else
                Just NoCars
        )
        bool


facilities : Decoder Facilities
facilities =
    map5 Facilities
        (field "toilets" toilets)
        (field "picnicTables" picnicTables)
        (field "barbecues" barbecues)
        (field "showers" showers)
        (field "drinkingWater" drinkingWater)


access : Decoder Access
access =
    map3 Access
        (field "caravans" caravans)
        (field "trailers" trailers)
        (field "car" cars)


campsite : Decoder Campsite
campsite =
    decode Campsite
        |> required "id" (map (\id -> "c" ++ toString id) int)
        |> required "shortName" string
        |> required "longName" string
        |> required "description" string
        |> custom location
        |> custom facilities
        |> custom access
        |> required "park" (map (\id -> "p" ++ toString id) int)
        |> hardcoded Nothing


park : Decoder Park
park =
    decode Park
        |> required "id" (map (\id -> "p" ++ toString id) int)
        |> required "shortName" string
        |> required "longName" string
        |> required "description" string
        |> required "campsites" (list (map (\id -> "c" ++ toString id) int))
        |> hardcoded Nothing


type alias ParksAndCampsites =
    { parks : List Park, campsites : List Campsite }


parksAndCampsites : Decoder { parks : List Park, campsites : List Campsite }
parksAndCampsites =
    map2 ParksAndCampsites
        (field "parks" (list park))
        (field "campsites" (list campsite))
