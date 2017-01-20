module Libs.SimpleFormat.Format exposing (format)

import Html


format : String -> Html.Html msg
format text =
    Html.div []
        (List.map
            (\t -> (Html.p [] (paragraph t)))
            (String.split "\n\n" text)
        )


paragraph : String -> List (Html.Html msg)
paragraph text =
    List.intersperse (Html.br [] [])
        (List.map
            (\t -> Html.text t)
            (String.split "\n" text)
        )
