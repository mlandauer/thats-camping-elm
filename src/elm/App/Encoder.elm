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
        , Showers
        , Tri(..)
        , Barbecues
        , BarbecuesCore(..)
        , PicnicTables
        , Toilets
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
        Yes False ->
            string "non_flush"

        Yes True ->
            string "flush"

        No ->
            string "no"

        Unknown ->
            null


tri : Tri () -> Value
tri a =
    case a of
        Yes () ->
            bool True

        No ->
            bool False

        Unknown ->
            null


picnicTables : PicnicTables -> Value
picnicTables picnicTables =
    tri picnicTables


barbecues : Barbecues -> Value
barbecues barbecues =
    case barbecues of
        Yes Wood ->
            string "wood"

        Yes GasElectric ->
            string "gas_electric"

        No ->
            string "no"

        Unknown ->
            null


showers : Showers -> Value
showers showers =
    case showers of
        Yes True ->
            string "hot"

        Yes False ->
            string "cold"

        No ->
            string "no"

        Unknown ->
            null


drinkingWater : DrinkingWater -> Value
drinkingWater drinkingWater =
    tri drinkingWater


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
    tri caravans


trailers : Trailers -> Value
trailers trailers =
    tri trailers


cars : Cars -> Value
cars cars =
    tri cars


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
