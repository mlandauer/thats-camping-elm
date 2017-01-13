module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Time
import Date
import Geolocation
import Task


type alias Location =
    { latitude : Float, longitude : Float }


type alias Campsite =
    { name : String, location : Maybe Location }


type alias Model =
    { campsites : List Campsite, time : Maybe Time.Time, location : Maybe Location }


type Msg
    = NewCampsite Campsite
    | Tick Time.Time
    | UpdateLocation (Result Geolocation.Error Geolocation.Location)


campsites =
    [ Campsite "Acacia Flats" (Just (Location -33.6149 150.3553))
    , Campsite "Alexanders Hut" Nothing
    , Campsite "Apsley Falls" (Just (Location -31.0540415000018 151.762134053333))
    ]


init : ( Model, Cmd Msg )
init =
    ( { campsites = campsites, time = Nothing, location = Nothing }
    , Task.attempt UpdateLocation Geolocation.now
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every Time.second Tick


main =
    program { init = init, view = view, update = update, subscriptions = subscriptions }


view : Model -> Html Msg
view model =
    div []
        [ p [] [ text (formatTime model.time) ]
        , p [] [ text (locationAsText model.location) ]
        , ul
            [ class "campsite-list" ]
            (List.map campsiteListItem model.campsites)
        ]


formatTime : Maybe Time.Time -> String
formatTime t =
    case t of
        Just time ->
            toString (Date.second (Date.fromTime time))

        Nothing ->
            ""


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewCampsite campsite ->
            ( { model | campsites = campsite :: model.campsites }, Cmd.none )

        Tick time ->
            ( { model | time = Just time }, Cmd.none )

        UpdateLocation result ->
            case result of
                Err err ->
                    -- Do nothing for the time being
                    ( model, Cmd.none )

                Ok location ->
                    ( { model | location = Just (Location location.latitude location.longitude) }, Cmd.none )


campsiteListItem : Campsite -> Html msg
campsiteListItem campsite =
    li [] [ text (campsite.name ++ ", " ++ locationAsText campsite.location) ]


locationAsText : Maybe Location -> String
locationAsText location =
    case location of
        Just l ->
            toString l.latitude ++ ", " ++ toString l.longitude

        Nothing ->
            "unknown"
