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
    | Put (Result Pouchdb.PutError Pouchdb.PutSuccess)
    | Change Pouchdb.Change


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

        Put (Ok response) ->
            ( { model | text = Just "Success!" }, Cmd.none )

        Put (Err error) ->
            ( { model | text = Just ("Error: " ++ error.message) }, Cmd.none )

        Change change ->
            let
                foo =
                    Debug.log "change" change
            in
                ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Pouchdb.putResponse Put
        , Pouchdb.change Change
        ]
