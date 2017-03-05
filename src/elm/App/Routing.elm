module App.Routing exposing (page2url, location2page)

import App.Model
    exposing
        ( Page(..)
        , CampsitesPageOption(..)
        , TourPageId(..)
        )
import Navigation
import RouteUrl.Builder
import Dict


page2url : Page -> String
page2url page =
    case page of
        CampsitesPage List ->
            "/campsites?type=list"

        CampsitesPage Map ->
            "/campsites?type=map"

        CampsitePage id ->
            "/campsites/" ++ id

        AboutPage ->
            "/about"

        TourPage id ->
            "/tour/"
                ++ (case id of
                        Start ->
                            "find"

                        Offline ->
                            "offline"

                        Edit ->
                            "edit"
                   )

        AdminPage ->
            "/admin"

        UnknownPage ->
            "/404"


location2page : Navigation.Location -> Page
location2page location =
    let
        builder =
            (RouteUrl.Builder.fromUrl location.href)
    in
        case RouteUrl.Builder.path builder of
            [ "campsites" ] ->
                case Dict.get "type" (RouteUrl.Builder.query builder) of
                    Just "map" ->
                        CampsitesPage Map

                    Just _ ->
                        CampsitesPage List

                    Nothing ->
                        CampsitesPage List

            [ "campsites", id ] ->
                CampsitePage id

            [ "about" ] ->
                AboutPage

            [ "tour" ] ->
                TourPage Start

            [ "tour", "find" ] ->
                TourPage Start

            [ "tour", "offline" ] ->
                TourPage Offline

            [ "tour", "edit" ] ->
                TourPage Edit

            [ "admin" ] ->
                AdminPage

            id :: _ ->
                UnknownPage

            -- Default route
            [] ->
                CampsitesPage List
