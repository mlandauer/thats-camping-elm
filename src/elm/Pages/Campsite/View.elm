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
        , ToiletsCore(..)
        , PicnicTables(..)
        , Tri(..)
        , Barbecues
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
            (listAsText (facilitiesList (Just True) facilities))
            "but"
            "no"
            (listAsText (facilitiesList (Just False) facilities))
        )


accessText : Access -> String
accessText access =
    Maybe.withDefault ""
        (haveAndHaveNotSentence
            "for"
            (listAsText (accessList (Just True) access))
            "but"
            "not for"
            (listAsText (accessList (Just False) access))
        )



------------


presentToilets : Maybe ToiletsCore -> Maybe Bool
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


descriptionToilets : Maybe ToiletsCore -> String
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


presentBarbecues : Tri BarbecuesCore -> Maybe Bool
presentBarbecues barbecues =
    case barbecues of
        Yes _ ->
            Just True

        No ->
            Just False

        Unknown ->
            Nothing


descriptionBarbecues : Barbecues -> String
descriptionBarbecues barbecues =
    case barbecues of
        Yes WoodBarbecues ->
            "wood BBQs"

        Yes WoodSuppliedBarbecues ->
            "wood BBQs"

        Yes WoodBringYourOwnBarbecues ->
            "wood BBQs"

        Yes GasElectricBarbecues ->
            "gas/electric BBQs"

        No ->
            "BBQs"

        Unknown ->
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


filter : Maybe Bool -> ( Maybe Bool, String ) -> Maybe String
filter p i =
    if (Tuple.first i) == p then
        Just (Tuple.second i)
    else
        Nothing


facilitiesList : Maybe Bool -> Facilities -> List String
facilitiesList p facilities =
    List.filterMap (filter p)
        [ ( presentToilets facilities.toilets
          , descriptionToilets facilities.toilets
          )
        , ( presentPicnicTables facilities.picnicTables
          , descriptionPicnicTables facilities.picnicTables
          )
        , ( presentBarbecues facilities.barbecues
          , descriptionBarbecues facilities.barbecues
          )
        , ( presentShowers facilities.showers
          , descriptionShowers facilities.showers
          )
        , ( presentDrinkingWater facilities.drinkingWater
          , descriptionDrinkingWater facilities.drinkingWater
          )
        ]


accessList : Maybe Bool -> Access -> List String
accessList p access =
    List.filterMap (filter p)
        [ ( presentCaravans access.caravans
          , descriptionCaravans access.caravans
          )
        , ( presentTrailers access.trailers
          , descriptionTrailers access.trailers
          )
        , ( presentCars access.cars
          , descriptionCars access.cars
          )
        ]


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
