module Campsite
    exposing
        ( Campsite
        , ParkInCampsite
        , Facilities
        , Access
        , Toilets(..)
        , PicnicTables(..)
        , Barbecues(..)
        , Showers(..)
        , DrinkingWater(..)
        , Caravans(..)
        , Trailers(..)
        , Cars(..)
        )

import Location exposing (Location)


type alias Campsite =
    { id : String
    , shortName : String
    , longName : String
    , description : String
    , location : Maybe Location
    , facilities : Facilities
    , access : Access
    , parkId : String
    , park : ParkInCampsite
    , revision : Maybe String
    }


type alias ParkInCampsite =
    { shortName : String, longName : String }


type alias Facilities =
    { toilets : Maybe Toilets
    , picnicTables : Maybe PicnicTables
    , barbecues : Maybe Barbecues
    , showers : Maybe Showers
    , drinkingWater : Maybe DrinkingWater
    }


type alias Access =
    { caravans : Maybe Caravans
    , trailers : Maybe Trailers
    , cars : Maybe Cars
    }


type Caravans
    = Caravans
    | NoCaravans


type Trailers
    = Trailers
    | NoTrailers


type Cars
    = Cars
    | NoCars



-- TODO: Types for Toilets and Barbecues don't feel right. What would be better?
-- We're mixing up their presence with information about their properties
-- Maybe we want something like this instead:
-- type Toilets
--     = Toilets Bool
--     | NoToilets
--     | UnknownToilets


type Toilets
    = NonFlushToilets
    | FlushToilets
    | NoToilets


type PicnicTables
    = PicnicTables
    | NoPicnicTables


type Barbecues
    = WoodBarbecues
    | WoodSuppliedBarbecues
    | WoodBringYourOwnBarbecues
    | GasElectricBarbecues
    | NoBarbecues


type Showers
    = HotShowers
    | ColdShowers
    | NoShowers



{-
   TODO: Doesn't really make sense to have these as custom types when a bool
   would work just fine. It makes everything very long winded
-}


type DrinkingWater
    = DrinkingWater
    | NoDrinkingWater
