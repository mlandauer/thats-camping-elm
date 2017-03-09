module SimpleFormat exposing (format)

import Html
import Regex


format : String -> Html.Html msg
format text =
    Html.div []
        (List.map
            (\t -> (Html.p [] (paragraph t)))
            (String.split "\n\n" (normaliseReturn text))
        )


normaliseReturn : String -> String
normaliseReturn text =
    -- Turns CR and LF into LF
    Regex.replace Regex.All (Regex.regex "\x0D\n") (\_ -> "\n") text


paragraph : String -> List (Html.Html msg)
paragraph text =
    List.intersperse (Html.br [] [])
        (List.map
            (\t -> Html.text t)
            (String.split "\n" text)
        )
