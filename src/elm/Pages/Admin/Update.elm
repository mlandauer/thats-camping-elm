module Pages.Admin.Update
    exposing
        ( Msg(..)
        , update
        , initModel
        , subscriptions
        )

import Pages.Admin.Model exposing (..)
import Pouchdb
import Location exposing (Location)
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
import Park exposing (Park)
import Http
import App.Decoder
import App.NewEncoder
import App.NewDecoder
import Json.Decode


type Msg
    = LoadData
    | NewData (Result Http.Error { parks : List Park, campsites : List Campsite })
    | Put (Result Pouchdb.PutError Pouchdb.PutSuccess)
    | Destroy
    | DestroySuccess Pouchdb.DestroySuccess
    | DestroyError Pouchdb.DestroyError


initModel : Model
initModel =
    { text = Nothing }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadData ->
            ( { model | text = Just "We should be loading data now" }, syncData )

        NewData (Err error) ->
            ( { model | text = Just (formatHttpError error) }, Cmd.none )

        NewData (Ok data) ->
            -- Now we load the new data into the local database
            ( model
            , Pouchdb.bulkDocs
                ((List.map App.NewEncoder.park data.parks)
                    ++ (List.map App.NewEncoder.campsite data.campsites)
                )
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
