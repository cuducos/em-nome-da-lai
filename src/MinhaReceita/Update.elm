module MinhaReceita.Update exposing (loadCompany)

import Http
import MinhaReceita.Decoder exposing (companyDecoder)
import MinhaReceita.Model exposing (Company)


loadCompany : (Result Http.Error Company -> msg) -> String -> Cmd msg
loadCompany msg cnpj =
    Http.post
        { url = "https://minhareceita.org/"
        , body = Http.stringBody "application/x-www-form-urlencoded" ("cnpj=" ++ cnpj)
        , expect = Http.expectJson msg companyDecoder
        }
