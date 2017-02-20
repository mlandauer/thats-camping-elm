module App.Model exposing (Page(..), Model, CampsitesPageOption(..))

import Dict exposing (Dict)
import Pages.Admin.Model
import Campsite exposing (Campsite)
import Location exposing (Location)


type CampsitesPageOption
    = List
    | Map


type Page
    = CampsitesPage CampsitesPageOption
    | CampsitePage String
    | AboutPage
    | TourPage String
    | AdminPage
      -- This is the 404 page
    | UnknownPage


type alias Model =
    { campsites : Dict String Campsite
    , location : Maybe Location
    , errors : List String
    , starredCampsites : List String
    , page : Page
    , adminModel : Pages.Admin.Model.Model
    , standalone : Bool
    , version : String
    , online : Bool
    , sequence : Int
    }
