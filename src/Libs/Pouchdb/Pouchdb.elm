port module Libs.Pouchdb.Pouchdb exposing (put, putError)

import Json.Encode


port put : Json.Encode.Value -> Cmd msg


port putError : ({ message : String } -> msg) -> Sub msg
