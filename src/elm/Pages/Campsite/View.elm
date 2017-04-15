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


presentToilets : Toilets -> Bool
presentToilets toilets =
    case toilets of
        FlushToilets ->
            True

        NonFlushToilets ->
            True

        NoToilets ->
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


presentPicnicTables : PicnicTables -> Bool
presentPicnicTables picnicTables =
    case picnicTables of
        PicnicTables ->
            True

        NoPicnicTables ->
            False


descriptionPicnicTables : PicnicTables -> String
descriptionPicnicTables picnicTables =
    "picnic tables"


presentBarbecuesCore : BarbecuesCore -> Bool
presentBarbecuesCore barbecues =
    case barbecues of
        WoodBarbecuesCore ->
            True

        WoodSuppliedBarbecuesCore ->
            True

        WoodBringYourOwnBarbecuesCore ->
            True

        GasElectricBarbecuesCore ->
            True

        NoBarbecuesCore ->
            False


descriptionBarbecuesCore : BarbecuesCore -> String
descriptionBarbecuesCore barbecues =
    case barbecues of
        WoodBarbecuesCore ->
            "wood BBQs"

        WoodSuppliedBarbecuesCore ->
            "wood BBQs"

        WoodBringYourOwnBarbecuesCore ->
            "wood BBQs"

        GasElectricBarbecuesCore ->
            "gas/electric BBQs"

        NoBarbecuesCore ->
            "BBQs"


presentShowers : Showers -> Bool
presentShowers showers =
    case showers of
        HotShowers ->
            True

        ColdShowers ->
            True

        NoShowers ->
            False


descriptionShowers : Showers -> String
descriptionShowers showers =
    case showers of
        HotShowers ->
            "hot showers"

        ColdShowers ->
            "cold showers"

        NoShowers ->
            "showers"


presentDrinkingWater : DrinkingWater -> Bool
presentDrinkingWater drinkingWater =
    case drinkingWater of
        DrinkingWater ->
            True

        NoDrinkingWater ->
            False


descriptionDrinkingWater : DrinkingWater -> String
descriptionDrinkingWater drinkingWater =
    "drinking water"


presentCaravans : Caravans -> Bool
presentCaravans caravans =
    case caravans of
        Caravans ->
            True

        NoCaravans ->
            False


descriptionCaravans : Caravans -> String
descriptionCaravans _ =
    "caravans"


presentTrailers : Trailers -> Bool
presentTrailers trailers =
    case trailers of
        Trailers ->
            True

        NoTrailers ->
            False


descriptionTrailers : Trailers -> String
descriptionTrailers _ =
    "trailers"


presentCars : Cars -> Bool
presentCars cars =
    case cars of
        Cars ->
            True

        NoCars ->
            False


descriptionCars : Cars -> String
descriptionCars _ =
    "car camping"



---------


listItem : Bool -> (f -> Bool) -> (f -> String) -> Maybe f -> Maybe String
listItem p present description facility =
    case facility of
        Just facility ->
            if (present facility) == p then
                Just (description facility)
            else
                Nothing

        Nothing ->
            Nothing


facilitiesList : Bool -> Facilities -> List String
facilitiesList p facilities =
    values
        [ (listItem p presentToilets descriptionToilets facilities.toilets)
        , (listItem p presentPicnicTables descriptionPicnicTables facilities.picnicTables)
        , (listItem p presentBarbecuesCore descriptionBarbecuesCore facilities.barbecues)
        , (listItem p presentShowers descriptionShowers facilities.showers)
        , (listItem p presentDrinkingWater descriptionDrinkingWater facilities.drinkingWater)
        ]


accessList : Bool -> Access -> List String
accessList p access =
    values
        [ (listItem p presentCaravans descriptionCaravans access.caravans)
        , (listItem p presentTrailers descriptionTrailers access.trailers)
        , (listItem p presentCars descriptionCars access.cars)
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
