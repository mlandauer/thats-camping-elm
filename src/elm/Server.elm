port module Server exposing (main, request, response)

import Json.Decode


port request : (() -> msg) -> Sub msg


port response : String -> Cmd msg


type alias Model =
    {}


type Msg
    = Request ()


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
        Request _ ->
            ( model, response "Hello world!" )
