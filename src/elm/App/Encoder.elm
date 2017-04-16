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


tri : (t -> Value) -> Tri t -> Value
tri encoder value =
    case value of
        Yes v ->
            encoder v

        No ->
            string "no"

        Unknown ->
            string "unknown"


toiletsCore : Bool -> Value
toiletsCore v =
    string
        (if v then
            "flush"
         else
            "non_flush"
        )


toilets : Toilets -> Value
toilets toilets =
    tri toiletsCore toilets


triToBool : Tri () -> Value
triToBool a =
    case a of
        Yes () ->
            string "yes"

        No ->
            string "no"

        Unknown ->
            string "unknown"


picnicTables : PicnicTables -> Value
picnicTables picnicTables =
    triToBool picnicTables


barbecuesCore : BarbecuesCore -> Value
barbecuesCore v =
    case v of
        Wood ->
            string "wood"

        GasElectric ->
            string "gas_electric"


barbecues : Barbecues -> Value
barbecues barbecues =
    tri barbecuesCore barbecues


showersCore : Bool -> Value
showersCore v =
    string
        (if v then
            "hot"
         else
            "cold"
        )


showers : Showers -> Value
showers showers =
    tri showersCore showers


drinkingWater : DrinkingWater -> Value
drinkingWater drinkingWater =
    triToBool drinkingWater


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
    triToBool caravans


trailers : Trailers -> Value
trailers trailers =
    triToBool trailers


cars : Cars -> Value
cars cars =
    triToBool cars


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
