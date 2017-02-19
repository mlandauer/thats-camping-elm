module Pages.Admin.Update
    exposing
        ( Msg(..)
        , update
        , subscriptions
        , getLaneCove
        , laneCoveNameChanged
        )

import Pages.Admin.Model exposing (..)
import Pouchdb
import Campsite
    exposing
        ( Campsite
        , Toilets(..)
        , PicnicTables(..)
        , Barbecues(..)
        , Showers(..)
        , DrinkingWater(..)
        , Caravans(..)
        , Trailers(..)
        , Cars(..)
        )
import Http
import App.Decoder
import App.NewEncoder
import Dict exposing (Dict)


type Msg
    = LoadData
    | NewData (Result Http.Error { parks : List App.Decoder.Park, campsites : List App.Decoder.Campsite })
    | Put (Result Pouchdb.PutError Pouchdb.PutSuccess)
    | Destroy
    | DestroySuccess Pouchdb.DestroySuccess
    | DestroyError Pouchdb.DestroyError
    | ToggleLaneCoveName
    | Migrate


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadData ->
            ( { model | text = Just "We should be loading data now" }, syncData )

        NewData (Err error) ->
            ( { model | text = Just (formatHttpError error) }, Cmd.none )

        NewData (Ok data) ->
            let
                campsites =
                    transform data.campsites data.parks
            in
                -- Now we load the new data into the local database
                ( model
                , Pouchdb.bulkDocs (List.map App.NewEncoder.campsite campsites)
                )

        Destroy ->
            ( model, Pouchdb.destroy () )

        DestroySuccess _ ->
            ( { model | text = Just "Destroyed local database" }, Cmd.none )

        DestroyError _ ->
            ( { model | text = Just "Error destroying local database" }, Cmd.none )

        Put (Ok _) ->
            ( { model | text = Just "Added data" }, Cmd.none )

        Put (Err error) ->
            ( { model | text = Just ("Error: " ++ error.message) }, Cmd.none )

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


transform : List App.Decoder.Campsite -> List App.Decoder.Park -> List Campsite
transform campsites parks =
    List.map
        (\campsite ->
            { id = campsite.id
            , name = campsite.longName
            , description = campsite.description
            , location = campsite.location
            , facilities = campsite.facilities
            , access = campsite.access
            , parkName =
                Maybe.withDefault ""
                    (Maybe.map .longName (parkWithId campsite.parkId parks))
            , revision = Nothing
            }
        )
        campsites


parkWithId : String -> List App.Decoder.Park -> Maybe App.Decoder.Park
parkWithId id parks =
    List.head (List.filter (\park -> park.id == id) parks)


putCampsite : Campsite -> Cmd msg
putCampsite campsite =
    Pouchdb.put (App.NewEncoder.campsite campsite)


getLaneCove : Dict String Campsite -> Maybe Campsite
getLaneCove campsites =
    Dict.get "c126" campsites


toggleLaneCoveName : Campsite -> Campsite
toggleLaneCoveName campsite =
    if laneCoveNameChanged campsite then
        { campsite | name = "Lane Cove River tourist park" }
    else
        { campsite | name = "Lane Cove River - I've been updated!" }


laneCoveNameChanged : Campsite -> Bool
laneCoveNameChanged campsite =
    campsite.name /= "Lane Cove River tourist park"


syncData : Cmd Msg
syncData =
    let
        -- Just load the json data from github for the time being. Should do something
        -- more sensible than this in the longer term but it's good enough for now
        url =
            "https://raw.githubusercontent.com/mlandauer/thats-camping-react/master/data.json"

        request =
            Http.get url App.Decoder.parksAndCampsites
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


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Pouchdb.putResponse Put
        , Pouchdb.destroySuccess DestroySuccess
        , Pouchdb.destroyError DestroyError
        ]
