module Pages.Admin.Update
    exposing
        ( Msg(..)
        , update
        , initModel
        , subscriptions
        )

import Pages.Admin.Model exposing (..)
import Pouchdb
import Json.Encode
import App.Model
    exposing
        ( Park
        , Campsite
        , Location
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


type Msg
    = AddData
    | LoadData
    | NewData (Result Http.Error { parks : List Park, campsites : List Campsite })
    | Put (Result Pouchdb.PutError Pouchdb.PutSuccess)
    | Destroy
    | DestroySuccess Pouchdb.DestroySuccess
    | DestroyError Pouchdb.DestroyError
    | Change Pouchdb.Change


initModel =
    { text = Nothing }


locationEncoder : Maybe Location -> Json.Encode.Value
locationEncoder location =
    case location of
        Just location ->
            Json.Encode.object
                [ ( "latitude", Json.Encode.float location.latitude )
                , ( "longitude", Json.Encode.float location.longitude )
                ]

        Nothing ->
            Json.Encode.null


toiletsEncoder : Maybe Toilets -> Json.Encode.Value
toiletsEncoder toilets =
    case toilets of
        Just NonFlushToilets ->
            Json.Encode.string "non_flush"

        Just FlushToilets ->
            Json.Encode.string "flush"

        Just NoToilets ->
            Json.Encode.string "none"

        Nothing ->
            Json.Encode.null


picnicTablesEncoder : Maybe PicnicTables -> Json.Encode.Value
picnicTablesEncoder picnicTables =
    case picnicTables of
        Just PicnicTables ->
            Json.Encode.bool True

        Just NoPicnicTables ->
            Json.Encode.bool False

        Nothing ->
            Json.Encode.null


barbecuesEncoder : Maybe Barbecues -> Json.Encode.Value
barbecuesEncoder barbecues =
    case barbecues of
        Just WoodBarbecues ->
            Json.Encode.string "wood"

        Just WoodSuppliedBarbecues ->
            Json.Encode.string "wood_supplied"

        Just WoodBringYourOwnBarbecues ->
            Json.Encode.string "wood_bring_your_own"

        Just GasElectricBarbecues ->
            Json.Encode.string "gas_electric"

        Just NoBarbecues ->
            Json.Encode.string "none"

        Nothing ->
            Json.Encode.null


showersEncoder : Maybe Showers -> Json.Encode.Value
showersEncoder showers =
    case showers of
        Just HotShowers ->
            Json.Encode.string "hot"

        Just ColdShowers ->
            Json.Encode.string "cold"

        Just NoShowers ->
            Json.Encode.string "none"

        Nothing ->
            Json.Encode.null


drinkingWaterEncoder : Maybe DrinkingWater -> Json.Encode.Value
drinkingWaterEncoder drinkingWater =
    case drinkingWater of
        Just DrinkingWater ->
            Json.Encode.bool True

        Just NoDrinkingWater ->
            Json.Encode.bool False

        Nothing ->
            Json.Encode.null


facilitiesEncoder facilities =
    Json.Encode.object
        [ ( "toilets", toiletsEncoder facilities.toilets )
        , ( "picnicTables", picnicTablesEncoder facilities.picnicTables )
        , ( "barbecues", barbecuesEncoder facilities.barbecues )
        , ( "showers", showersEncoder facilities.showers )
        , ( "drinkingWater", drinkingWaterEncoder facilities.drinkingWater )
        ]


caravansEncoder : Maybe Caravans -> Json.Encode.Value
caravansEncoder caravans =
    case caravans of
        Just Caravans ->
            Json.Encode.bool True

        Just NoCaravans ->
            Json.Encode.bool False

        Nothing ->
            Json.Encode.null


trailersEncoder : Maybe Trailers -> Json.Encode.Value
trailersEncoder trailers =
    case trailers of
        Just Trailers ->
            Json.Encode.bool True

        Just NoTrailers ->
            Json.Encode.bool False

        Nothing ->
            Json.Encode.null


carsEncoder : Maybe Cars -> Json.Encode.Value
carsEncoder cars =
    case cars of
        Just Cars ->
            Json.Encode.bool True

        Just NoCars ->
            Json.Encode.bool False

        Nothing ->
            Json.Encode.null


accessEncoder access =
    Json.Encode.object
        [ ( "caravans", caravansEncoder access.caravans )
        , ( "trailers", trailersEncoder access.trailers )
        , ( "cars", carsEncoder access.cars )
        ]


campsiteEncoder : Campsite -> Json.Encode.Value
campsiteEncoder campsite =
    Json.Encode.object
        [ ( "_id", Json.Encode.string ("c" ++ toString campsite.id) )
        , ( "shortName", Json.Encode.string campsite.shortName )
        , ( "longName", Json.Encode.string campsite.longName )
        , ( "description", Json.Encode.string campsite.description )
        , ( "location", locationEncoder campsite.location )
        , ( "facilities", facilitiesEncoder campsite.facilities )
        , ( "access", accessEncoder campsite.access )
        , ( "parkId", Json.Encode.string ("p" ++ toString campsite.parkId) )
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddData ->
            let
                value =
                    Json.Encode.object
                        [ ( "text", Json.Encode.string "Hello!" )
                        ]
            in
                ( model, Pouchdb.put value )

        LoadData ->
            ( { model | text = Just "We should be loading data now" }, syncData )

        NewData (Err error) ->
            ( { model | text = Just (formatHttpError error) }, Cmd.none )

        NewData (Ok data) ->
            -- Now we load the new data into the local database
            -- For the time being just load the first campsite
            case List.head data.campsites of
                Just campsite ->
                    ( model, Pouchdb.put (campsiteEncoder campsite) )

                Nothing ->
                    ( model, Cmd.none )

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

        Change change ->
            let
                foo =
                    Debug.log "change" change
            in
                ( model, Cmd.none )


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
        , Pouchdb.change Change
        , Pouchdb.destroySuccess DestroySuccess
        , Pouchdb.destroyError DestroyError
        ]
