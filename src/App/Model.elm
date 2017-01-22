module App.Model
    exposing
        ( Page(..)
        , Toilets(..)
        , Facilities
        , Location
        , Campsite
        , Park
        , Error
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


type Toilets
    = NonFlush
    | Flush
    | None
    | Unknown


type alias Facilities =
    { toilets : Toilets }


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


type alias Error =
    -- We could have more kind of errors here
    Geolocation.Error


type alias Model =
    { campsites : Dict Int Campsite
    , parks : Dict Int Park
    , location : Maybe Location
    , errors : List Error
    , page : Page
    }
