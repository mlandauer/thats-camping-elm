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
    [ Campsite "Acacia Flats" (Just (Location -33.6149 150.3553))
    , Campsite "Alexanders Hut" Nothing
    , Campsite "Apsley Falls" (Just (Location -31.0540415000018 151.762134053333))
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
        , p [] [ text (locationAsText model.location) ]
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
campsiteListItem userLocation campsite =
    li [] [ text (campsite.name ++ ": " ++ bearingAndDistanceAsText campsite.location userLocation) ]


locationAsText : Maybe Location -> String
locationAsText location =
    case location of
        Just l ->
            toString l.latitude ++ ", " ++ toString l.longitude

        Nothing ->
            "unknown"


bearingAndDistanceAsText : Maybe Location -> Maybe Location -> String
bearingAndDistanceAsText location userLocation =
    -- TODO: Actually implement the thing
    (distanceAsText location userLocation) ++ " " ++ (bearingAsText location userLocation)


distanceAsText : Maybe Location -> Maybe Location -> String
distanceAsText position1 position2 =
    let
        d =
            Maybe.map2 distanceInMetres position1 position2
    in
        case d of
            Just d ->
                (toString d) ++ " metres"

            Nothing ->
                ""


bearingAsText : Maybe Location -> Maybe Location -> String
bearingAsText position1 position2 =
    let
        bearing =
            Maybe.map2 bearingInDegrees position1 position2
    in
        case bearing of
            Just bearing ->
                (toString bearing) ++ " degrees"

            Nothing ->
                ""


distanceInMetres : Location -> Location -> Float
distanceInMetres position1 position2 =
    let
        r =
            6371000

        dLat =
            degrees (position2.latitude - position1.latitude)

        dLon =
            degrees (position2.longitude - position1.longitude)

        a =
            sin (dLat / 2) * sin (dLat / 2) + cos (degrees (position1.latitude)) * cos (degrees (position2.latitude)) * sin (dLon / 2) * sin (dLon / 2)

        c =
            2 * atan2 (sqrt a) (sqrt (1 - a))
    in
        r * c


bearingInDegrees : Location -> Location -> Float
bearingInDegrees position1 position2 =
    let
        lon2 =
            degrees position2.longitude

        lat2 =
            degrees position2.latitude

        lon1 =
            degrees position1.longitude

        lat1 =
            degrees position1.latitude

        dLon =
            lon1 - lon2

        y =
            sin (dLon) * cos (lat1)

        x =
            cos (lat2) * sin (lat1) - sin (lat2) * cos (lat1) * cos (dLon)

        -- This is a number between 0 and 360
        -- TODO: Convert this so that it goes between 0 and 360
        bearing =
            (atan2 y x) / pi * 180
    in
        bearing
