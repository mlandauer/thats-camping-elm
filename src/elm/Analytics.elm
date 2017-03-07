port module Analytics exposing (screenView, name)

import App.Model
    exposing
        ( Page(..)
        , TourPageId(..)
        , CampsitesPageOption(..)
        )


{- TODO: Make it so we can just pass a page and we do the conversion
   to a string here
-}


port screenView : String -> Cmd msg


name : Page -> String
name page =
    -- This is how the screen views are recorded in Google Analytics
    case page of
        AboutPage ->
            "About"

        CampsitesPage List ->
            "Campsites List"

        CampsitesPage Map ->
            "Campsites Map"

        TourPage Start ->
            "Tour Start"

        TourPage Offline ->
            "Tour Offline"

        TourPage Edit ->
            "Tour Edit"

        AdminPage ->
            "Admin"

        CampsitePage id ->
            "Campsite " ++ id

        UnknownPage ->
            "Unknown"
