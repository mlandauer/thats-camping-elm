module Campsite
    exposing
        ( Campsite
        , CampsiteWithStarred
        , Facilities
        , Access
        , Toilets
        , ToiletsCore(..)
        , PicnicTables
        , Tri(..)
        , Barbecues
        , BarbecuesCore(..)
        , Showers
        , ShowersCore(..)
        , DrinkingWater
        , DrinkingWaterCore(..)
        , Caravans
        , Trailers
        , Cars
        , shortenName
        , name
          -- TODO: Rename transform to something more descriptive
        , transform
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
    { toilets : Toilets
    , picnicTables : PicnicTables
    , barbecues : Barbecues
    , showers : Showers
    , drinkingWater : DrinkingWater
    }


type alias Access =
    { caravans : Caravans
    , trailers : Trailers
    , cars : Cars
    }


type alias Caravans =
    Tri ()


type alias Trailers =
    Tri ()


type alias Cars =
    Tri ()


type alias Toilets =
    Tri ToiletsCore


type ToiletsCore
    = NonFlushToilets
    | FlushToilets


type alias PicnicTables =
    Tri ()


type Tri t
    = Yes t
    | No
    | Unknown


type alias Barbecues =
    Tri BarbecuesCore


type BarbecuesCore
    = WoodBarbecues
    | WoodSuppliedBarbecues
    | WoodBringYourOwnBarbecues
    | GasElectricBarbecues


type alias Showers =
    Tri ShowersCore


type ShowersCore
    = HotShowers
    | ColdShowers



{-
   TODO: Doesn't really make sense to have these as custom types when a bool
   would work just fine. It makes everything very long winded
-}


type alias DrinkingWater =
    Maybe DrinkingWaterCore


type DrinkingWaterCore
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


transform : List Campsite -> List String -> List CampsiteWithStarred
transform campsites starredCampsites =
    List.map
        (\campsite -> CampsiteWithStarred campsite (List.member campsite.id starredCampsites))
        campsites
