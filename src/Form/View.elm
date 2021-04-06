module Form.View exposing (button, field, set, value)

import Form.Model exposing (Field, FieldRow, FieldSet, Width(..))
import Form.Update exposing (get)
import Html exposing (Html)
import Html.Attributes exposing (class)
import Html.Events exposing (onInput)


value : String -> FieldSet -> String
value key s =
    s
        |> get key
        |> Maybe.map .value
        |> Maybe.withDefault ""


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


button : String -> String -> Bool -> List (Html.Attribute msg) -> Html msg
button text icon enabled attrs =
    let
        classesToAttr : List String -> Html.Attribute msg
        classesToAttr list =
            list
                |> String.join " "
                |> class

        initialButtonClasses : List String
        initialButtonClasses =
            [ "ui", "right", "labeled", "icon", "button" ]

        buttonClasses : List String
        buttonClasses =
            if enabled then
                initialButtonClasses

            else
                "disabled" :: initialButtonClasses

        buttonsAttrs : List (Html.Attribute msg)
        buttonsAttrs =
            classesToAttr buttonClasses :: attrs

        iconAttrs : List (Html.Attribute msg)
        iconAttrs =
            [ icon, "icon" ]
                |> String.join " "
                |> class
                |> List.singleton
    in
    Html.a
        buttonsAttrs
        [ Html.i iconAttrs []
        , Html.text text
        ]
