module Campsite
    exposing
        ( Campsite
        , Park
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
        , shortenCampsiteName
        )

import Location exposing (Location)
import Regex


type alias Campsite =
    { id : String
    , shortName : String
    , longName : String
    , description : String
    , location : Maybe Location
    , facilities : Facilities
    , access : Access
    , park : Park
    , revision : Maybe String
    }


type alias Park =
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


shortenCampsiteName : String -> String
shortenCampsiteName name =
    name
        |> remove "picnic and camping area"
        |> remove "camping and picnic area"
        |> remove "campground and picnic area"
        -- TODO: Not sure "large group campground" is right to remove
        |>
            remove "large group campground"
        |> remove "campground"
        |> remove "campgrounds"
        |> remove "camping area"
        |> remove "Camping Area"
        |> remove "camping ground"
        |> remove "camping grounds"
        |> remove "tourist park"
        |> remove "rest area"
        |> specialCase1


remove : String -> String -> String
remove match text =
    Regex.replace Regex.All (Regex.regex (" " ++ match ++ "$")) (\_ -> "") text



-- TODO: Remove special cases


specialCase1 text =
    if text == "Euroka campground - Appletree Flat campervan and camper trailer area" then
        "Euroka (trailer area)"
    else
        text
