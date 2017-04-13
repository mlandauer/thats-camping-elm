module App.NewDecoder
    exposing
        ( campsite
        , toilets
        , picnicTables
        , barbecues
        , showers
        , drinkingWater
        )

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
    nullable (string |> andThen toiletsHelp)


toiletsHelp : String -> Decoder Toilets
toiletsHelp text =
    case text of
        "non_flush" ->
            succeed NonFlushToilets

        "flush" ->
            succeed FlushToilets

        "no" ->
            succeed NoToilets

        _ ->
            fail "Unexpected value"


picnicTables : Decoder (Maybe PicnicTables)
picnicTables =
    nullable
        (map
            (\present ->
                if present then
                    PicnicTables
                else
                    NoPicnicTables
            )
            bool
        )


barbecues : Decoder (Maybe Barbecues)
barbecues =
    nullable (string |> andThen barbecuesHelp)


barbecuesHelp : String -> Decoder Barbecues
barbecuesHelp text =
    case text of
        "wood" ->
            succeed WoodBarbecues

        "wood_supplied" ->
            succeed WoodSuppliedBarbecues

        "wood_bring_your_own" ->
            succeed WoodBringYourOwnBarbecues

        "gas_electric" ->
            succeed GasElectricBarbecues

        "no" ->
            succeed NoBarbecues

        _ ->
            fail "Unexpected value"


showers : Decoder (Maybe Showers)
showers =
    nullable (string |> andThen showersHelp)


showersHelp : String -> Decoder Showers
showersHelp text =
    case text of
        "hot" ->
            succeed HotShowers

        "cold" ->
            succeed ColdShowers

        "no" ->
            succeed NoShowers

        _ ->
            fail "Unexpected value"


drinkingWater : Decoder (Maybe DrinkingWater)
drinkingWater =
    nullable <|
        map
            (\present ->
                if present then
                    DrinkingWater
                else
                    NoDrinkingWater
            )
            bool


access : Decoder Access
access =
    succeed (Access Nothing Nothing Nothing)
