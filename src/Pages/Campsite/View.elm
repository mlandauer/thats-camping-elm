module Pages.Campsite.View
    exposing
        ( view
        , haveLists
        , haveAndHaveNotSentence
        , listAsText
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import Pages.Campsite.Model exposing (..)
import App.ViewHelpers
import App.Update exposing (Msg)
import Libs.SimpleFormat.Format
import App.Model
    exposing
        ( Facilities
        , Toilets(..)
        , PicnicTables(..)
        , Barbecues(..)
        , Showers(..)
        , DrinkingWater(..)
        )


view : Model -> Html Msg
view model =
    div [ class "campsite-detail-page" ]
        [ App.ViewHelpers.navBar model.campsite.shortName True False
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
    let
        l =
            (haveLists facilities)
    in
        Maybe.withDefault ""
            (haveAndHaveNotSentence
                (listAsText (.have l))
                (listAsText (.notHave l))
            )


type alias HaveNotHave =
    { have : List String, notHave : List String }


haveListsToilets : Maybe Toilets -> HaveNotHave
haveListsToilets toilets =
    case toilets of
        Just FlushToilets ->
            { have = [ "flush toilets" ], notHave = [] }

        Just NonFlushToilets ->
            { have = [ "non-flush toilets" ], notHave = [] }

        Just NoToilets ->
            { have = [], notHave = [ "toilets" ] }

        Nothing ->
            { have = [], notHave = [] }


haveListsPicnicTables : Maybe PicnicTables -> HaveNotHave
haveListsPicnicTables picnicTables =
    case picnicTables of
        Just PicnicTables ->
            { have = [ "picnic tables" ], notHave = [] }

        Just NoPicnicTables ->
            { have = [], notHave = [ "picnic tables" ] }

        Nothing ->
            { have = [], notHave = [] }


haveListsBarbecues : Maybe Barbecues -> HaveNotHave
haveListsBarbecues barbecues =
    case barbecues of
        Just WoodBarbecues ->
            { have = [ "wood BBQs" ], notHave = [] }

        Just WoodSuppliedBarbecues ->
            { have = [ "wood BBQs" ], notHave = [] }

        Just WoodBringYourOwnBarbecues ->
            { have = [ "wood BBQs" ], notHave = [] }

        Just GasElectricBarbecues ->
            { have = [ "gas/electric BBQs" ], notHave = [] }

        Just NoBarbecues ->
            { have = [], notHave = [ "BBQs" ] }

        Nothing ->
            { have = [], notHave = [] }


haveListsShowers : Maybe Showers -> HaveNotHave
haveListsShowers showers =
    case showers of
        Just HotShowers ->
            { have = [ "hot showers" ], notHave = [] }

        Just ColdShowers ->
            { have = [ "cold showers" ], notHave = [] }

        Just NoShowers ->
            { have = [], notHave = [ "showers" ] }

        Nothing ->
            { have = [], notHave = [] }


haveListsDrinkingWater : Maybe DrinkingWater -> HaveNotHave
haveListsDrinkingWater drinkingWater =
    case drinkingWater of
        Just DrinkingWater ->
            { have = [ "drinking water" ], notHave = [] }

        Just NoDrinkingWater ->
            { have = [], notHave = [ "drinking water" ] }

        Nothing ->
            { have = [], notHave = [] }


haveLists : Facilities -> HaveNotHave
haveLists facilities =
    haveListsToilets facilities.toilets
        |> concat (haveListsPicnicTables facilities.picnicTables)
        |> concat (haveListsBarbecues facilities.barbecues)
        |> concat (haveListsShowers facilities.showers)
        |> concat (haveListsDrinkingWater facilities.drinkingWater)


concat : HaveNotHave -> HaveNotHave -> HaveNotHave
concat a b =
    { have = (b.have ++ a.have), notHave = (b.notHave ++ a.notHave) }


capitalise : String -> String
capitalise text =
    (String.toUpper (String.left 1 text)) ++ (String.dropLeft 1 text)


joinWords : Maybe String -> String -> Maybe String -> Maybe String
joinWords a word b =
    case a of
        Just a ->
            case b of
                Just b ->
                    Just (a ++ " " ++ word ++ " " ++ b)

                Nothing ->
                    Just a

        Nothing ->
            case b of
                Just b ->
                    Just b

                Nothing ->
                    Nothing


haveAndHaveNotSentence : Maybe String -> Maybe String -> Maybe String
haveAndHaveNotSentence have notHave =
    Maybe.map (\text -> capitalise (text ++ "."))
        (joinWords
            (Maybe.map (\text -> "has " ++ text) have)
            "but"
            (Maybe.map (\text -> "no " ++ text) notHave)
        )


insertSeparatingWords : List String -> List String
insertSeparatingWords list =
    -- Hmmm.. Really not sure I've made this code even faintly intelligible
    List.reverse
        (case (List.reverse list) of
            [] ->
                []

            [ a0 ] ->
                [ a0 ]

            a0 :: l ->
                [ a0, " and " ] ++ (List.intersperse ", " l)
        )


listAsText : List String -> Maybe String
listAsText list =
    case list of
        [] ->
            Nothing

        list ->
            Just (List.foldr (++) "" (insertSeparatingWords list))
