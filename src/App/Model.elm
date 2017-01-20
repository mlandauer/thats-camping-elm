module App.Model
    exposing
        ( Page(..)
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


type alias Campsite =
    { id : Int, name : String, location : Maybe Location, parkId : Int }


type alias Park =
    { id : Int, name : String }


type alias Error =
    -- We could have more kind of errors here
    Geolocation.Error


type alias Model =
    { campsites : Dict Int Campsite
    , parks : Dict Int Park
    , location : Maybe Location
    , error : Maybe Error
    , page : Page
    }
