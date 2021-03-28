module Model exposing (Institution, Location, Model, Person, Ticket)

import Time exposing (Posix, Zone)


type alias Location =
    { city : String
    , state : String
    }


type alias Person =
    { name : String
    , nationality : String
    , occupation : String
    , maritalStatus : String
    , personalId : String
    , federalRevenueId : String
    , address : String
    , city : String
    , state : String
    , postalCode : String
    }


type alias Institution =
    { name : String
    , federalRevenueId : String
    , address : String
    , city : String
    , state : String
    , postalCode : String
    }


type alias Ticket =
    { date : String
    , deadline : String
    , id : String
    }


type alias Model =
    { location : Location
    , person : Person
    , institution : Institution
    , ticket : Ticket
    , now : Posix
    , timezone : Zone
    }
