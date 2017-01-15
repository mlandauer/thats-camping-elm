module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Time
import Date
import Geolocation
import Task
import Location exposing (Location)
import Campsite exposing (Campsite)
import Http
import Data


type alias Error =
    -- We could have more kind of errors here
    Geolocation.Error


type alias Model =
    { campsites : List Campsite
    , location : Maybe Location
    , error : Maybe Error
    }


type Msg
    = NewCampsite Campsite
    | UpdateLocation (Result Geolocation.Error Geolocation.Location)
    | NewData (Result Http.Error (List Campsite))


init : ( Model, Cmd Msg )
init =
    ( { campsites = [], location = Nothing, error = Nothing }
      -- On startup immediately try to get the location and the campsite data
    , Cmd.batch [ Task.attempt UpdateLocation Geolocation.now, syncData ]
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main =
    program { init = init, view = view, update = update, subscriptions = subscriptions }


view : Model -> Html Msg
view model =
    div []
        [ p [] [ text (formatError model.error) ]
        , ul
            [ class "campsite-list" ]
            (List.map (campsiteListItem model.location) (sortCampsites model.location model.campsites))
        ]


sortCampsites : Maybe Location -> List Campsite -> List Campsite
sortCampsites location campsites =
    List.sortWith (Campsite.compareCampsite location) campsites


formatError : Maybe Error -> String
formatError error =
    case error of
        Just (Geolocation.PermissionDenied text) ->
            "Permission denied: " ++ text

        Just (Geolocation.LocationUnavailable text) ->
            "Location unavailable: " ++ text

        Just (Geolocation.Timeout text) ->
            "Timeout: " ++ text

        Nothing ->
            ""


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewCampsite campsite ->
            ( { model | campsites = campsite :: model.campsites }, Cmd.none )

        UpdateLocation (Err error) ->
            ( { model | error = Just error }, Cmd.none )

        UpdateLocation (Ok location) ->
            ( { model | location = Just (Location location.latitude location.longitude) }, Cmd.none )

        NewData (Err error) ->
            -- TODO: Make it show the error. For the time being does nothing
            ( model, Cmd.none )

        NewData (Ok campsites) ->
            -- Replace the current campsites with the new ones
            ( { model | campsites = campsites }, Cmd.none )


campsiteListItem : Maybe Location -> Campsite -> Html msg
campsiteListItem location campsite =
    -- li [] [ text (campsite.name ++ " (" ++ campsite.parkName ++ "): " ++ bearingAndDistanceAsText location campsite.location) ]
    li [] [ text (campsite.name ++ ": " ++ bearingAndDistanceAsText location campsite.location) ]


bearingAndDistanceAsText : Maybe Location -> Maybe Location -> String
bearingAndDistanceAsText from to =
    case (Maybe.map2 Location.bearingAndDistanceText from to) of
        Just text ->
            text

        Nothing ->
            ""


syncData =
    let
        -- Just load the json data from github for the time being. Should do something
        -- more sensible than this in the longer term but it's good enough for now
        url =
            "https://raw.githubusercontent.com/mlandauer/thats-camping-react/master/data.json"

        request =
            Http.get url Data.campsitesDecoder
    in
        Http.send NewData request
