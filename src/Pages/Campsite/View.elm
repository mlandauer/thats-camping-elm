module Pages.Campsite.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Pages.Campsite.Model exposing (..)


view : Model -> Html msg
view model =
    -- TODO: Move top level div up to app view
    div [ id "app" ]
        [ p [] [ text ("This is the campsite page for campsite " ++ (toString model.campsite.id)) ] ]
