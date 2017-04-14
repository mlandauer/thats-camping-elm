module App.Encoder
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

import Json.Encode exposing (object, string, Value, null, bool, float)
import Json.Encode.Extra exposing (maybe)
import Location exposing (Location)
import Campsite
    exposing
        ( Campsite
        , Facilities
        , Access
        , DrinkingWater(..)
        , Showers(..)
        , Barbecues(..)
        , PicnicTables(..)
        , Toilets(..)
        , Cars(..)
        , Trailers(..)
        , Caravans(..)
        )


location : Location -> Value
location location =
    object
        [ ( "latitude", float location.latitude )
        , ( "longitude", float location.longitude )
        ]


toilets : Maybe Toilets -> Value
toilets toilets =
    case toilets of
        Just NonFlushToilets ->
            string "non_flush"

        Just FlushToilets ->
            string "flush"

        Just NoToilets ->
            string "no"

        Nothing ->
            null


picnicTables : Maybe PicnicTables -> Value
picnicTables picnicTables =
    case picnicTables of
        Just PicnicTables ->
            bool True

        Just NoPicnicTables ->
            bool False

        Nothing ->
            null


barbecues : Maybe Barbecues -> Value
barbecues barbecues =
    case barbecues of
        Just WoodBarbecues ->
            string "wood"

        Just WoodSuppliedBarbecues ->
            string "wood_supplied"

        Just WoodBringYourOwnBarbecues ->
            string "wood_bring_your_own"

        Just GasElectricBarbecues ->
            string "gas_electric"

        Just NoBarbecues ->
            string "no"

        Nothing ->
            null


showers : Maybe Showers -> Value
showers showers =
    case showers of
        Just HotShowers ->
            string "hot"

        Just ColdShowers ->
            string "cold"

        Just NoShowers ->
            string "no"

        Nothing ->
            null


drinkingWater : Maybe DrinkingWater -> Value
drinkingWater drinkingWater =
    case drinkingWater of
        Just DrinkingWater ->
            bool True

        Just NoDrinkingWater ->
            bool False

        Nothing ->
            null


facilities : Facilities -> Value
facilities facilities =
    object
        [ ( "toilets", toilets facilities.toilets )
        , ( "picnicTables", picnicTables facilities.picnicTables )
        , ( "barbecues", barbecues facilities.barbecues )
        , ( "showers", showers facilities.showers )
        , ( "drinkingWater", drinkingWater facilities.drinkingWater )
        ]


caravans : Maybe Caravans -> Value
caravans caravans =
    case caravans of
        Just Caravans ->
            bool True

        Just NoCaravans ->
            bool False

        Nothing ->
            null


trailers : Maybe Trailers -> Value
trailers trailers =
    case trailers of
        Just Trailers ->
            bool True

        Just NoTrailers ->
            bool False

        Nothing ->
            null


cars : Maybe Cars -> Value
cars cars =
    case cars of
        Just Cars ->
            bool True

        Just NoCars ->
            bool False

        Nothing ->
            null


access : Access -> Value
access access =
    object
        [ ( "caravans", caravans access.caravans )
        , ( "trailers", trailers access.trailers )
        , ( "cars", cars access.cars )
        ]


campsite : Campsite -> Value
campsite campsite =
    object
        [ ( "_id", string campsite.id )
        , ( "_rev", maybe string campsite.revision )
        , ( "name", string campsite.name.long )
        , ( "description", string campsite.description )
        , ( "location", maybe location campsite.location )
        , ( "facilities", facilities campsite.facilities )
        , ( "access", access campsite.access )
        , ( "parkName", string campsite.parkName.long )
        ]
