module App.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import App.Update exposing (..)
import App.Model exposing (..)
import Pages.About.View
import Pages.Campsites.View
import Pages.Campsite.View
import Pages.Park.View
import Pages.Admin.View
import Dict exposing (Dict)
import App.ViewHelpers


view : Model -> Html Msg
view model =
    div [ id "app" ]
        [ case model.page of
            Campsites ->
                Pages.Campsites.View.view
                    { campsites = (Dict.values model.campsites)
                    , parks = model.parks
                    , location = model.location
                    , errors = model.errors
                    }

            CampsitePage id ->
                case Dict.get id model.campsites of
                    Just campsite ->
                        Pages.Campsite.View.view
                            { campsite = campsite
                            , park = (Dict.get campsite.parkId model.parks)
                            }

                    Nothing ->
                        view404

            ParkPage id ->
                case Dict.get id model.parks of
                    Just park ->
                        Pages.Park.View.view
                            { park = park
                            , campsites = (campsites park model.campsites)
                            , parks = model.parks
                            , location = model.location
                            }

                    Nothing ->
                        view404

            About ->
                Pages.About.View.view

            AdminPage ->
                Html.map AdminMsg (Pages.Admin.View.view model.adminModel)

            UnknownPage ->
                view404
        ]


campsites : Park -> Dict Int Campsite -> List Campsite
campsites park campsites =
    App.ViewHelpers.values (List.map (\campsiteId -> Dict.get campsiteId campsites) park.campsiteIds)


view404 : Html Msg
view404 =
    -- TODO: Make this page less ugly
    p [] [ text "This is a 404" ]
