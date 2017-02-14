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
        , changes
        , changeSuccess
        , ChangeSuccess
        , changeComplete
        , ChangeComplete
        , bulkDocs
        )

import Json.Encode


type alias PutError =
    { status : Maybe Int, name : Maybe String, message : String, error : Bool }


type alias PutSuccess =
    { ok : Bool, id : String, rev : String }


type alias Revision =
    { rev : String }


type alias ChangeSuccess =
    { id : String, changes : List Revision, doc : Json.Encode.Value, seq : Int }


type alias ChangeComplete =
    { results : List ChangeSuccess, last_seq : Int }


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


type alias ChangesOptions =
    -- TODO: Support all the options
    { live : Bool, include_docs : Bool, return_docs : Bool }


port changes : ChangesOptions -> Cmd msg


port changeSuccess : (ChangeSuccess -> msg) -> Sub msg


port changeComplete : (ChangeComplete -> msg) -> Sub msg


port bulkDocs : List Json.Encode.Value -> Cmd msg
