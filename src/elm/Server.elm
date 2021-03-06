port module Server exposing (main, request, response)

import Json.Decode
import App.Update
import App.View
import HtmlToString
import Dict
import Campsite
import Pouchdb
import App.Decoder
import Dict
import App.Routing


type alias ResponseInfo =
    { id : Int, html : String }


type alias RequestInfo =
    { id : Int, url : String }


port request : (RequestInfo -> msg) -> Sub msg


port response : ResponseInfo -> Cmd msg


type alias Model =
    { campsites : Dict.Dict String Campsite.Campsite, version : String }


type Msg
    = Request RequestInfo
    | ChangeSuccess Pouchdb.ChangeSuccess


type alias Flags =
    { version : String }


main : Program Flags Model Msg
main =
    Platform.programWithFlags
        { init = init
        , subscriptions = subscriptions
        , update = update
        }


init : Flags -> ( Model, Cmd msg )
init flags =
    -- TODO: Initialise with something
    ( { campsites = Dict.empty, version = flags.version }, Cmd.none )


subscriptions : model -> Sub Msg
subscriptions model =
    Sub.batch
        [ request Request
        , Pouchdb.changeSuccess ChangeSuccess
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Request request ->
            let
                m =
                    App.Update.initModel
                        { version = model.version
                        , standalone = False
                        , starredCampsites = Nothing
                        , online = True
                        , location = Nothing
                        , docs = []
                        , sequence = 0
                        , limitList = True
                        }

                page =
                    App.Routing.location2page
                        -- Only using href later on so not bothering to fill out the others
                        { href = request.url
                        , hash = ""
                        , host = ""
                        , hostname = ""
                        , origin = ""
                        , password = ""
                        , pathname = ""
                        , port_ = ""
                        , protocol = ""
                        , search = ""
                        , username = ""
                        }

                m2 =
                    { m
                        | campsites = model.campsites
                        , page = page
                        , previousPages = m.page :: m.previousPages
                    }

                v =
                    App.View.view m2

                s =
                    HtmlToString.htmlToString v
            in
                ( model, response { id = request.id, html = s } )

        ChangeSuccess change ->
            -- TODO: Need to think how to handle deleted documents. Is this
            -- something we actually need to handle?
            -- This is currently duplicating a bit of code from elsewhere
            -- TODO: Make it not duplicated
            let
                o =
                    Json.Decode.decodeValue App.Decoder.campsite change.doc
            in
                case o of
                    Ok campsite ->
                        ( { model
                            | campsites =
                                Dict.insert campsite.id campsite model.campsites
                          }
                        , Cmd.none
                        )

                    Err _ ->
                        -- TODO: Show these errors to the user rather than silently ignore
                        ( model, Cmd.none )
