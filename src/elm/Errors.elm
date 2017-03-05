module Errors exposing (view, Msg(..), update, initModel, add)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type Msg
    = Clear


type alias Model =
    List String


initModel : Model
initModel =
    []


view : Model -> Html Msg
view errors =
    if List.isEmpty errors then
        text ""
    else
        div [ class "alert alert-warning text-center" ]
            ([ button [ class "pull-right close", onClick Clear ] [ text "×" ] ]
                ++ (List.map
                        (\error ->
                            (p []
                                [ span [ class "glyphicon glyphicon-exclamation-sign" ] []
                                , text " "
                                , text error
                                ]
                            )
                        )
                        errors
                   )
            )


update : Msg -> Model -> Model
update msg errors =
    case msg of
        Clear ->
            []


add : String -> Model -> Model
add error errors =
    error :: errors
