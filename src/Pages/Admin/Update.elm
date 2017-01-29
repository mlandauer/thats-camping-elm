module Pages.Admin.Update exposing (Msg(..), update, initModel)

import Pages.Admin.Model exposing (..)


type Msg
    = AddData


initModel =
    { text = Nothing }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddData ->
            ( { model | text = Just "Hello!" }, Cmd.none )
