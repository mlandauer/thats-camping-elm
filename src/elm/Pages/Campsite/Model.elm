module Pages.Campsite.Model exposing (Model)

import App.Model exposing (Campsite, Park)


type alias Model =
    { campsite : Campsite
    , park : Maybe Park
    }
