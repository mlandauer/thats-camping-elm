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
    tri (string |> andThen toiletsHelp)


toiletsHelp : String -> Decoder Bool
toiletsHelp text =
    case text of
        "non_flush" ->
            succeed False

        "flush" ->
            succeed True

        _ ->
            fail "Unexpected value"


triFromBool : Decoder (Tri ())
triFromBool =
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


picnicTables : Decoder PicnicTables
picnicTables =
    triFromBool


tri : Decoder t -> Decoder (Tri t)
tri decoder =
    Json.Decode.oneOf
        [ null Unknown
        , string |> andThen noHelp
        , decoder |> map Yes
        ]


noHelp : String -> Decoder (Tri t)
noHelp text =
    case text of
        "no" ->
            succeed No

        _ ->
            fail "Unexpected value"


barbecues : Decoder Barbecues
barbecues =
    tri (string |> andThen barbecuesHelp)


barbecuesHelp : String -> Decoder BarbecuesCore
barbecuesHelp text =
    case text of
        "wood" ->
            succeed Wood

        "wood_supplied" ->
            succeed Wood

        "wood_bring_your_own" ->
            succeed Wood

        "gas_electric" ->
            succeed GasElectric

        _ ->
            fail "Unexpected value"


showers : Decoder Showers
showers =
    tri (string |> andThen showersHelp)


showersHelp : String -> Decoder Bool
showersHelp text =
    case text of
        "hot" ->
            succeed True

        "cold" ->
            succeed False

        _ ->
            fail "Unexpected value"


drinkingWater : Decoder DrinkingWater
drinkingWater =
    triFromBool


caravans : Decoder Caravans
caravans =
    triFromBool


trailers : Decoder Trailers
trailers =
    triFromBool


cars : Decoder Cars
cars =
    triFromBool


access : Decoder Access
access =
    map3 Access
        (field "caravans" caravans)
        (field "trailers" trailers)
        (field "cars" cars)
