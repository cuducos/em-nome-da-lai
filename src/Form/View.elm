module Form.View exposing (field, get, isSetValid, isValid, set, value)

import Form.Model exposing (Field, FieldRow, FieldSet, Width(..))
import Html exposing (Html)
import Html.Attributes exposing (class)
import Html.Events exposing (onInput)


isSetValid : FieldSet -> Bool
isSetValid s =
    s.rows
        |> List.concat
        |> List.map .valid
        |> List.member False
        |> not


get : String -> FieldSet -> Maybe Field
get key s =
    s.rows
        |> List.concat
        |> List.filter (\f -> f.label == key)
        |> List.head


value : String -> FieldSet -> String
value key s =
    s
        |> get key
        |> Maybe.map .value
        |> Maybe.withDefault ""


isValid : String -> FieldSet -> Bool
isValid key s =
    s
        |> get key
        |> Maybe.map .valid
        |> Maybe.withDefault False


widthToString : Width -> List String
widthToString width =
    case width of
        One ->
            [ "one", "wide" ]

        Two ->
            [ "two", "wide" ]

        Three ->
            [ "three", "wide" ]

        Four ->
            [ "four", "wide" ]

        Five ->
            [ "five", "wide" ]

        Six ->
            [ "six", "wide" ]

        Seven ->
            [ "seven", "wide" ]

        Eight ->
            [ "eight", "wide" ]

        Nine ->
            [ "nine", "wide" ]

        Ten ->
            [ "ten", "wide" ]

        Eleven ->
            [ "eleven", "wide" ]

        Twelve ->
            [ "twelve", "wide" ]

        Thirteen ->
            [ "thirteen", "wide" ]

        Fourteen ->
            [ "fourteen", "wide" ]

        Fifteen ->
            [ "fifteen", "wide" ]

        Sixteen ->
            [ "sixteen", "wide" ]


fieldClass : Field -> Html.Attribute msg
fieldClass f =
    let
        error : List String
        error =
            if not f.initialized || f.valid then
                []

            else
                [ "error" ]
    in
    [ widthToString f.width, [ "field" ], error ]
        |> List.concat
        |> String.join " "
        |> class


field : (String -> String -> msg) -> Field -> Html msg
field msg f =
    Html.div
        [ fieldClass f ]
        [ Html.label [] [ Html.text f.label ]
        , Html.input [ Html.Attributes.value f.value, onInput (msg f.label) ] []
        ]


row : (String -> String -> msg) -> FieldRow -> Html msg
row msg r =
    let
        fields : List (Html msg)
        fields =
            List.map (field msg) r
    in
    Html.div [ class "fields" ] fields


set : FieldSet -> (String -> String -> msg) -> List (Html msg)
set s msg =
    Html.h4 [ class "ui dividing header" ] [ Html.text s.title ] :: List.map (row msg) s.rows