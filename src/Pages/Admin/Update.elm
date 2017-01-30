module Pages.Admin.Update
    exposing
        ( Msg(..)
        , update
        , initModel
        , subscriptions
        )

import Pages.Admin.Model exposing (..)
import Libs.Pouchdb.Pouchdb
import Json.Encode


type Msg
    = AddData
    | PutError { message : String }


initModel =
    { text = Nothing }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddData ->
            let
                value =
                    Json.Encode.object
                        [ ( "_id", Json.Encode.int 1 )
                        , ( "text", Json.Encode.string "Hello!" )
                        ]
            in
                ( { model | text = Just "Hello!" }, (Libs.Pouchdb.Pouchdb.put value) )

        PutError error ->
            ( { model | text = Just error.message }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Libs.Pouchdb.Pouchdb.putError PutError
