module Main exposing (main)

import Browser
import Form.Mask exposing (cpf)
import Form.Model exposing (FieldSet, Width(..), newField)
import Form.Validators
import Html exposing (Html, br, text)
import Html.Attributes exposing (placeholder, style, value)
import Html.Events exposing (onInput)
import Model exposing (Model)
import Task
import Time
import Update exposing (Msg(..), subscriptions, update)
import View exposing (view)


location : FieldSet
location =
    FieldSet
        "Localização do tribunal"
        False
        [ [ newField "Cidade" Fourteen [] Nothing
          , newField "UF" Two [ Form.Validators.state ] (Just String.toUpper)
          ]
        ]


person : FieldSet
person =
    FieldSet
        "Informações pessoais"
        False
        [ [ newField "Nome completo" Sixteen [] Nothing ]
        , [ newField "Nacionalidade" Six [] Nothing
          , newField "Ocupação" Six [] Nothing
          , newField "Estado civil" Four [] Nothing
          ]
        , [ newField "RG" Eight [] Nothing
          , newField "CPF" Eight [ Form.Validators.cpf ] (Just Form.Mask.cpf)
          ]
        , [ newField "Endereço" Sixteen [] Nothing ]
        , [ newField "Cidade" Ten [] Nothing
          , newField "UF" Two [ Form.Validators.state ] (Just String.toUpper)
          , newField "CEP" Four [ Form.Validators.postalCode ] (Just Form.Mask.postalCode)
          ]
        ]


institution : FieldSet
institution =
    FieldSet
        "Informações do órgão público"
        False
        [ [ newField "CNPJ" Sixteen [ Form.Validators.cnpj ] (Just Form.Mask.cnpj) ]
        , [ newField "Razão social" Sixteen [] Nothing ]
        , [ newField "Endereço" Sixteen [] Nothing ]
        , [ newField "Cidade" Ten [] Nothing
          , newField "UF" Two [ Form.Validators.state ] (Just String.toUpper)
          , newField "CEP" Four [ Form.Validators.postalCode ] (Just Form.Mask.postalCode)
          ]
        ]


ticket : FieldSet
ticket =
    FieldSet
        "Informações do requerimento pela LAI"
        False
        [ [ newField "Número do protocolo" Eight [] Nothing
          , newField "Data do protocolo" Four [ Form.Validators.date ] (Just Form.Mask.date)
          , newField "Data para resposta" Four [ Form.Validators.date ] (Just Form.Mask.date)
          ]
        ]


init : () -> ( Model, Cmd Msg )
init _ =
    ( { form =
            { location = location
            , person = person
            , institution = institution
            , ticket = ticket
            , valid = False
            }
      , now = Nothing
      , timezone = Time.utc
      , documentInHtml = ""
      }
    , Task.perform UpdateTimezone Time.here
    )


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , subscriptions = subscriptions
        , view = view
        , update = update
        }
