module Pages.Campsite.View
    exposing
        ( view
        , toiletsText
        , picnicTablesText
        , haveList
        , notHaveList
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import Pages.Campsite.Model exposing (..)
import App.ViewHelpers
import App.Update exposing (Msg)
import Libs.SimpleFormat.Format
import App.Model exposing (Facilities, Toilets(..), PicnicTables(..))


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
                    , Libs.SimpleFormat.Format.format model.campsite.description
                    , h2 [] [ text "Facilities" ]
                    , p [] [ text (facilitiesText model.campsite.facilities) ]
                    , h2 [] [ text "Access" ]
                      -- TODO: Add access description
                    , p [] [ text "Access description goes here" ]
                      -- TODO: Add directions button
                    ]
                ]
            ]
        ]


facilitiesText : Facilities -> String
facilitiesText facilities =
    -- TODO: Add facilities description
    "Facilities description goes here"


toiletsText : Toilets -> String
toiletsText toilets =
    case toilets of
        FlushToilets ->
            "Has flush toilets."

        NonFlushToilets ->
            "Has non-flush toilets."

        NoToilets ->
            "No toilets."

        UnknownToilets ->
            ""


picnicTablesText : PicnicTables -> String
picnicTablesText picnicTables =
    case picnicTables of
        PicnicTables ->
            "Has picnic tables."

        NoPicnicTables ->
            "No picnic tables."

        UnknownPicnicTables ->
            ""


haveListsToilets toilets =
    case toilets of
        FlushToilets ->
            { have = [ "flush toilets" ], notHave = [] }

        NonFlushToilets ->
            { have = [ "non-flush toilets" ], notHave = [] }

        NoToilets ->
            { have = [], notHave = [ "toilets" ] }

        UnknownToilets ->
            { have = [], notHave = [] }


haveListsPicnicTables picnicTables =
    case picnicTables of
        PicnicTables ->
            { have = [ "picnic tables" ], notHave = [] }

        NoPicnicTables ->
            { have = [], notHave = [ "picnic tables" ] }

        UnknownPicnicTables ->
            { have = [], notHave = [] }


haveList { toilets, picnicTables } =
    (.have (haveListsToilets toilets))
        ++ (.have (haveListsPicnicTables picnicTables))


notHaveList { toilets, picnicTables } =
    (.notHave (haveListsToilets toilets))
        ++ (.notHave (haveListsPicnicTables picnicTables))
