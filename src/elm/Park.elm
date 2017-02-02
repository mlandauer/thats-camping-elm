module Park exposing (Park)


type alias Park =
    { id : String
    , shortName : String
    , longName : String
    , description : String
    , campsiteIds : List String
    }
