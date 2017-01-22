module App.Model
    exposing
        ( Page(..)
        , Toilets(..)
        , PicnicTables(..)
        , Barbecues(..)
        , Showers(..)
        , Facilities
        , Location
        , Campsite
        , Park
        , Model
        )

import Dict exposing (Dict)
import Geolocation


type
    Page
    -- TODO: Rename Campsites to CampsitesPage and About to AboutPage
    = Campsites
    | CampsitePage Int
    | About
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
    | UnknownToilets


type PicnicTables
    = PicnicTables
    | NoPicnicTables
    | UnknownPicnicTables


type Barbecues
    = WoodBarbecues
    | WoodSuppliedBarbecues
    | WoodBringYourOwnBarbecues
    | GasElectricBarbecues
    | NoBarbecues
    | UnknownBarbecues


type Showers
    = HotShowers
    | ColdShowers
    | NoShowers
    | UnknownShowers


type alias Facilities =
    { toilets : Toilets, picnicTables : PicnicTables, barbecues : Barbecues, showers : Showers }


type alias Campsite =
    { id : Int
    , shortName : String
    , longName : String
    , description : String
    , location : Maybe Location
    , facilities : Facilities
    , parkId : Int
    }


type alias Park =
    { id : Int, shortName : String, longName : String }


type alias Model =
    { campsites : Dict Int Campsite
    , parks : Dict Int Park
    , location : Maybe Location
    , errors : List String
    , page : Page
    }
