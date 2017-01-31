module Pages.Admin.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Pages.Admin.Update exposing (..)
import Pages.Admin.Model exposing (..)


view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ div [ class "container" ]
            [ p [] [ text "This will become the admin page to experiment with pouchdb" ]
            , button [ class "btn btn-default", onClick AddData ] [ text "Add some data to the model" ]
            , button [ class "btn btn-default", onClick Destroy ] [ text "Destroy local database" ]
            , p [] [ text (Maybe.withDefault "" model.text) ]
            ]
        ]
