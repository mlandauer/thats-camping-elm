module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)


type alias Location =
    { latitude : Float, longitude : Float }


type alias Campsite =
    { name : String, location : Maybe Location }


type alias Model =
    List Campsite


type Msg
    = NewCampsite Campsite


campsites =
    [ Campsite "Acacia Flats" (Just (Location -33.6149 150.3553))
    , Campsite "Alexanders Hut" Nothing
    , Campsite "Apsley Falls" (Just (Location -31.0540415000018 151.762134053333))
    ]


main =
    beginnerProgram { model = campsites, view = view, update = update }


view : Model -> Html Msg
view model =
    ul [ class "campsite-list" ]
        (List.map campsiteListItem model)


update : Msg -> Model -> Model
update msg model =
    case msg of
        NewCampsite campsite ->
            campsite :: model


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
