module MinhaReceita.Decoder exposing (companyDecoder)

import Json.Decode exposing (Decoder, field, string)
import MinhaReceita.Model exposing (Company)


companyDecoder : Decoder Company
companyDecoder =
    Json.Decode.map8
        Company
        (field "razao_social" string)
        (field "descricao_tipo_logradouro" string)
        (field "logradouro" string)
        (field "numero" string)
        (field "complemento" string)
        (field "cep" string)
        (field "uf" string)
        (field "municipio" string)
