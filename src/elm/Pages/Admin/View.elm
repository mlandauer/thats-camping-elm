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
            [ h2 [] [ text "Database admin page" ]
            , p [] [ text "Here you can do actions on the local PouchDB database" ]
            , button [ class "btn btn-default", onClick Destroy ] [ text "Destroy local database" ]
            , button [ class "btn btn-default", onClick LoadData ] [ text "Load local database campsite data from Github" ]
            , p [] [ text (Maybe.withDefault "" model.text) ]
            ]
        ]
