module App.Map exposing (map)

import Leaflet
import App.Model exposing (Model, Page(..), CampsitesPageOption(..))
import Dict
import Campsite exposing (Campsite, CampsiteWithStarred)
import App.Routing
import Location exposing (Location)


map : Model -> Leaflet.Map
map model =
    { visible = (model.page == CampsitesPage Map)
    , center =
        Maybe.withDefault
            -- Starting point is 32° 09' 48" South, 147° 01' 00" East which is "centre" of NSW
            (Location -32.163333333333334 147.01666666666668)
            model.location
    , markers = allMarkers (Dict.values model.campsites) model.starredCampsites
    }


allMarkers : List Campsite -> List String -> List Leaflet.Marker
allMarkers campsites starredCampsites =
    List.filterMap
        identity
        (List.map markerForCampsite
            (Campsite.transform campsites starredCampsites)
        )


markerForCampsite : CampsiteWithStarred -> Maybe Leaflet.Marker
markerForCampsite c =
    let
        icon =
            if c.starred then
                Leaflet.Star
            else
                Leaflet.Default
    in
        Maybe.map (Leaflet.Marker c.campsite.id icon (markerHtml c.campsite))
            c.campsite.location


markerHtml : Campsite -> String
markerHtml campsite =
    -- Wish this could come from a view
    a (App.Routing.page2url (CampsitePage campsite.id))
        (div "campsite"
            (String.append
                (div "name" campsite.name.short)
                (div "park" campsite.parkName.short)
            )
        )


div : String -> String -> String
div class html =
    "<div class=\"" ++ class ++ "\">" ++ html ++ "</div>"


a : String -> String -> String
a href html =
    "<a href=\"" ++ href ++ "\">" ++ html ++ "</a>"
