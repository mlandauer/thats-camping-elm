module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Time
import Date
import Geolocation
import Task
import Location exposing (Location)
import Campsite exposing (Campsite)
import Park exposing (Park)
import Http
import Decoder
import Dict exposing (Dict)
import RouteUrl
import RouteUrl.Builder
import Navigation


type alias Error =
    -- We could have more kind of errors here
    Geolocation.Error


type Page
    = Campsites
    | About


type alias Model =
    { campsites : List Campsite
    , parks : Dict Int Park
    , location : Maybe Location
    , error : Maybe Error
    , page : Page
    }


type Msg
    = NewCampsite Campsite
    | UpdateLocation (Result Geolocation.Error Geolocation.Location)
    | NewData (Result Http.Error { parks : List Park, campsites : List Campsite })
    | ChangePage Page
    | PageBack


init : ( Model, Cmd Msg )
init =
    ( { campsites = [], parks = Dict.empty, location = Nothing, error = Nothing, page = Campsites }
      -- On startup immediately try to get the location and the campsite data
    , Cmd.batch [ Task.attempt UpdateLocation Geolocation.now, syncData ]
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main =
    RouteUrl.program { delta2url = delta2hash, location2messages = hash2messages, init = init, view = view, update = update, subscriptions = subscriptions }


hash2messages : Navigation.Location -> List Msg
hash2messages location =
    let
        hash =
            RouteUrl.Builder.path (RouteUrl.Builder.fromHash location.href)
    in
        if hash == [ "campsites" ] then
            [ ChangePage Campsites ]
        else if hash == [ "about" ] then
            [ ChangePage About ]
        else
            -- TODO: Show a 404 page here instead of doing nothing
            []


delta2hash : Model -> Model -> Maybe RouteUrl.UrlChange
delta2hash previous current =
    Just (RouteUrl.UrlChange RouteUrl.NewEntry (page2url current.page))


page2url : Page -> String
page2url page =
    case page of
        Campsites ->
            "#/campsites"

        About ->
            "#/about"


view : Model -> Html Msg
view model =
    case model.page of
        Campsites ->
            campsitesView model

        About ->
            aboutView model


campsitesView : Model -> Html Msg
campsitesView model =
    div [ id "app" ]
        [ div [ class "campsite-list" ]
            [ navBar "Camping near you" False True
            , div [ class "content" ]
                [ div [] [ text (formatError model.error) ]
                , div [ class "list-group" ]
                    (List.map (campsiteListItem model.location model.parks) (sortCampsites model.location model.campsites))
                ]
            ]
        ]


aboutButton : Html Msg
aboutButton =
    link About
        [ class "btn navbar-link navbar-text pull-right" ]
        [ span [ class "glyphicon glyphicon-info-sign" ] [] ]


backButton : Html Msg
backButton =
    button [ onClick PageBack, class "btn btn-link navbar-link navbar-text pull-left" ]
        [ span [ class "glyphicon glyphicon-menu-left" ] [] ]


link : Page -> List (Attribute Msg) -> List (Html Msg) -> Html Msg
link page attributes html =
    a ((href (page2url page)) :: attributes) html


navBar : String -> Bool -> Bool -> Html Msg
navBar title showBack showAbout =
    -- TODO: Turn showBack and showAbout into a record for legibility
    nav [ class "navbar navbar-default navbar-fixed-top" ]
        [ div [ class "container" ]
            ((if showBack then
                [ backButton ]
              else
                []
             )
                ++ (if showAbout then
                        [ aboutButton ]
                    else
                        []
                   )
                ++ [ h1 [] [ text title ] ]
            )
        ]


aboutView model =
    div [ id "app" ]
        [ div [ class "campsite-list" ]
            [ navBar "About" True False
            , div [ class "content" ]
                [ h2 [] [ text "About That's Camping" ]
                , p [] [ text "Find campsites near you in New South Wales, Australia. It covers camping on public, common land such as National Parks, State Forests and Local Council land." ]
                , p []
                    [ text "It works "
                    , strong [] [ text "completely offline" ]
                    , text ", even when you're far far away from a mobile phone tower. When does that ever happen while camping?"
                    ]
                , p []
                    [ text "Made by "
                    , a [ href "https://twitter.com/matthewlandauer" ] [ text "Matthew Landauer" ]
                    , text " based on an iOS app. It's free and "
                    , a [ href "https://github.com/mlandauer/thats-camping-elm" ] [ text "open source" ]
                    , text " because that's the way it ought to be."
                    ]
                  -- TODO: Show current version of the app here
                , h2 [] [ text "Things you might want to do" ]
                , p []
                    [ a [ href "https://github.com/mlandauer/thats-camping-elm/issues" ]
                        [ text "Suggest a "
                        , strong [] [ text "feature" ]
                        , text " or report an "
                        , strong [] [ text "issue" ]
                        ]
                    ]
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

        NewData (Ok data) ->
            -- Replace the current campsites with the new ones
            ( { model | campsites = data.campsites, parks = (transformParks data.parks) }, Cmd.none )

        ChangePage page ->
            ( { model | page = page }, Cmd.none )

        PageBack ->
            ( model, Navigation.back 1 )


transformParks : List Park -> Dict Int Park
transformParks parks =
    Dict.fromList (List.map (\park -> ( park.id, park )) parks)


campsiteListItem : Maybe Location -> Dict Int Park -> Campsite -> Html msg
campsiteListItem location parks campsite =
    a [ href "#", class "list-group-item" ]
        [ div [ class "campsite" ]
            [ div [ class "pull-right distance" ] [ text (bearingAndDistanceAsText location campsite.location) ]
            , div [ class "name" ] [ text campsite.name ]
            , div [ class "park" ] [ text (parkNameFromId campsite.parkId parks) ]
            ]
        ]


parkNameFromId : Int -> Dict Int Park -> String
parkNameFromId id parks =
    case Dict.get id parks of
        Just park ->
            park.name

        Nothing ->
            ""


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
            Http.get url Decoder.parksAndCampsites
    in
        Http.send NewData request
