module App.Model
    exposing
        ( Page(..)
        , TourPageId(..)
        , Model
        , CampsitesPageOption(..)
        )

import Dict exposing (Dict)
import Campsite exposing (Campsite)
import Location exposing (Location)


type CampsitesPageOption
    = List
    | Map


type TourPageId
    = Start
    | Offline
    | Edit


type Page
    = CampsitesPage CampsitesPageOption
    | CampsitePage String
    | AboutPage
    | TourPage TourPageId
    | AdminPage
      -- This is the 404 page
    | UnknownPage


type alias Model =
    { campsites : Dict String Campsite
    , location : Maybe Location
    , errors : List String
    , starredCampsites : List String
    , page : Page
    , standalone : Bool
    , version : String
    , online : Bool
    , sequence : Int
    , synching : Bool
    }
