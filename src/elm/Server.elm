port module Server exposing (main, request, response)

import Json.Decode
import App.Update
import App.View
import HtmlToString
import Dict
import Campsite
import Pouchdb
import App.NewDecoder
import Dict
import App.Routing


type alias ResponseInfo =
    { id : Int, html : String }


type alias RequestInfo =
    { id : Int, url : String }


port request : (RequestInfo -> msg) -> Sub msg


port response : ResponseInfo -> Cmd msg


type alias Model =
    { campsites : Dict.Dict String Campsite.Campsite }


type Msg
    = Request RequestInfo
    | ChangeSuccess Pouchdb.ChangeSuccess


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
    ( { campsites = Dict.empty }, Cmd.none )


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
                        { version = ""
                        , standalone = False
                        , starredCampsites = Nothing
                        , online = True
                        , location = Nothing
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
                    { m | campsites = model.campsites, page = page }

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
                    Json.Decode.decodeValue App.NewDecoder.campsite change.doc
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
