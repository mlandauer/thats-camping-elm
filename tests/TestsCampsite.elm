module TestsCampsite exposing (..)

import Test exposing (..)
import Expect
import Campsite exposing (..)


all : Test
all =
    describe "Campsite"
        [ describe "shortenCampsiteName"
            [ testCampsite "A short name" "A short name"
            , testCampsite "Behrs Flat" "Behrs Flat campground"
            , testCampsite "Heartbreak Hill" "Heartbreak Hill camping area"
            , testCampsite "Homestead Creek" "Homestead Creek camping ground"
            , testCampsite "Mann River" "Mann River picnic and camping area"
            , testCampsite "Jounama Creek campground 1" "Jounama Creek campground 1"
            , testCampsite "Kosciuszko" "Kosciuszko camping grounds"
            , testCampsite "Lake Arragan and Red Cliff" "Lake Arragan and Red Cliff campgrounds"
            , testCampsite "Lane Cove River" "Lane Cove River tourist park"
            , testCampsite "O'Hares" "O'Hares rest area"
            , testCampsite "Berlang" "Berlang Camping Area"
            , testCampsite "Pebbly Beach" "Pebbly Beach campground and picnic area"
            , testCampsite "Blatherarm" "Blatherarm camping and picnic area"
            , testCampsite "Blue Gums" "Blue Gums large group campground"
            , testCampsite "Euroka (trailer area)" "Euroka campground - Appletree Flat campervan and camper trailer area"
            ]
        , describe "shortenParkName"
            [ testPark "Blue Mountains NP" "Blue Mountains National Park"
            , testPark "Parr SCA" "Parr State Conservation Area"
            , testPark "Karuah NR" "Karuah Nature Reserve"
            , testPark "Hill End" "Hill End Historic Site"
            , testPark "Wombeyan KCR" "Wombeyan Karst Conservation Reserve"
            ]
        ]


testCampsite expected input =
    test input <|
        \() -> Expect.equal expected (shortenCampsiteName input)


testPark expected input =
    test input <|
        \() -> Expect.equal expected (shortenParkName input)
