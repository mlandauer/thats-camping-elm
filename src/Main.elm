module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Time
import Date
import Geolocation
import Task
import Location exposing (Location)


type alias Campsite =
    { name : String, parkName : String, location : Maybe Location }


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


campsites =
    [ Campsite "Acacia Flats" "Blue Mountains NP" (Just (Location -33.6149 150.3553))
    , Campsite "Alexanders Hut" "South East Forest NP" Nothing
    , Campsite "Apsley Falls" "Oxley Wild Rivers NP" (Just (Location -31.0540415000018 151.762134053333))
    ]


init : ( Model, Cmd Msg )
init =
    ( { campsites = campsites, location = Nothing, error = Nothing }
    , Task.attempt UpdateLocation Geolocation.now
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
            (List.map (campsiteListItem model.location) model.campsites)
        ]


formatError : Maybe Error -> String
formatError error =
    case error of
        Just err ->
            case err of
                Geolocation.PermissionDenied text ->
                    "Permission denied: " ++ text

                Geolocation.LocationUnavailable text ->
                    "Location unavailable: " ++ text

                Geolocation.Timeout text ->
                    "Timeout: " ++ text

        Nothing ->
            ""


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewCampsite campsite ->
            ( { model | campsites = campsite :: model.campsites }, Cmd.none )

        UpdateLocation result ->
            case result of
                Err error ->
                    ( { model | error = Just error }, Cmd.none )

                Ok location ->
                    ( { model | location = Just (Location location.latitude location.longitude) }, Cmd.none )


campsiteListItem : Maybe Location -> Campsite -> Html msg
campsiteListItem location campsite =
    li [] [ text (campsite.name ++ " (" ++ campsite.parkName ++ "): " ++ bearingAndDistanceAsText location campsite.location) ]



--   Convert a Maybe String to String given a value to show for Nothing


maybeString : Maybe String -> String -> String
maybeString text nothingText =
    case text of
        Just text ->
            text

        Nothing ->
            nothingText


bearingAndDistanceAsText : Maybe Location -> Maybe Location -> String
bearingAndDistanceAsText from to =
    -- TODO: Actually implement the thing
    (distanceAsText from to) ++ " " ++ (bearingAsText from to)


distanceAsText : Maybe Location -> Maybe Location -> String
distanceAsText from to =
    maybeString (Maybe.map2 Location.distanceText from to) ""


bearingAsText : Maybe Location -> Maybe Location -> String
bearingAsText from to =
    maybeString (Maybe.map2 Location.bearingText from to) ""
