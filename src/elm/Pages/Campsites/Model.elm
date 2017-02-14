module Pages.Campsites.Model exposing (Model)

import Location exposing (Location)
import Campsite exposing (Campsite)
import Park exposing (Park)
import Dict exposing (Dict)
import App.Model exposing (CampsitesPageOption)


type alias Model =
    { campsites : List Campsite
    , parks : Dict String Park
    , location : Maybe Location
    , errors : List String
    , starredCampsites : List String
    , displayType : CampsitesPageOption
    , initialChanges : Bool
    }
