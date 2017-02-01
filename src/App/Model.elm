module App.Model
    exposing
        ( Page(..)
        , Toilets(..)
        , PicnicTables(..)
        , Barbecues(..)
        , Showers(..)
        , DrinkingWater(..)
        , Facilities
        , Access
        , Caravans(..)
        , Trailers(..)
        , Cars(..)
        , Location
        , Campsite
        , Park
        , Model
        )

import Dict exposing (Dict)
import Pages.Admin.Model


type
    Page
    -- TODO: Rename Campsites to CampsitesPage and About to AboutPage
    = Campsites
    | CampsitePage String
    | ParkPage String
    | About
    | AdminPage
      -- This is the 404 page
    | UnknownPage


type alias Location =
    { latitude : Float, longitude : Float }



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


type Caravans
    = Caravans
    | NoCaravans


type Trailers
    = Trailers
    | NoTrailers


type Cars
    = Cars
    | NoCars


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


type alias Campsite =
    { id : String
    , shortName : String
    , longName : String
    , description : String
    , location : Maybe Location
    , facilities : Facilities
    , access : Access
    , parkId : String
    }


type alias Park =
    { id : String
    , shortName : String
    , longName : String
    , description : String
    , campsiteIds : List String
    }


type alias Model =
    { campsites : Dict String Campsite
    , parks : Dict String Park
    , location : Maybe Location
    , errors : List String
    , page : Page
    , adminModel : Pages.Admin.Model.Model
    , standalone : Bool
    }
