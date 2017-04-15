module App.Decoder
    exposing
        ( campsite
        , location
        , toilets
        , picnicTables
        , barbecues
        , showers
        , drinkingWater
        , caravans
        , trailers
        , cars
        )

import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, requiredAt)
import Campsite
    exposing
        ( Facilities
        , Access
        , DrinkingWater
        , DrinkingWaterCore(..)
        , Showers
        , ShowersCore(..)
        , Tri(..)
        , Barbecues
        , BarbecuesCore(..)
        , PicnicTables
        , PicnicTablesCore(..)
        , Toilets
        , ToiletsCore(..)
        , Caravans
        , Trailers
        , Cars
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


toilets : Decoder Toilets
toilets =
    Json.Decode.oneOf
        [ null Unknown
        , string |> andThen toiletsHelp
        ]


toiletsHelp : String -> Decoder Toilets
toiletsHelp text =
    case text of
        "non_flush" ->
            succeed (Yes NonFlushToilets)

        "flush" ->
            succeed (Yes FlushToilets)

        "no" ->
            succeed No

        _ ->
            fail "Unexpected value"


picnicTables : Decoder PicnicTables
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


barbecues : Decoder Barbecues
barbecues =
    Json.Decode.oneOf
        [ null Unknown
        , string |> andThen barbecuesHelp
        ]


barbecuesHelp : String -> Decoder Barbecues
barbecuesHelp text =
    case text of
        "wood" ->
            succeed (Yes WoodBarbecues)

        "wood_supplied" ->
            succeed (Yes WoodSuppliedBarbecues)

        "wood_bring_your_own" ->
            succeed (Yes WoodBringYourOwnBarbecues)

        "gas_electric" ->
            succeed (Yes GasElectricBarbecues)

        "no" ->
            succeed No

        _ ->
            fail "Unexpected value"


showers : Decoder Showers
showers =
    Json.Decode.oneOf
        [ null Unknown
        , string |> andThen showersHelp
        ]


showersHelp : String -> Decoder Showers
showersHelp text =
    case text of
        "hot" ->
            succeed (Yes HotShowers)

        "cold" ->
            succeed (Yes ColdShowers)

        "no" ->
            succeed No

        _ ->
            fail "Unexpected value"


drinkingWater : Decoder DrinkingWater
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


caravans : Decoder Caravans
caravans =
    Json.Decode.oneOf
        [ null Unknown
        , map
            (\present ->
                if present then
                    Yes ()
                else
                    No
            )
            bool
        ]


trailers : Decoder Trailers
trailers =
    Json.Decode.oneOf
        [ null Unknown
        , map
            (\present ->
                if present then
                    Yes ()
                else
                    No
            )
            bool
        ]


cars : Decoder Cars
cars =
    Json.Decode.oneOf
        [ null Unknown
        , map
            (\present ->
                if present then
                    Yes ()
                else
                    No
            )
            bool
        ]


access : Decoder Access
access =
    map3 Access
        (field "caravans" caravans)
        (field "trailers" trailers)
        (field "cars" cars)
