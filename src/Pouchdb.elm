port module Pouchdb
    exposing
        ( put
        , putError
        , putSuccess
        , PutError
        , PutSuccess
        )

import Json.Encode


type alias PutError =
    { status : Int, name : String, message : String, error : Bool }


type alias PutSuccess =
    { ok : Bool, id : String, rev : String }


port put : Json.Encode.Value -> Cmd msg


port putSuccess : (PutSuccess -> msg) -> Sub msg


port putError : (PutError -> msg) -> Sub msg
