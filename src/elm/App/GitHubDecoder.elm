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
        , ToiletsCore(..)
        , PicnicTables(..)
        , Tri(..)
        , Barbecues
        , BarbecuesCore(..)
        , Showers(..)
        , DrinkingWater(..)
        , Caravans(..)
        , Trailers(..)
        , Cars(..)
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
    string |> andThen toiletsHelp |> map Just


toiletsHelp : String -> Decoder ToiletsCore
toiletsHelp text =
    case text of
        "non_flush" ->
            succeed NonFlushToilets

        "flush" ->
            succeed FlushToilets

        "none" ->
            succeed NoToilets

        _ ->
            fail "Unexpected value"


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


barbecues : Decoder Barbecues
barbecues =
    string |> andThen barbecuesHelp


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

        "none" ->
            succeed No

        _ ->
            fail "Unexpected value"


showers : Decoder (Maybe Showers)
showers =
    string |> andThen showersHelp |> map Just


showersHelp : String -> Decoder Showers
showersHelp text =
    case text of
        "hot" ->
            succeed HotShowers

        "cold" ->
            succeed ColdShowers

        "none" ->
            succeed NoShowers

        _ ->
            fail "Unexpected value"


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
