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


haveListsToilets2 : Toilets -> HaveNotHave
haveListsToilets2 toilets =
    case toilets of
        FlushToilets ->
            { have = [ "flush toilets" ], notHave = [] }

        NonFlushToilets ->
            { have = [ "non-flush toilets" ], notHave = [] }

        NoToilets ->
            { have = [], notHave = [ "toilets" ] }


haveListsPicnicTables2 : PicnicTables -> HaveNotHave
haveListsPicnicTables2 picnicTables =
    case picnicTables of
        PicnicTables ->
            { have = [ "picnic tables" ], notHave = [] }

        NoPicnicTables ->
            { have = [], notHave = [ "picnic tables" ] }


haveListsBarbecues2 : Barbecues -> HaveNotHave
haveListsBarbecues2 barbecues =
    case barbecues of
        WoodBarbecues ->
            { have = [ "wood BBQs" ], notHave = [] }

        WoodSuppliedBarbecues ->
            { have = [ "wood BBQs" ], notHave = [] }

        WoodBringYourOwnBarbecues ->
            { have = [ "wood BBQs" ], notHave = [] }

        GasElectricBarbecues ->
            { have = [ "gas/electric BBQs" ], notHave = [] }

        NoBarbecues ->
            { have = [], notHave = [ "BBQs" ] }


haveListsShowers2 : Showers -> HaveNotHave
haveListsShowers2 showers =
    case showers of
        HotShowers ->
            { have = [ "hot showers" ], notHave = [] }

        ColdShowers ->
            { have = [ "cold showers" ], notHave = [] }

        NoShowers ->
            { have = [], notHave = [ "showers" ] }


haveListsDrinkingWater2 : DrinkingWater -> HaveNotHave
haveListsDrinkingWater2 drinkingWater =
    case drinkingWater of
        DrinkingWater ->
            { have = [ "drinking water" ], notHave = [] }

        NoDrinkingWater ->
            { have = [], notHave = [ "drinking water" ] }


handleUnknown : (a -> HaveNotHave) -> Maybe a -> HaveNotHave
handleUnknown f facility =
    case facility of
        Just facility ->
            f facility

        Nothing ->
            { have = [], notHave = [] }


haveListsToilets : Maybe Toilets -> HaveNotHave
haveListsToilets toilets =
    handleUnknown haveListsToilets2 toilets


haveListsPicnicTables : Maybe PicnicTables -> HaveNotHave
haveListsPicnicTables picnicTables =
    handleUnknown haveListsPicnicTables2 picnicTables


haveListsBarbecues : Maybe Barbecues -> HaveNotHave
haveListsBarbecues barbecues =
    handleUnknown haveListsBarbecues2 barbecues


haveListsShowers : Maybe Showers -> HaveNotHave
haveListsShowers showers =
    handleUnknown haveListsShowers2 showers


haveListsDrinkingWater : Maybe DrinkingWater -> HaveNotHave
haveListsDrinkingWater drinkingWater =
    handleUnknown haveListsDrinkingWater2 drinkingWater


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
