module Pages.Campsite.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)


view : Html msg
view =
    -- TODO: Move top level div up to app view
    div [ id "app" ]
        [ p [] [ text "This is the campsite page!" ] ]
