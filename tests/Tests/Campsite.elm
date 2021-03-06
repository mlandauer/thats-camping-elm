module Tests.Campsite exposing (all)

import Test exposing (..)
import Expect
import Campsite exposing (..)


all : Test
all =
    describe "Campsite"
        [ describe "shortenName"
            [ describe "campsite names"
                [ testCase "A short name" "A short name"
                , testCase "Behrs Flat" "Behrs Flat campground"
                , testCase "Heartbreak Hill" "Heartbreak Hill camping area"
                , testCase "Homestead Creek" "Homestead Creek camping ground"
                , testCase "Mann River" "Mann River picnic and camping area"
                , testCase "Jounama Creek campground 1" "Jounama Creek campground 1"
                , testCase "Kosciuszko" "Kosciuszko camping grounds"
                , testCase "Lake Arragan and Red Cliff" "Lake Arragan and Red Cliff campgrounds"
                , testCase "Lane Cove River" "Lane Cove River tourist park"
                , testCase "O'Hares" "O'Hares rest area"
                , testCase "Berlang" "Berlang Camping Area"
                , testCase "Pebbly Beach" "Pebbly Beach campground and picnic area"
                , testCase "Blatherarm" "Blatherarm camping and picnic area"
                , testCase "Blue Gums" "Blue Gums large group campground"
                , testCase "Euroka (trailer area)" "Euroka campground - Appletree Flat campervan and camper trailer area"
                ]
            , describe "park names"
                [ testCase "Blue Mountains NP" "Blue Mountains National Park"
                , testCase "Parr SCA" "Parr State Conservation Area"
                , testCase "Karuah NR" "Karuah Nature Reserve"
                , testCase "Hill End" "Hill End Historic Site"
                , testCase "Wombeyan KCR" "Wombeyan Karst Conservation Reserve"
                ]
            ]
        ]


testCase expected input =
    test input <|
        \() -> Expect.equal expected (shortenName input)
