module Model exposing (Form, Model)

import Form.Model exposing (FieldSet)
import Time exposing (Posix, Zone)


type alias Form =
    { location : FieldSet
    , person : FieldSet
    , institution : FieldSet
    , ticket : FieldSet
    , valid : Bool
    }


type alias Model =
    { form : Form
    , now : Maybe Posix
    , timezone : Zone
    , documentInHtml : String
    }
