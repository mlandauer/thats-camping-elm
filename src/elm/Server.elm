port module Server exposing (main, request)

import Json.Decode


type alias Model =
    {}


type Msg
    = Request String


main : Program Never Model Msg
main =
    Platform.program
        { init = init
        , subscriptions = subscriptions
        , update = update
        }


init : ( Model, Cmd msg )
init =
    -- TODO: Initialise with something
    ( {}, Cmd.none )


subscriptions : model -> Sub Msg
subscriptions model =
    request Request


update : Msg -> model -> ( model, Cmd Msg )
update msg model =
    case msg of
        Request r ->
            let
                _ =
                    Debug.log "request" r
            in
                -- TODO: Do something
                ( model, Cmd.none )


port request : (String -> msg) -> Sub msg
