module MinhaReceita.Model exposing (Company)


type alias Company =
    { name : String
    , addressType : String
    , addressLine1 : String
    , addressNumber : String
    , addressLine2 : String
    , postalCode : String
    , state : String
    , city : String
    }
