module Pages.Admin.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Pages.Admin.Update exposing (..)
import Errors
import App.Model


view : App.Model.Model -> Html Msg
view model =
    div [ class "content" ]
        [ div [ class "container" ]
            [ Html.map ErrorsMsg (Errors.view model.errors)
            , h2 [] [ text "Database admin" ]
            , p [] [ text "Here you can do actions on the local PouchDB database" ]
            , div [ class "btn-group-vertical" ]
                [ button [ class "btn btn-default", onClick Destroy ] [ text "Destroy local database" ]
                , button [ class "btn btn-default", onClick LoadData ] [ text "Load local database campsite data from Github" ]
                , button [ class "btn btn-default", onClick ToggleLaneCoveName ]
                    [ text
                        ((if Maybe.withDefault False (Maybe.map laneCoveNameChanged (getLaneCove model.campsites)) then
                            "Reset"
                          else
                            "Change"
                         )
                            ++ " name of Lane Cover River campsite"
                        )
                    ]
                , button [ class "btn btn-default", onClick Migrate ] [ text "Migrate database" ]
                ]
            ]
        ]
