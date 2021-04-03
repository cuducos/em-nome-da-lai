module Form.Mask exposing (cnpj, cpf, date, postalCode)


cpf : String -> String
cpf value =
    let
        cleaned : String
        cleaned =
            String.filter Char.isDigit value
    in
    String.concat
        [ String.slice 0 3 cleaned
        , "."
        , String.slice 3 6 cleaned
        , "."
        , String.slice 6 9 cleaned
        , "-"
        , String.slice 9 11 cleaned
        ]


cnpj : String -> String
cnpj value =
    let
        cleaned : String
        cleaned =
            String.filter Char.isDigit value
    in
    String.concat
        [ String.slice 0 2 cleaned
        , "."
        , String.slice 2 5 cleaned
        , "."
        , String.slice 5 8 cleaned
        , "/"
        , String.slice 8 12 cleaned
        , "-"
        , String.slice 12 14 cleaned
        ]


date : String -> String
date value =
    let
        cleaned : String
        cleaned =
            String.filter Char.isDigit value
    in
    String.join
        "/"
        [ String.slice 0 2 cleaned
        , String.slice 2 4 cleaned
        , String.slice 4 8 cleaned
        ]


postalCode : String -> String
postalCode value =
    let
        cleaned : String
        cleaned =
            String.filter Char.isDigit value
    in
    String.concat
        [ String.slice 0 5 cleaned
        , "-"
        , String.slice 5 8 cleaned
        ]
