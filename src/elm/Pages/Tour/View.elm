module Pages.Tour.View exposing (view)

import Html exposing (..)


view : String -> Html msg
view id =
    p [] [ text ("This is tour page " ++ id) ]
