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
        , shortenName
        )

import Location exposing (Location)
import Regex


type alias Campsite =
    { id : String
    , longName : String
    , description : String
    , location : Maybe Location
    , facilities : Facilities
    , access : Access
    , park : Park
    , revision : Maybe String
    }


type alias Park =
    { longName : String }


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


shortenName : String -> String
shortenName name =
    name
        |> remove "picnic and camping area"
        |> remove "camping and picnic area"
        |> remove "campground and picnic area"
        -- TODO: Not sure "large group campground" is right to remove
        |>
            remove "large group campground"
        |> remove "campgrounds?"
        |> remove "camping area"
        |> remove "camping grounds?"
        |> remove "tourist park"
        |> remove "rest area"
        |> specialCase1
        |> replace "National Park" " NP"
        |> replace "State Conservation Area" " SCA"
        |> replace "Nature Reserve" " NR"
        |> replace "Karst Conservation Reserve" " KCR"
        |> remove "Historic Site"


replace : String -> String -> String -> String
replace match replace text =
    let
        regex =
            Regex.caseInsensitive (Regex.regex (" " ++ match ++ "$"))
    in
        Regex.replace Regex.All regex (\_ -> replace) text


remove : String -> String -> String
remove match text =
    replace match "" text



-- TODO: Remove special case


specialCase1 : String -> String
specialCase1 text =
    if text == "Euroka campground - Appletree Flat campervan and camper trailer area" then
        "Euroka (trailer area)"
    else
        text
