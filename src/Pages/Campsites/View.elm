module Pages.Campsites.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import App.Model exposing (Campsite, Location, Park, Page(..))
import Dict exposing (Dict)
import Location
import Geolocation
import App.Update exposing (Msg)
import Pages.Campsites.Model exposing (..)
import App.ViewHelpers exposing (navBar, link)


view : Model -> Html Msg
view model =
    div [ class "campsite-list" ]
        [ navBar "Camping near you" False True
        , div [ class "content" ]
            [ errorsView model.errors
            , App.ViewHelpers.campsiteListView model.location model.campsites model.parks
            ]
        ]


errorsView : List String -> Html msg
errorsView errors =
    div [] (List.map (\error -> (p [] [ text error ])) errors)
