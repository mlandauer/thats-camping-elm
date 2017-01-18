module App.Update exposing (Msg(..), page2url)

import App.Model exposing (Page(..), Campsite, Park)
import Http
import Geolocation


type Msg
    = NewCampsite Campsite
    | UpdateLocation (Result Geolocation.Error Geolocation.Location)
    | NewData (Result Http.Error { parks : List Park, campsites : List Campsite })
    | ChangePage Page
    | PageBack


page2url : Page -> String
page2url page =
    case page of
        Campsites ->
            "#/campsites"

        About ->
            "#/about"
