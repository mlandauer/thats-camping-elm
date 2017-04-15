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
        , DrinkingWater
        , DrinkingWaterCore(..)
        , Showers
        , ShowersCore(..)
        , Tri(..)
        , Barbecues
        , BarbecuesCore(..)
        , PicnicTables
        , Toilets
        , ToiletsCore(..)
        , Cars
        , Trailers
        , Caravans
        )


location : Location -> Value
location location =
    object
        [ ( "latitude", float location.latitude )
        , ( "longitude", float location.longitude )
        ]


toilets : Toilets -> Value
toilets toilets =
    case toilets of
        Yes NonFlushToilets ->
            string "non_flush"

        Yes FlushToilets ->
            string "flush"

        No ->
            string "no"

        Unknown ->
            null


picnicTables : PicnicTables -> Value
picnicTables picnicTables =
    case picnicTables of
        Yes () ->
            bool True

        No ->
            bool False

        Unknown ->
            null


barbecues : Barbecues -> Value
barbecues barbecues =
    case barbecues of
        Yes WoodBarbecues ->
            string "wood"

        Yes WoodSuppliedBarbecues ->
            string "wood_supplied"

        Yes WoodBringYourOwnBarbecues ->
            string "wood_bring_your_own"

        Yes GasElectricBarbecues ->
            string "gas_electric"

        No ->
            string "no"

        Unknown ->
            null


showers : Showers -> Value
showers showers =
    case showers of
        Yes HotShowers ->
            string "hot"

        Yes ColdShowers ->
            string "cold"

        No ->
            string "no"

        Unknown ->
            null


drinkingWater : DrinkingWater -> Value
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


caravans : Caravans -> Value
caravans caravans =
    case caravans of
        Yes () ->
            bool True

        No ->
            bool False

        Unknown ->
            null


trailers : Trailers -> Value
trailers trailers =
    case trailers of
        Yes () ->
            bool True

        No ->
            bool False

        Unknown ->
            null


cars : Cars -> Value
cars cars =
    case cars of
        Yes () ->
            bool True

        No ->
            bool False

        Unknown ->
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
