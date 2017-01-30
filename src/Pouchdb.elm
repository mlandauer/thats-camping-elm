port module Pouchdb
    exposing
        ( put
        , putError
        , putSuccess
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


port change : (Change -> msg) -> Sub msg
