port module Pouchdb
    exposing
        ( put
        , putResponse
        , PutError
        , PutSuccess
        , destroy
        , destroySuccess
        , destroyError
        , DestroySuccess
        , DestroyError
        , change
        , Change
        )

import Json.Encode


type alias PutError =
    { status : Maybe Int, name : Maybe String, message : String, error : Bool }


type alias PutSuccess =
    { ok : Bool, id : String, rev : String }


type alias Revision =
    { rev : String }


type alias Change =
    { id : String, changes : List Revision, doc : Json.Encode.Value, seq : Int }


type alias DestroySuccess =
    { ok : Bool }


type alias DestroyError =
    {}


port put : Json.Encode.Value -> Cmd msg


port destroy : () -> Cmd msg


port destroySuccess : (DestroySuccess -> msg) -> Sub msg


port destroyError : (DestroyError -> msg) -> Sub msg


port putSuccess : (PutSuccess -> msg) -> Sub msg


port putError : (PutError -> msg) -> Sub msg


putResponse : (Result PutError PutSuccess -> msg) -> Sub msg
putResponse a =
    Sub.batch
        [ putError (\e -> a (Err e))
        , putSuccess (\r -> a (Ok r))
        ]


port change : (Change -> msg) -> Sub msg
