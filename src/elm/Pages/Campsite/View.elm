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
        , Toilets
        , PicnicTables
        , Tri(..)
        , Barbecues
        , BarbecuesCore(..)
        , Showers
        , DrinkingWater
        , Access
        , Caravans
        , Trailers
        , Cars
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


present : Tri t -> Maybe Bool
present facility =
    case facility of
        Yes _ ->
            Just True

        No ->
            Just False

        Unknown ->
            Nothing


descriptionToilets : Toilets -> String
descriptionToilets toilets =
    case toilets of
        Yes True ->
            "flush toilets"

        Yes False ->
            "non-flush toilets"

        No ->
            "toilets"

        Unknown ->
            "toilets"


descriptionPicnicTables : PicnicTables -> String
descriptionPicnicTables picnicTables =
    "picnic tables"


descriptionBarbecues : Barbecues -> String
descriptionBarbecues barbecues =
    case barbecues of
        Yes Wood ->
            "wood BBQs"

        Yes GasElectric ->
            "gas/electric BBQs"

        No ->
            "BBQs"

        Unknown ->
            "BBQs"


descriptionShowers : Showers -> String
descriptionShowers showers =
    case showers of
        Yes True ->
            "hot showers"

        Yes False ->
            "cold showers"

        No ->
            "showers"

        Unknown ->
            "showers"


descriptionDrinkingWater : DrinkingWater -> String
descriptionDrinkingWater drinkingWater =
    "drinking water"


descriptionCaravans : Caravans -> String
descriptionCaravans _ =
    "caravans"


descriptionTrailers : Trailers -> String
descriptionTrailers _ =
    "trailers"


descriptionCars : Cars -> String
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
        [ ( present facilities.toilets
          , descriptionToilets facilities.toilets
          )
        , ( present facilities.picnicTables
          , descriptionPicnicTables facilities.picnicTables
          )
        , ( present facilities.barbecues
          , descriptionBarbecues facilities.barbecues
          )
        , ( present facilities.showers
          , descriptionShowers facilities.showers
          )
        , ( present facilities.drinkingWater
          , descriptionDrinkingWater facilities.drinkingWater
          )
        ]


accessList : Maybe Bool -> Access -> List String
accessList p access =
    List.filterMap (filter p)
        [ ( present access.caravans
          , descriptionCaravans access.caravans
          )
        , ( present access.trailers
          , descriptionTrailers access.trailers
          )
        , ( present access.cars
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
