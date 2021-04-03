module Form.Update exposing (field, isFormValid, set)

import Form.Model exposing (Field, FieldRow, FieldSet)


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
