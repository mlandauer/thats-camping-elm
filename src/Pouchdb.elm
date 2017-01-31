port module Pouchdb
    exposing
        ( put
        , putResponse
        , change
        , PutError
        , PutSuccess
        , Change
        )

import Json.Encode


type alias PutError =
    { status : Int, name : String, message : String, error : Bool }


type alias PutSuccess =
    { ok : Bool, id : String, rev : String }


type alias Revision =
    { rev : String }


type alias Change =
    { id : String, changes : List Revision, doc : Json.Encode.Value, seq : Int }


port put : Json.Encode.Value -> Cmd msg


port putSuccess : (PutSuccess -> msg) -> Sub msg


port putError : (PutError -> msg) -> Sub msg


putResponse : (Result PutError PutSuccess -> msg) -> Sub msg
putResponse a =
    Sub.batch
        [ putError (\e -> a (Err e))
        , putSuccess (\r -> a (Ok r))
        ]


port change : (Change -> msg) -> Sub msg
