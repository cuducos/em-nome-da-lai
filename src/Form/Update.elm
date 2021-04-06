module Form.Update exposing (disable, enable, field, get, isFormValid, isValid, set)

import Form.Model exposing (Field, FieldRow, FieldSet)
import Set exposing (Set)


get : String -> FieldSet -> Maybe Field
get key s =
    s.rows
        |> List.concat
        |> List.filter (\f -> f.label == key)
        |> List.head


isValid : String -> FieldSet -> Bool
isValid key s =
    s
        |> get key
        |> Maybe.map .valid
        |> Maybe.withDefault False


validate : Field -> Field
validate f =
    let
        notEmpty : String -> Bool
        notEmpty value =
            value
                |> String.trim
                |> String.isEmpty
                |> not

        validations : List Bool
        validations =
            f.validators
                |> (::) notEmpty
                |> List.map (\v -> v f.value)
    in
    { f | valid = not (List.member False validations) }


field : Field -> String -> Field
field f value =
    let
        mask : String -> String
        mask =
            Maybe.withDefault (\s -> s) f.mask

        newField : Field
        newField =
            validate { f | initialized = True, value = value }
    in
    if newField.valid then
        { newField | value = mask newField.value }

    else
        newField


rows : String -> String -> FieldRow -> FieldRow
rows key value r =
    List.map
        (\f ->
            if f.label == key then
                field f value

            else
                f
        )
        r


isFormValid : List FieldSet -> Bool
isFormValid fieldsets =
    fieldsets
        |> List.map isSetValid
        |> List.member False
        |> not


isSetValid : FieldSet -> Bool
isSetValid s =
    s.rows
        |> List.concat
        |> List.map .valid
        |> List.member False
        |> not


validateSet : FieldSet -> FieldSet
validateSet s =
    { s | valid = isSetValid s }


set : String -> String -> FieldSet -> FieldSet
set key value s =
    validateSet { s | rows = List.map (\r -> rows key value r) s.rows }


setDisabledto : Bool -> Set String -> FieldSet -> FieldSet
setDisabledto value keys fieldset =
    let
        disableFieldsInRow : FieldRow -> FieldRow
        disableFieldsInRow =
            List.map
                (\f ->
                    if Set.member f.label keys then
                        { f | disabled = value }

                    else
                        f
                )
    in
    { fieldset | rows = List.map disableFieldsInRow fieldset.rows }


disable : Set String -> FieldSet -> FieldSet
disable =
    setDisabledto True


enable : Set String -> FieldSet -> FieldSet
enable =
    setDisabledto False
