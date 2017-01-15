module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
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
    div [ id "app" ]
        [ div [ class "campsite-list" ]
            [ nav [ class "navbar navbar-default navbar-fixed-top" ]
                [ div [ class "container" ]
                    [ a [ href "#", class "btn navbar-link navbar-text pull-right" ]
                        [ span [ class "glyphicon glyphicon-info-sign" ] [] ]
                    , h1 [] [ text "Camping near you" ]
                    ]
                ]
            , div [ class "content" ]
                [ p [] [ text (formatError model.error) ]
                  -- Not sure about ul here (because there's currently no matching li's)
                , ul [ class "list-group" ]
                    (List.map (campsiteListItem model.location) (sortCampsites model.location model.campsites))
                ]
            ]
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
    a [ href "#", class "list-group-item" ]
        [ div [ class "campsite" ]
            [ div [ class "pull-right distance" ] [ text (bearingAndDistanceAsText location campsite.location) ]
            , div [ class "name" ] [ text campsite.name ]
            , div [ class "park" ] [ text "" ]
            ]
        ]


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
