module Model exposing (Model)

import Form.Model exposing (FieldSet)
import Time exposing (Posix, Zone)


type alias Model =
    { location : FieldSet
    , person : FieldSet
    , institution : FieldSet
    , ticket : FieldSet
    , now : Maybe Posix
    , timezone : Zone
    , documentInHtml : String
    }
