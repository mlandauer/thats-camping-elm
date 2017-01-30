module Pages.Admin.Update
    exposing
        ( Msg(..)
        , update
        , initModel
        , subscriptions
        )

import Pages.Admin.Model exposing (..)
import Pouchdb
import Json.Encode


type Msg
    = AddData
    | PutError Pouchdb.PutError
    | PutSuccess Pouchdb.PutSuccess


initModel =
    { text = Nothing }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddData ->
            let
                value =
                    Json.Encode.object
                        [ ( "text", Json.Encode.string "Hello!" )
                        ]
            in
                ( model, Pouchdb.put value )

        PutError error ->
            ( { model | text = Just ("Error: " ++ error.message) }, Cmd.none )

        PutSuccess response ->
            ( { model | text = Just "Success!" }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ Pouchdb.putError PutError, Pouchdb.putSuccess PutSuccess ]
