module App.GitHubDecoder
    exposing
        ( location
        , toilets
        , picnicTables
        , barbecues
        , showers
        , drinkingWater
        , facilities
        , parksAndCampsites
        , Campsite
        , Park
        )

import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, custom, hardcoded)
import Location exposing (Location)
import Campsite
    exposing
        ( Facilities
        , Access
        , Toilets
        , PicnicTables
        , Tri(..)
        , Barbecues
        , BarbecuesCore(..)
        , Showers
        , DrinkingWater
        , Caravans
        , Trailers
        , Cars
        )


type alias Campsite =
    { id : String
    , shortName : String
    , longName : String
    , description : String
    , location : Maybe Location
    , facilities : Facilities
    , access : Access
    , parkId :
        String
        -- , revision : Maybe String
    }


type alias Park =
    { id : String
    , shortName : String
    , longName : String
    , description : String
    , campsiteIds :
        List String
        -- , revision : Maybe String
    }


location : Decoder (Maybe Location)
location =
    maybe
        (map2 Location
            (field "latitude" float)
            (field "longitude" float)
        )


toilets : Decoder Toilets
toilets =
    string |> andThen toiletsHelp


toiletsHelp : String -> Decoder Toilets
toiletsHelp text =
    case text of
        "non_flush" ->
            succeed (Yes False)

        "flush" ->
            succeed (Yes True)

        "none" ->
            succeed No

        _ ->
            fail "Unexpected value"


picnicTables : Decoder PicnicTables
picnicTables =
    tri


barbecues : Decoder Barbecues
barbecues =
    string |> andThen barbecuesHelp


barbecuesHelp : String -> Decoder Barbecues
barbecuesHelp text =
    case text of
        "wood" ->
            succeed (Yes Wood)

        "wood_supplied" ->
            succeed (Yes Wood)

        "wood_bring_your_own" ->
            succeed (Yes Wood)

        "gas_electric" ->
            succeed (Yes GasElectric)

        "none" ->
            succeed No

        _ ->
            fail "Unexpected value"


showers : Decoder Showers
showers =
    string |> andThen showersHelp


showersHelp : String -> Decoder Showers
showersHelp text =
    case text of
        "hot" ->
            succeed (Yes True)

        "cold" ->
            succeed (Yes False)

        "none" ->
            succeed No

        _ ->
            fail "Unexpected value"


tri : Decoder (Tri ())
tri =
    map
        (\a ->
            if a then
                Yes ()
            else
                No
        )
        bool


drinkingWater : Decoder DrinkingWater
drinkingWater =
    tri


caravans : Decoder Caravans
caravans =
    tri


trailers : Decoder Trailers
trailers =
    tri


cars : Decoder Cars
cars =
    tri


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


park : Decoder Park
park =
    decode Park
        |> required "id" (map (\id -> "p" ++ toString id) int)
        |> required "shortName" string
        |> required "longName" string
        |> required "description" string
        |> required "campsites" (list (map (\id -> "c" ++ toString id) int))


type alias ParksAndCampsites =
    { parks : List Park, campsites : List Campsite }


parksAndCampsites : Decoder { parks : List Park, campsites : List Campsite }
parksAndCampsites =
    map2 ParksAndCampsites
        (field "parks" (list park))
        (field "campsites" (list campsite))
