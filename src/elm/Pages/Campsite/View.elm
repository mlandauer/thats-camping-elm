module Pages.Campsite.View
    exposing
        ( view
        , haveAndHaveNotSentence
        , listAsText
        , facilitiesText
        , accessText
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import Pages.Campsite.Model exposing (..)
import App.ViewHelpers
import App.Update exposing (Msg(..))
import SimpleFormat
import Location exposing (Location)
import Campsite
    exposing
        ( Facilities
        , Toilets(..)
        , PicnicTables(..)
        , BarbecuesCore(..)
        , Showers(..)
        , DrinkingWater(..)
        , Access
        , Caravans(..)
        , Trailers(..)
        , Cars(..)
        )


view : Model -> Html Msg
view model =
    div [ class "campsite-detail-page" ]
        [ div [ class "content" ]
            [ div [ class "container" ]
                [ div [ class "campsite-detail" ]
                    [ App.ViewHelpers.star model.starred (Just (ToggleStarCampsite model.campsite.id))
                    , h2 [] [ text model.campsite.name.long ]
                    , p []
                        [ text ("in " ++ model.campsite.parkName.long ++ ".") ]
                    , SimpleFormat.format model.campsite.description
                    , h2 [] [ text "Facilities" ]
                    , p [] [ text (facilitiesText model.campsite.facilities) ]
                    , h2 [] [ text "Access" ]
                    , p [] [ text (accessText model.campsite.access) ]
                    , case mapUrl model.campsite.location model.online of
                        Just url ->
                            a
                                [ href url
                                , class "directions btn btn-default"
                                ]
                                [ text "Directions to campsite" ]

                        Nothing ->
                            span
                                [ class "directions btn btn-default disabled"
                                ]
                                [ text "Directions to campsite" ]
                    ]
                ]
            ]
        ]


mapUrl : Maybe Location -> Bool -> Maybe String
mapUrl location online =
    -- Returns Nothing if directions can't be used (location isn't available or offline)
    if online then
        Maybe.map
            (\l ->
                "https://maps.google.com/maps?daddr="
                    ++ (toString l.latitude)
                    ++ ","
                    ++ (toString l.longitude)
            )
            location
    else
        Nothing


facilitiesText : Facilities -> String
facilitiesText facilities =
    Maybe.withDefault ""
        (haveAndHaveNotSentence
            "has"
            (listAsText (facilitiesList True facilities))
            "but"
            "no"
            (listAsText (facilitiesList False facilities))
        )


accessText : Access -> String
accessText access =
    Maybe.withDefault ""
        (haveAndHaveNotSentence
            "for"
            (listAsText (accessList True access))
            "but"
            "not for"
            (listAsText (accessList False access))
        )



------------


presentToilets : Maybe Toilets -> Maybe Bool
presentToilets toilets =
    case toilets of
        Just FlushToilets ->
            Just True

        Just NonFlushToilets ->
            Just True

        Just NoToilets ->
            Just False

        Nothing ->
            Nothing


descriptionToilets : Maybe Toilets -> String
descriptionToilets toilets =
    case toilets of
        Just FlushToilets ->
            "flush toilets"

        Just NonFlushToilets ->
            "non-flush toilets"

        Just NoToilets ->
            "toilets"

        Nothing ->
            "toilets"


presentPicnicTables : Maybe PicnicTables -> Maybe Bool
presentPicnicTables picnicTables =
    case picnicTables of
        Just PicnicTables ->
            Just True

        Just NoPicnicTables ->
            Just False

        Nothing ->
            Nothing


descriptionPicnicTables : Maybe PicnicTables -> String
descriptionPicnicTables picnicTables =
    "picnic tables"


presentBarbecuesCore : Maybe BarbecuesCore -> Maybe Bool
presentBarbecuesCore barbecues =
    case barbecues of
        Just WoodBarbecuesCore ->
            Just True

        Just WoodSuppliedBarbecuesCore ->
            Just True

        Just WoodBringYourOwnBarbecuesCore ->
            Just True

        Just GasElectricBarbecuesCore ->
            Just True

        Just NoBarbecuesCore ->
            Just False

        Nothing ->
            Nothing


descriptionBarbecuesCore : Maybe BarbecuesCore -> String
descriptionBarbecuesCore barbecues =
    case barbecues of
        Just WoodBarbecuesCore ->
            "wood BBQs"

        Just WoodSuppliedBarbecuesCore ->
            "wood BBQs"

        Just WoodBringYourOwnBarbecuesCore ->
            "wood BBQs"

        Just GasElectricBarbecuesCore ->
            "gas/electric BBQs"

        Just NoBarbecuesCore ->
            "BBQs"

        Nothing ->
            "BBQs"


presentShowers : Maybe Showers -> Maybe Bool
presentShowers showers =
    case showers of
        Just HotShowers ->
            Just True

        Just ColdShowers ->
            Just True

        Just NoShowers ->
            Just False

        Nothing ->
            Nothing


descriptionShowers : Maybe Showers -> String
descriptionShowers showers =
    case showers of
        Just HotShowers ->
            "hot showers"

        Just ColdShowers ->
            "cold showers"

        Just NoShowers ->
            "showers"

        Nothing ->
            "showers"


presentDrinkingWater : Maybe DrinkingWater -> Maybe Bool
presentDrinkingWater drinkingWater =
    case drinkingWater of
        Just DrinkingWater ->
            Just True

        Just NoDrinkingWater ->
            Just False

        Nothing ->
            Nothing


descriptionDrinkingWater : Maybe DrinkingWater -> String
descriptionDrinkingWater drinkingWater =
    "drinking water"


presentCaravans : Maybe Caravans -> Maybe Bool
presentCaravans caravans =
    case caravans of
        Just Caravans ->
            Just True

        Just NoCaravans ->
            Just False

        Nothing ->
            Nothing


descriptionCaravans : Maybe Caravans -> String
descriptionCaravans _ =
    "caravans"


presentTrailers : Maybe Trailers -> Maybe Bool
presentTrailers trailers =
    case trailers of
        Just Trailers ->
            Just True

        Just NoTrailers ->
            Just False

        Nothing ->
            Nothing


descriptionTrailers : Maybe Trailers -> String
descriptionTrailers _ =
    "trailers"


presentCars : Maybe Cars -> Maybe Bool
presentCars cars =
    case cars of
        Just Cars ->
            Just True

        Just NoCars ->
            Just False

        Nothing ->
            Nothing


descriptionCars : Maybe Cars -> String
descriptionCars _ =
    "car camping"



---------


listItem : Maybe Bool -> (Maybe f -> Maybe Bool) -> (Maybe f -> String) -> Maybe f -> Maybe String
listItem p present description facility =
    if (present facility) == p then
        Just (description facility)
    else
        Nothing


facilitiesList : Bool -> Facilities -> List String
facilitiesList p facilities =
    values
        [ (listItem (Just p) presentToilets descriptionToilets facilities.toilets)
        , (listItem (Just p) presentPicnicTables descriptionPicnicTables facilities.picnicTables)
        , (listItem (Just p) presentBarbecuesCore descriptionBarbecuesCore facilities.barbecues)
        , (listItem (Just p) presentShowers descriptionShowers facilities.showers)
        , (listItem (Just p) presentDrinkingWater descriptionDrinkingWater facilities.drinkingWater)
        ]


accessList : Bool -> Access -> List String
accessList p access =
    values
        [ (listItem (Just p) presentCaravans descriptionCaravans access.caravans)
        , (listItem (Just p) presentTrailers descriptionTrailers access.trailers)
        , (listItem (Just p) presentCars descriptionCars access.cars)
        ]


values : List (Maybe a) -> List a
values l =
    -- Implementing something like Maybe.Extra.values
    -- Recursive so probably not efficient
    -- TODO: Is there a more "standard" way to achieve the same end?
    case l of
        [] ->
            []

        first :: rest ->
            case first of
                Just value ->
                    value :: (values rest)

                Nothing ->
                    values rest


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


haveAndHaveNotSentence : String -> Maybe String -> String -> String -> Maybe String -> Maybe String
haveAndHaveNotSentence haveWord have butWord notHaveWord notHave =
    Maybe.map (\text -> capitalise (text ++ "."))
        (joinWords
            (Maybe.map (\text -> haveWord ++ " " ++ text) have)
            butWord
            (Maybe.map (\text -> notHaveWord ++ " " ++ text) notHave)
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
