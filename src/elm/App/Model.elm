module App.Model exposing (Page(..), Model)

import Dict exposing (Dict)
import Pages.Admin.Model
import Campsite exposing (Campsite)
import Park exposing (Park)
import Location exposing (Location)


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


type alias Model =
    { campsites : Dict String Campsite
    , parks : Dict String Park
    , location : Maybe Location
    , errors : List String
    , page : Page
    , adminModel : Pages.Admin.Model.Model
    , standalone : Bool
    , version : String
    }
