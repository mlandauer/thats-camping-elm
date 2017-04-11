module App.NewEncoder exposing (campsite, revision)

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


locationEncoder : Maybe Location -> Value
locationEncoder location =
    case location of
        Just location ->
            object
                [ ( "latitude", float location.latitude )
                , ( "longitude", float location.longitude )
                ]

        Nothing ->
            null


toiletsEncoder : Maybe Toilets -> Value
toiletsEncoder toilets =
    case toilets of
        Just NonFlushToilets ->
            string "non_flush"

        Just FlushToilets ->
            string "flush"

        Just NoToilets ->
            string "no"

        Nothing ->
            null


picnicTablesEncoder : Maybe PicnicTables -> Value
picnicTablesEncoder picnicTables =
    case picnicTables of
        Just PicnicTables ->
            bool True

        Just NoPicnicTables ->
            bool False

        Nothing ->
            null


barbecuesEncoder : Maybe Barbecues -> Value
barbecuesEncoder barbecues =
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


showersEncoder : Maybe Showers -> Value
showersEncoder showers =
    case showers of
        Just HotShowers ->
            string "hot"

        Just ColdShowers ->
            string "cold"

        Just NoShowers ->
            string "no"

        Nothing ->
            null


drinkingWaterEncoder : Maybe DrinkingWater -> Value
drinkingWaterEncoder drinkingWater =
    case drinkingWater of
        Just DrinkingWater ->
            bool True

        Just NoDrinkingWater ->
            bool False

        Nothing ->
            null


facilitiesEncoder : Facilities -> Value
facilitiesEncoder facilities =
    object
        [ ( "toilets", toiletsEncoder facilities.toilets )
        , ( "picnicTables", picnicTablesEncoder facilities.picnicTables )
        , ( "barbecues", barbecuesEncoder facilities.barbecues )
        , ( "showers", showersEncoder facilities.showers )
        , ( "drinkingWater", drinkingWaterEncoder facilities.drinkingWater )
        ]


caravansEncoder : Maybe Caravans -> Value
caravansEncoder caravans =
    case caravans of
        Just Caravans ->
            bool True

        Just NoCaravans ->
            bool False

        Nothing ->
            null


trailersEncoder : Maybe Trailers -> Value
trailersEncoder trailers =
    case trailers of
        Just Trailers ->
            bool True

        Just NoTrailers ->
            bool False

        Nothing ->
            null


carsEncoder : Maybe Cars -> Value
carsEncoder cars =
    case cars of
        Just Cars ->
            bool True

        Just NoCars ->
            bool False

        Nothing ->
            null


accessEncoder : Access -> Value
accessEncoder access =
    object
        [ ( "caravans", caravansEncoder access.caravans )
        , ( "trailers", trailersEncoder access.trailers )
        , ( "cars", carsEncoder access.cars )
        ]


revision : Maybe String -> Value
revision revision =
    maybe string revision


campsite : Campsite -> Value
campsite campsite =
    object
        [ ( "_id", string campsite.id )
        , ( "_rev", revision campsite.revision )
        , ( "name", string campsite.name.long )
        , ( "description", string campsite.description )
        , ( "location", locationEncoder campsite.location )
        , ( "facilities", facilitiesEncoder campsite.facilities )
        , ( "access", accessEncoder campsite.access )
        , ( "parkName", string campsite.parkName.long )
        ]
