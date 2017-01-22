module App.Model
    exposing
        ( Page(..)
        , Toilets(..)
        , Barbecues(..)
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


type Toilets
    = NonFlush
    | Flush
    | NoToilets
    | UnknownToilets


type Barbecues
    = Wood
    | WoodSupplied
    | WoodBringYourOwn
    | GasElectric
    | NoBarbecues
    | UnknownBarbecues


type alias Facilities =
    { toilets : Toilets, picnicTables : Bool, barbecues : Barbecues }


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
