module Pages.Campsite.View
    exposing
        ( view
        , haveLists
        , haveAndHaveNotSentence
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


haveLists { toilets, picnicTables } =
    concat (haveListsToilets toilets) (haveListsPicnicTables picnicTables)


concat :
    { have : List String, notHave : List String }
    -> { have : List String, notHave : List String }
    -> { have : List String, notHave : List String }
concat a b =
    { have = (a.have ++ b.have), notHave = (a.notHave ++ b.notHave) }


capitalise : String -> String
capitalise text =
    (String.toUpper (String.left 1 text)) ++ (String.dropLeft 1 text)


haveSentence : Maybe String -> Maybe String
haveSentence have =
    Maybe.map (\text -> "has " ++ text) have


notHaveSentence : Maybe String -> Maybe String
notHaveSentence notHave =
    Maybe.map (\text -> "no " ++ text) notHave


joinWords : Maybe String -> Maybe String -> Maybe String
joinWords a b =
    case a of
        Just a ->
            case b of
                Just b ->
                    Just (a ++ " but " ++ b)

                Nothing ->
                    Just a

        Nothing ->
            case b of
                Just b ->
                    Just b

                Nothing ->
                    Nothing


haveAndHaveNotSentence2 : Maybe String -> Maybe String -> Maybe String
haveAndHaveNotSentence2 have notHave =
    joinWords (haveSentence have) (notHaveSentence notHave)


haveAndHaveNotSentence : Maybe String -> Maybe String -> Maybe String
haveAndHaveNotSentence have notHave =
    Maybe.map (\text -> capitalise (text ++ ".")) (haveAndHaveNotSentence2 have notHave)
