module App.NewEncoder exposing (campsite)

import Json.Encode
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


locationEncoder : Maybe Location -> Json.Encode.Value
locationEncoder location =
    case location of
        Just location ->
            Json.Encode.object
                [ ( "latitude", Json.Encode.float location.latitude )
                , ( "longitude", Json.Encode.float location.longitude )
                ]

        Nothing ->
            Json.Encode.null


toiletsEncoder : Maybe Toilets -> Json.Encode.Value
toiletsEncoder toilets =
    case toilets of
        Just NonFlushToilets ->
            Json.Encode.string "non_flush"

        Just FlushToilets ->
            Json.Encode.string "flush"

        Just NoToilets ->
            Json.Encode.string "no"

        Nothing ->
            Json.Encode.null


picnicTablesEncoder : Maybe PicnicTables -> Json.Encode.Value
picnicTablesEncoder picnicTables =
    case picnicTables of
        Just PicnicTables ->
            Json.Encode.bool True

        Just NoPicnicTables ->
            Json.Encode.bool False

        Nothing ->
            Json.Encode.null


barbecuesEncoder : Maybe Barbecues -> Json.Encode.Value
barbecuesEncoder barbecues =
    case barbecues of
        Just WoodBarbecues ->
            Json.Encode.string "wood"

        Just WoodSuppliedBarbecues ->
            Json.Encode.string "wood_supplied"

        Just WoodBringYourOwnBarbecues ->
            Json.Encode.string "wood_bring_your_own"

        Just GasElectricBarbecues ->
            Json.Encode.string "gas_electric"

        Just NoBarbecues ->
            Json.Encode.string "no"

        Nothing ->
            Json.Encode.null


showersEncoder : Maybe Showers -> Json.Encode.Value
showersEncoder showers =
    case showers of
        Just HotShowers ->
            Json.Encode.string "hot"

        Just ColdShowers ->
            Json.Encode.string "cold"

        Just NoShowers ->
            Json.Encode.string "no"

        Nothing ->
            Json.Encode.null


drinkingWaterEncoder : Maybe DrinkingWater -> Json.Encode.Value
drinkingWaterEncoder drinkingWater =
    case drinkingWater of
        Just DrinkingWater ->
            Json.Encode.bool True

        Just NoDrinkingWater ->
            Json.Encode.bool False

        Nothing ->
            Json.Encode.null


facilitiesEncoder : Facilities -> Json.Encode.Value
facilitiesEncoder facilities =
    Json.Encode.object
        [ ( "toilets", toiletsEncoder facilities.toilets )
        , ( "picnicTables", picnicTablesEncoder facilities.picnicTables )
        , ( "barbecues", barbecuesEncoder facilities.barbecues )
        , ( "showers", showersEncoder facilities.showers )
        , ( "drinkingWater", drinkingWaterEncoder facilities.drinkingWater )
        ]


caravansEncoder : Maybe Caravans -> Json.Encode.Value
caravansEncoder caravans =
    case caravans of
        Just Caravans ->
            Json.Encode.bool True

        Just NoCaravans ->
            Json.Encode.bool False

        Nothing ->
            Json.Encode.null


trailersEncoder : Maybe Trailers -> Json.Encode.Value
trailersEncoder trailers =
    case trailers of
        Just Trailers ->
            Json.Encode.bool True

        Just NoTrailers ->
            Json.Encode.bool False

        Nothing ->
            Json.Encode.null


carsEncoder : Maybe Cars -> Json.Encode.Value
carsEncoder cars =
    case cars of
        Just Cars ->
            Json.Encode.bool True

        Just NoCars ->
            Json.Encode.bool False

        Nothing ->
            Json.Encode.null


accessEncoder : Access -> Json.Encode.Value
accessEncoder access =
    Json.Encode.object
        [ ( "caravans", caravansEncoder access.caravans )
        , ( "trailers", trailersEncoder access.trailers )
        , ( "cars", carsEncoder access.cars )
        ]


revision : Maybe String -> Json.Encode.Value
revision revision =
    case revision of
        Just revision ->
            Json.Encode.string revision

        Nothing ->
            Json.Encode.null


campsite : Campsite -> Json.Encode.Value
campsite campsite =
    Json.Encode.object
        [ ( "_id", Json.Encode.string campsite.id )
        , ( "_rev", revision campsite.revision )
        , ( "type", Json.Encode.string "campsite" )
        , ( "shortName", Json.Encode.string campsite.shortName )
        , ( "longName", Json.Encode.string campsite.longName )
        , ( "description", Json.Encode.string campsite.description )
        , ( "location", locationEncoder campsite.location )
        , ( "facilities", facilitiesEncoder campsite.facilities )
        , ( "access", accessEncoder campsite.access )
        , ( "parkId", Json.Encode.string campsite.parkId )
        , ( "park"
          , Json.Encode.object
                [ ( "shortName", Json.Encode.string campsite.park.shortName )
                , ( "longName", Json.Encode.string campsite.park.longName )
                ]
          )
        ]
