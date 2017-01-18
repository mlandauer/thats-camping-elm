module App.Model
    exposing
        ( Page(..)
        , Location
        , Campsite
        , Park
        )


type Page
    = Campsites
    | About


type alias Location =
    { latitude : Float, longitude : Float }


type alias Campsite =
    { name : String, location : Maybe Location, parkId : Int }


type alias Park =
    { id : Int, name : String }
