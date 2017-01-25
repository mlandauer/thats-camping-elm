module Pages.Campsite.View
    exposing
        ( view
        , haveAndHaveNotSentence
        , listAsText
        , facilitiesText
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
    Maybe.withDefault ""
        (haveAndHaveNotSentence
            (listAsText (list True facilities))
            (listAsText (list False facilities))
        )


presentToilets : Toilets -> Bool
presentToilets toilets =
    case toilets of
        FlushToilets ->
            True

        NonFlushToilets ->
            True

        NoToilets ->
            False


presentPicnicTables : PicnicTables -> Bool
presentPicnicTables picnicTables =
    case picnicTables of
        PicnicTables ->
            True

        NoPicnicTables ->
            False


presentBarbecues : Barbecues -> Bool
presentBarbecues barbecues =
    case barbecues of
        WoodBarbecues ->
            True

        WoodSuppliedBarbecues ->
            True

        WoodBringYourOwnBarbecues ->
            True

        GasElectricBarbecues ->
            True

        NoBarbecues ->
            False


presentShowers : Showers -> Bool
presentShowers showers =
    case showers of
        HotShowers ->
            True

        ColdShowers ->
            True

        NoShowers ->
            False


presentDrinkingWater : DrinkingWater -> Bool
presentDrinkingWater drinkingWater =
    case drinkingWater of
        DrinkingWater ->
            True

        NoDrinkingWater ->
            False


descriptionToilets : Toilets -> String
descriptionToilets toilets =
    case toilets of
        FlushToilets ->
            "flush toilets"

        NonFlushToilets ->
            "non-flush toilets"

        NoToilets ->
            "toilets"


descriptionPicnicTables : PicnicTables -> String
descriptionPicnicTables picnicTables =
    "picnic tables"


descriptionBarbecues : Barbecues -> String
descriptionBarbecues barbecues =
    case barbecues of
        WoodBarbecues ->
            "wood BBQs"

        WoodSuppliedBarbecues ->
            "wood BBQs"

        WoodBringYourOwnBarbecues ->
            "wood BBQs"

        GasElectricBarbecues ->
            "gas/electric BBQs"

        NoBarbecues ->
            "BBQs"


descriptionShowers : Showers -> String
descriptionShowers showers =
    case showers of
        HotShowers ->
            "hot showers"

        ColdShowers ->
            "cold showers"

        NoShowers ->
            "showers"


descriptionDrinkingWater : DrinkingWater -> String
descriptionDrinkingWater drinkingWater =
    "drinking water"


transformToList p present description facility =
    -- p is which list to generate - either the "have" or "not have" List
    -- depending on whether it is True or False
    if (present facility) == p then
        [ description facility ]
    else
        []


handleUnknown2 : (a -> List String) -> Maybe a -> List String
handleUnknown2 f facility =
    Maybe.withDefault [] (Maybe.map f facility)


list p facilities =
    handleUnknown2
        (transformToList p presentDrinkingWater descriptionDrinkingWater)
        facilities.drinkingWater
        |> (++)
            (handleUnknown2
                (transformToList p presentShowers descriptionShowers)
                facilities.showers
            )
        |> (++)
            (handleUnknown2
                (transformToList p presentBarbecues descriptionBarbecues)
                facilities.barbecues
            )
        |> (++)
            (handleUnknown2
                (transformToList p presentPicnicTables descriptionPicnicTables)
                facilities.picnicTables
            )
        |> (++)
            (handleUnknown2
                (transformToList p presentToilets descriptionToilets)
                facilities.toilets
            )


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
