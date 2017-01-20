module Pages.Campsite.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Pages.Campsite.Model exposing (..)


view : Model -> Html msg
view model =
    p [] [ text ("This is the campsite page for campsite " ++ (toString model.campsite.id)) ]
