module Pages.Admin.Model exposing (Model, initModel)


type alias Model =
    { text : Maybe String
    }


initModel : Model
initModel =
    { text = Nothing }
