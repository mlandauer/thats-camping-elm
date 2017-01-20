module Pages.Campsite.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Pages.Campsite.Model exposing (..)
import App.ViewHelpers
import App.Update exposing (Msg)


view : Model -> Html Msg
view model =
    div [ class "campsite-detail-page" ]
        [ App.ViewHelpers.navBar model.campsite.shortName True True
        , div [ class "content" ]
            [ div [ class "container" ]
                [ div [ class "campsite-detail" ]
                    [ -- TODO: Add star
                      h2 []
                        [ text model.campsite.longName ]
                      -- TODO: Add link to park
                    , p []
                        (case model.park of
                            Just park ->
                                [ text ("in " ++ park.longName ++ ".") ]

                            Nothing ->
                                []
                        )
                    , div []
                        -- TODO: Add the actual description
                        [ p [] [ text "Main description goes here" ] ]
                    , h2 [] [ text "Facilities" ]
                      -- TODO: Add facilities description
                    , p [] [ text "Facilities description goes here" ]
                    , h2 [] [ text "Access" ]
                      -- TODO: Add access description
                    , p [] [ text "Access description goes here" ]
                      -- TODO: Add directions button
                    ]
                ]
            ]
        ]
