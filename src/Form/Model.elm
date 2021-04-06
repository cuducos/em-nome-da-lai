module Form.Model exposing (Field, FieldRow, FieldSet, Width(..), newField)


type Width
    = One
    | Two
    | Three
    | Four
    | Five
    | Six
    | Seven
    | Eight
    | Nine
    | Ten
    | Eleven
    | Twelve
    | Thirteen
    | Fourteen
    | Fifteen
    | Sixteen


type alias Field =
    { value : String
    , label : String
    , width : Width
    , validators : List (String -> Bool)
    , mask : Maybe (String -> String)
    , valid : Bool
    , initialized : Bool
    , disabled : Bool
    }


type alias FieldRow =
    List Field


type alias FieldSet =
    { title : String
    , valid : Bool
    , rows : List FieldRow
    }


newField : String -> Width -> List (String -> Bool) -> Maybe (String -> String) -> Field
newField label width validators mask =
    Field "" label width validators mask False False False
