module Pages.Admin.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)


view =
    div [ class "content" ]
        [ div [ class "container" ]
            [ p [] [ text "This will become the admin page to experiment with pouchdb" ]
            ]
        ]
