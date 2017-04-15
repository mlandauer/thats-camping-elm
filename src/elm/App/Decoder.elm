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
        , Showers
        , Tri(..)
        , Barbecues
        , BarbecuesCore(..)
        , PicnicTables
        , Toilets
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
            succeed (Yes False)

        "flush" ->
            succeed (Yes True)

        "no" ->
            succeed No

        _ ->
            fail "Unexpected value"


picnicTables : Decoder PicnicTables
picnicTables =
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
            succeed (Yes (Wood Unknown))

        "wood_supplied" ->
            succeed (Yes (Wood (Yes ())))

        "wood_bring_your_own" ->
            succeed (Yes (Wood No))

        "gas_electric" ->
            succeed (Yes GasElectric)

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
            succeed (Yes True)

        "cold" ->
            succeed (Yes False)

        "no" ->
            succeed No

        _ ->
            fail "Unexpected value"


drinkingWater : Decoder DrinkingWater
drinkingWater =
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
