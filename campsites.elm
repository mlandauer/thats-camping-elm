module Main exposing (..)

import Html exposing (li, text, ul, Html)
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
    []
        |> update (NewCampsite (Campsite "Apsley Falls" (Just (Location -31.0540415000018 151.762134053333))))
        |> update (NewCampsite (Campsite "Alexanders Hut" Nothing))
        |> update (NewCampsite (Campsite "Acacia Flats" (Just (Location -33.6149 150.3553))))


main =
    view campsites


view : Model -> Html Msg
view campsites =
    ul [ class "campsite-list" ]
        (List.map campsiteListItem campsites)


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
            ""
