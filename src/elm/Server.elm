port module Server exposing (main, request, response)

import Json.Decode
import App.Update
import App.View
import HtmlToString
import Dict
import Campsite


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
            let
                m =
                    App.Update.initModel
                        { version = ""
                        , standalone = False
                        , starredCampsites = Nothing
                        , online = True
                        , location = Nothing
                        }

                m2 =
                    { m
                        | campsites =
                            Dict.fromList
                                [ ( "1"
                                  , { access =
                                        { caravans = Nothing
                                        , trailers = Nothing
                                        , cars = Nothing
                                        }
                                    , description = "A nice campsite to test things with"
                                    , facilities =
                                        { toilets = Nothing
                                        , picnicTables = Nothing
                                        , barbecues = Nothing
                                        , showers = Nothing
                                        , drinkingWater = Nothing
                                        }
                                    , id = "1"
                                    , location = Nothing
                                    , name = Campsite.name "Test campsite"
                                    , parkName = Campsite.name "Test park"
                                    , revision = Nothing
                                    }
                                  )
                                ]
                    }

                v =
                    App.View.view m2

                s =
                    HtmlToString.htmlToString v
            in
                ( model, response s )
