module Campsite
    exposing
        ( Campsite
        , CampsiteWithStarred
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
        , name
        )

import Location exposing (Location)
import Regex


type alias Name =
    { {- We're storing the short version of the name as well even though it's
         calculated dynamically because it's computationally expensive and
         I didn't manage to get Lazy working with the map marker calculation.
         Html.Lazy worked fine for caching the HTML side of things but we're
         not using that now because we just precalculate it all.
      -}
      short : String
    , long : String
    }


name : String -> Name
name long =
    -- A nice easy contructor
    Name (shortenName long) long


type alias Campsite =
    { id : String
    , name : Name
    , description : String
    , location : Maybe Location
    , facilities : Facilities
    , access : Access
    , parkName : Name
    , revision : Maybe String
    }


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


type alias CampsiteWithStarred =
    { campsite : Campsite, starred : Bool }
