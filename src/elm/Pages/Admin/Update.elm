module Pages.Admin.Update
    exposing
        ( Msg(..)
        , update
        , subscriptions
        , getLaneCove
        , laneCoveNameChanged
        )

import Pouchdb
import Campsite
    exposing
        ( Campsite
        
        
        , BarbecuesCore(..)
        
        , DrinkingWaterCore(..)
        
        
        )
import Http
import App.GitHubDecoder
import App.Encoder
import Dict exposing (Dict)
import Errors
import App.Model


type Msg
    = LoadData
    | NewData (Result Http.Error { parks : List App.GitHubDecoder.Park, campsites : List App.GitHubDecoder.Campsite })
    | Put (Result Pouchdb.PutError Pouchdb.PutSuccess)
    | Destroy
    | DestroySuccess Pouchdb.DestroySuccess
    | DestroyError Pouchdb.DestroyError
    | ToggleLaneCoveName
    | Migrate
    | ErrorsMsg Errors.Msg


update : Msg -> App.Model.Model -> ( App.Model.Model, Cmd Msg )
update msg model =
    case msg of
        LoadData ->
            ( { model
                | errors =
                    Errors.add "We should be loading data now" model.errors
              }
            , syncData
            )

        NewData (Err error) ->
            ( { model
                | errors =
                    Errors.add (formatHttpError error) model.errors
              }
            , Cmd.none
            )

        NewData (Ok data) ->
            let
                campsites =
                    transform data.campsites data.parks
                        |> List.map (\c -> ( c.id, c ))
                        |> Dict.fromList

                -- Merge new campsite data in (but don't save it to the local database)
                -- TODO: This merging would be more elegant, I think, if the
                -- revision was separated from the actual campsite data
                newCampsites =
                    Dict.map (merge campsites) model.campsites
            in
                ( { model | campsites = newCampsites }, Cmd.none )

        Destroy ->
            ( model, Pouchdb.destroy () )

        DestroySuccess _ ->
            ( { model
                | errors =
                    Errors.add "Destroyed local database" model.errors
              }
            , Cmd.none
            )

        DestroyError _ ->
            ( { model
                | errors =
                    Errors.add "Error destroying local database" model.errors
              }
            , Cmd.none
            )

        Put (Ok _) ->
            ( { model
                | errors =
                    Errors.add "Added data" model.errors
              }
            , Cmd.none
            )

        Put (Err error) ->
            ( { model
                | errors =
                    Errors.add ("Error: " ++ error.message) model.errors
              }
            , Cmd.none
            )

        ToggleLaneCoveName ->
            case getLaneCove model.campsites of
                Just campsite ->
                    ( model, putCampsite (toggleLaneCoveName campsite) )

                Nothing ->
                    ( model, Cmd.none )

        Migrate ->
            -- Crudely do a migration by just resaving all the currently loaded campsites
            ( model
            , Cmd.batch (List.map putCampsite (Dict.values model.campsites))
            )

        ErrorsMsg msg ->
            ( { model | errors = Errors.update msg model.errors }, Cmd.none )


merge : Dict String Campsite -> String -> Campsite -> Campsite
merge campsites id c =
    case (Dict.get c.id campsites) of
        Just c2 ->
            -- Maintain the old revision so we can save this
            { c2 | revision = c.revision }

        Nothing ->
            c


transform : List App.GitHubDecoder.Campsite -> List App.GitHubDecoder.Park -> List Campsite
transform campsites parks =
    List.map
        (\campsite ->
            { id = campsite.id
            , name = campsite.longName |> Campsite.name
            , description = campsite.description
            , location = campsite.location
            , facilities = campsite.facilities
            , access = campsite.access
            , parkName =
                parkWithId campsite.parkId parks
                    |> Maybe.map .longName
                    |> Maybe.withDefault ""
                    |> Campsite.name
            , revision = Nothing
            }
        )
        campsites


parkWithId : String -> List App.GitHubDecoder.Park -> Maybe App.GitHubDecoder.Park
parkWithId id parks =
    List.head (List.filter (\park -> park.id == id) parks)


putCampsite : Campsite -> Cmd msg
putCampsite campsite =
    Pouchdb.put (App.Encoder.campsite campsite)


getLaneCove : Dict String Campsite -> Maybe Campsite
getLaneCove campsites =
    Dict.get "c126" campsites


toggleLaneCoveName : Campsite -> Campsite
toggleLaneCoveName campsite =
    if laneCoveNameChanged campsite then
        { campsite | name = Campsite.name "Lane Cove River tourist park" }
    else
        { campsite | name = Campsite.name "Lane Cove River - I've been updated!" }


laneCoveNameChanged : Campsite -> Bool
laneCoveNameChanged campsite =
    campsite.name /= Campsite.name "Lane Cove River tourist park"


syncData : Cmd Msg
syncData =
    let
        -- Just load the json data from github for the time being. Should do something
        -- more sensible than this in the longer term but it's good enough for now
        url =
            "https://raw.githubusercontent.com/mlandauer/thats-camping-react/master/data.json"

        request =
            Http.get url App.GitHubDecoder.parksAndCampsites
    in
        Http.send NewData request


formatHttpError : Http.Error -> String
formatHttpError error =
    case error of
        Http.BadUrl text ->
            "Bad URL: " ++ text

        Http.Timeout ->
            "Timeout"

        Http.NetworkError ->
            "Network Error"

        Http.BadStatus response ->
            "Bad Status"

        Http.BadPayload text response ->
            "Bad payload: " ++ text


subscriptions : App.Model.Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Pouchdb.putResponse Put
        , Pouchdb.destroySuccess DestroySuccess
        , Pouchdb.destroyError DestroyError
        ]
