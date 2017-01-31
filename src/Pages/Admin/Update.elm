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
    | Destroy
    | DestroySuccess Pouchdb.DestroySuccess
    | DestroyError Pouchdb.DestroyError
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

        Destroy ->
            ( model, Pouchdb.destroy () )

        DestroySuccess _ ->
            ( { model | text = Just "Destroyed local database" }, Cmd.none )

        DestroyError _ ->
            ( { model | text = Just "Error destroying local database" }, Cmd.none )

        Put (Ok _) ->
            ( { model | text = Just "Added data" }, Cmd.none )

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
        , Pouchdb.destroySuccess DestroySuccess
        , Pouchdb.destroyError DestroyError
        ]
