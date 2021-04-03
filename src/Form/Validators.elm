module Form.Validators exposing (cnpj, cpf, date, postalCode, state)

import Form.Model exposing (Field)
import Set exposing (Set)


states : Set String
states =
    Set.fromList
        [ "AC"
        , "AL"
        , "AP"
        , "AM"
        , "BA"
        , "CE"
        , "ES"
        , "GO"
        , "MA"
        , "MT"
        , "MS"
        , "MG"
        , "PA"
        , "PB"
        , "PR"
        , "PE"
        , "PI"
        , "RJ"
        , "RN"
        , "RS"
        , "RO"
        , "RR"
        , "SC"
        , "SP"
        , "SE"
        , "TO"
        , "DF"
        ]


state : String -> Bool
state value =
    Set.member value states


cpf : String -> Bool
cpf value =
    value
        |> String.filter Char.isDigit
        |> String.length
        |> (==) 11


cnpj : String -> Bool
cnpj value =
    value
        |> String.filter Char.isDigit
        |> String.length
        |> (==) 14


date : String -> Bool
date value =
    let
        digits : String
        digits =
            String.filter Char.isDigit value

        day : Int
        day =
            digits
                |> String.slice 0 2
                |> String.toInt
                |> Maybe.withDefault 0

        month : Int
        month =
            digits
                |> String.slice 2 4
                |> String.toInt
                |> Maybe.withDefault 0

        year : Int
        year =
            digits
                |> String.slice 4 8
                |> String.toInt
                |> Maybe.withDefault 0
    in
    year >= 1900 && year <= 2100 && month >= 1 && month <= 12 && day >= 1 && day <= 31


postalCode : String -> Bool
postalCode value =
    value
        |> String.filter Char.isDigit
        |> String.length
        |> (==) 8
