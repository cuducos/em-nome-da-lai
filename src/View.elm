module View exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (class, download, href, id, src, style, type_, value)
import Html.Events exposing (onClick, onInput)
import Model exposing (Institution, Location, Model, Person, Ticket)
import Time exposing (Month(..), Posix)
import Update exposing (Msg(..))


viewFormLocation : Location -> List (Html Msg)
viewFormLocation location =
    [ Html.h4
        [ class "ui dividing header" ]
        [ Html.text "Localização do tribunal" ]
    , Html.div
        [ class "fields" ]
        [ Html.div
            [ class "fourteen wide field" ]
            [ Html.label [] [ Html.text "Cidade" ]
            , Html.input [ value location.city, onInput (UpdateLocation "city") ] []
            ]
        , Html.div
            [ class "two wide field" ]
            [ Html.label [] [ Html.text "UF" ]
            , Html.input [ value location.state, onInput (UpdateLocation "state") ] []
            ]
        ]
    ]


viewFormPerson : Person -> List (Html Msg)
viewFormPerson person =
    [ Html.h4
        [ class "ui dividing header" ]
        [ Html.text "Informações pessoais" ]
    , Html.div
        [ class "field" ]
        [ Html.label [] [ Html.text "Nome completo" ]
        , Html.input [ value person.name, onInput (UpdatePerson "name") ] []
        ]
    , Html.div
        [ class "fields" ]
        [ Html.div
            [ class "six wide field" ]
            [ Html.label [] [ Html.text "Nacionalidade" ]
            , Html.input [ value person.nationality, onInput (UpdatePerson "nationality") ] []
            ]
        , Html.div
            [ class "six wide field" ]
            [ Html.label [] [ Html.text "Ocupação" ]
            , Html.input [ value person.occupation, onInput (UpdatePerson "occupation") ] []
            ]
        , Html.div
            [ class "four wide field" ]
            [ Html.label [] [ Html.text "Estado Civil" ]
            , Html.input [ value person.maritalStatus, onInput (UpdatePerson "maritalStatus") ] []
            ]
        ]
    , Html.div
        [ class "fields" ]
        [ Html.div
            [ class "eight wide field" ]
            [ Html.label [] [ Html.text "RG" ]
            , Html.input [ value person.personalId, onInput (UpdatePerson "personalId") ] []
            ]
        , Html.div
            [ class "eight wide field" ]
            [ Html.label [] [ Html.text "CPF" ]
            , Html.input [ value person.federalRevenueId, onInput (UpdatePerson "federalRevenueId") ] []
            ]
        ]
    , Html.div
        [ class "field" ]
        [ Html.label [] [ Html.text "Endereço" ]
        , Html.input [ value person.address, onInput (UpdatePerson "address") ] []
        ]
    , Html.div
        [ class "fields" ]
        [ Html.div
            [ class "ten wide field" ]
            [ Html.label [] [ Html.text "Cidade" ]
            , Html.input [ value person.city, onInput (UpdatePerson "city") ] []
            ]
        , Html.div
            [ class "two wide field" ]
            [ Html.label [] [ Html.text "UF" ]
            , Html.input [ value person.state, onInput (UpdatePerson "state") ] []
            ]
        , Html.div
            [ class "four wide field" ]
            [ Html.label [] [ Html.text "CEP" ]
            , Html.input [ value person.postalCode, onInput (UpdatePerson "postalCode") ] []
            ]
        ]
    ]


viewFormInstitution : Institution -> List (Html Msg)
viewFormInstitution institution =
    [ Html.h4
        [ class "ui dividing header" ]
        [ Html.text "Informações do órgão público" ]
    , Html.div
        [ class "field" ]
        [ Html.label [] [ Html.text "Razão social" ]
        , Html.input [ value institution.name, onInput (UpdateInstitution "name") ] []
        ]
    , Html.div
        [ class "field" ]
        [ Html.label [] [ Html.text "CNPJ" ]
        , Html.input [ value institution.federalRevenueId, onInput (UpdateInstitution "federalRevenueId") ] []
        ]
    , Html.div
        [ class "field" ]
        [ Html.label [] [ Html.text "Endereço" ]
        , Html.input [ value institution.address, onInput (UpdateInstitution "address") ] []
        ]
    , Html.div
        [ class "fields" ]
        [ Html.div
            [ class "ten wide field" ]
            [ Html.label [] [ Html.text "Cidade" ]
            , Html.input [ value institution.city, onInput (UpdateInstitution "city") ] []
            ]
        , Html.div
            [ class "two wide field" ]
            [ Html.label [] [ Html.text "UF" ]
            , Html.input [ value institution.state, onInput (UpdateInstitution "state") ] []
            ]
        , Html.div
            [ class "four wide field" ]
            [ Html.label [] [ Html.text "CEP" ]
            , Html.input [ value institution.postalCode, onInput (UpdateInstitution "postalCode") ] []
            ]
        ]
    ]


viewFormTicket : Model -> List (Html Msg)
viewFormTicket model =
    [ Html.h4
        [ class "ui dividing header" ]
        [ Html.text "Informações do requerimento pela LAI" ]
    , Html.div
        [ class "fields" ]
        [ Html.div
            [ class "eight wide field" ]
            [ Html.label [] [ Html.text "Número do protocolo" ]
            , Html.input [ value model.ticket.id, onInput (UpdateTicket "id") ] []
            ]
        , Html.div
            [ class "four wide field" ]
            [ Html.label [] [ Html.text "Data do protocolo" ]
            , Html.input [ value model.ticket.date, onInput (UpdateTicket "date") ] []
            ]
        , Html.div
            [ class "four wide field" ]
            [ Html.label [] [ Html.text "Prazo para resposta" ]
            , Html.input [ value model.ticket.deadline, onInput (UpdateTicket "deadline") ] []
            ]
        ]
    ]


viewForm : Model -> Html Msg
viewForm model =
    let
        nodes : List (Html Msg)
        nodes =
            List.concat
                [ viewFormLocation model.location
                , viewFormPerson model.person
                , viewFormInstitution model.institution
                , viewFormTicket model
                , [ Html.a
                        [ class "ui right labeled icon button"
                        , href model.documentInHtml
                        , download "em-nome-da-lai.doc"
                        ]
                        [ Html.i [ class "file word icon" ] []
                        , Html.text "Baixar como arquivo do Word"
                        ]
                  , Html.a
                        [ class "ui right labeled icon button"
                        , onClick Print
                        ]
                        [ Html.i [ class "print icon" ] []
                        , Html.text "Imprimir"
                        ]
                  ]
                ]
    in
    Html.form [ class "ui form" ] nodes


placeholder : List (Html Msg)
placeholder =
    [ Html.div
        [ class "ui segment" ]
        [ Html.p
            []
            [ Html.img
                [ class "ui wireframe image"
                , src "/img/short-paragraph.png"
                ]
                []
            ]
        ]
    ]


viewTitle : Location -> List (Html Msg)
viewTitle location =
    if location.city == "" || location.state == "" then
        [ Html.h1 [ style "text-transform" "uppercase" ] [ Html.text "Juiz de Direito do Juizado Especial Cível" ] ]

    else
        let
            value : String
            value =
                String.concat
                    [ "Juiz de Direito do Juizado Especial Cível da Comarca de "
                    , location.city
                    , "/"
                    , location.state
                    ]
        in
        [ Html.h1 [ style "text-transform" "uppercase" ] [ Html.text value ] ]


viewId : Person -> List (Html Msg)
viewId person =
    if person.name == "" || person.nationality == "" || person.occupation == "" || person.maritalStatus == "" || person.personalId == "" || person.federalRevenueId == "" || person.address == "" || person.city == "" || person.state == "" || person.postalCode == "" then
        placeholder

    else
        let
            value : String
            value =
                String.concat
                    [ person.name
                    , ", "
                    , person.nationality
                    , ", "
                    , person.occupation
                    , ", "
                    , person.maritalStatus
                    , ", RG "
                    , person.personalId
                    , ", CPF "
                    , person.federalRevenueId
                    , ", residente na "
                    , person.address
                    , ", "
                    , person.city
                    , "/"
                    , person.state
                    , ", CEP "
                    , person.postalCode
                    , ", vem propor a seguinte:"
                    ]
        in
        [ Html.p [] [ Html.text value ] ]


viewInstitution : Institution -> List (Html Msg)
viewInstitution institution =
    if institution.name == "" || institution.federalRevenueId == "" || institution.address == "" || institution.city == "" || institution.state == "" || institution.postalCode == "" then
        placeholder

    else
        let
            value : String
            value =
                String.concat
                    [ "Em face de "
                    , institution.name
                    , ", pessoa jurídica de direito público integrante da administração pública, inscrita no CNPJ sob o nº "
                    , institution.federalRevenueId
                    , ", com sede na "
                    , institution.address
                    , ", "
                    , institution.city
                    , "/"
                    , institution.state
                    , ", CEP "
                    , institution.postalCode
                    , ":"
                    ]
        in
        [ Html.p [] [ Html.text value ] ]


viewTicket : Model -> List (Html Msg)
viewTicket model =
    if model.ticket.id == "" || model.ticket.date == "" || model.ticket.deadline == "" || model.institution.name == "" then
        placeholder

    else
        let
            paragraph1 : String
            paragraph1 =
                String.concat
                    [ "Em "
                    , model.ticket.date
                    , " a parte autora protocolou pedido de acesso à informação, com base no art. 10 da Lei Federal 12.527/2011 (LAI) (Doc.1), perante "
                    , model.institution.name
                    , ", cujo registro de protocolo foi "
                    , model.ticket.id
                    ]

            paragraph2 : String
            paragraph2 =
                String.concat
                    [ "Sendo assim, o termo final para entrega da resposta era "
                    , model.ticket.deadline
                    , ". Entretanto, até a data de ajuizamento desta ação, não houve resposta. Assim, faz-se necessária esta ação, uma vez que não há outro meio de exercer o direito fundamental de acesso à informação neste caso senão pelo Judiciário."
                    ]
        in
        [ Html.p [] [ Html.text "Razão deste processo: o pedido de acesso à informação não foi respondido no prazo legal." ]
        , Html.p [] [ Html.text paragraph1 ]
        , Html.p [] [ Html.text "Pela LAI, o prazo de resposta é de 20 dias, prorrogáveis, de forma fundamentada e cientificada, por mais 10 dias (art.  11, §§1º e 2º). De acordo com o art. 66 e art. 67 da Lei Federal 9.784/1999, a contagem dos prazos: a) começa no dia da ciência oficial, excluindo o dia do começo e incluindo o do vencimento; b) cair em feriado ou final de semana, prorroga-se até o primeiro dia útil seguinte; c) contam-se em dias corridos." ]
        , Html.p [] [ Html.text paragraph2 ]
        ]


viewSignature : Model -> List (Html Msg)
viewSignature model =
    if model.person.name == "" || model.location.city == "" then
        placeholder

    else
        let
            monthToString : Month -> String
            monthToString month =
                case month of
                    Jan ->
                        "janeiro"

                    Feb ->
                        "fevereiro"

                    Mar ->
                        "março"

                    Apr ->
                        "abril"

                    May ->
                        "maio"

                    Jun ->
                        "junho"

                    Jul ->
                        "julho"

                    Aug ->
                        "agosto"

                    Sep ->
                        "setembro"

                    Oct ->
                        "outubro"

                    Nov ->
                        "novembro"

                    Dec ->
                        "dezembro"

            now : Posix
            now =
                Maybe.withDefault (Time.millisToPosix 0) model.now

            dateAsString : String
            dateAsString =
                String.join " de "
                    [ now |> Time.toDay model.timezone |> String.fromInt
                    , now |> Time.toMonth model.timezone |> monthToString
                    , now |> Time.toYear model.timezone |> String.fromInt
                    ]

            value : String
            value =
                String.concat [ model.location.city, dateAsString ]
        in
        [ Html.div
            []
            [ Html.text model.person.name
            , Html.br [] []
            , Html.text value
            ]
        ]


viewDocument : Model -> List (Html Msg)
viewDocument model =
    let
        nodes : List (Html Msg)
        nodes =
            List.concat
                [ viewTitle model.location
                , viewId model.person
                , [ Html.strong [ style "text-transform" "uppercase" ] [ Html.text "Ação de obrigação de fazer" ] ]
                , viewInstitution model.institution
                , [ Html.strong [ style "text-transform" "uppercase" ] [ Html.text "Fundamentos" ] ]
                , viewTicket model
                , [ Html.strong [ style "text-transform" "uppercase" ] [ Html.text "Requerimentos" ]
                  , Html.p [] [ Html.text "Diante do exposto, requer:" ]
                  , Html.p [] [ Html.text "Quanto às questões procedimentais: a) Informa-se não haver interesse em conciliação; b) Informa-se que o valor da causa é R$100,00; c) Seja a ré citada para, querendo, apresentar contestação;" ]
                  , Html.p [] [ Html.text "Quanto às questões de mérito:" ]
                  , Html.p [] [ Html.text "Seja a ação julgada procedente, para fins de obrigar o ente público a atender o requerimento de acesso à informação no prazo de 5 (cinco) dias corridos a contar da data de sentença;" ]
                  , Html.p [] [ Html.text "Sucessivamente, seja estabelecido que o descumprimento da decisão importará em multa diária de R$100,00 contra o ente público a contar automaticamente do primeiro dia corrido seguinte ao descumprimento (art. 52, V da Lei Federal 9.099/95);" ]
                  , Html.p [] [ Html.text "Sucessivamente, se o inadimplemento for superior a 30 (trinta) dias corridos, seja estabelecida multa diária no valor de R$100,00 contra a pessoa do agente público responsável pelo cumprimento da Lei de Acesso à Informação no ente público (art. 40, caput da Lei Federal 12.527/2011);" ]
                  ]
                , viewSignature model
                ]
    in
    [ Html.div [ id "document", class "ui padded piled segment" ] nodes ]


view : Model -> Html Msg
view model =
    Html.div
        [ class "ui container" ]
        [ Html.div
            [ class "ui grid" ]
            [ Html.div
                [ class "eight wide column do-not-print" ]
                [ Html.h1 [] [ Html.text "Em nome da LAI" ]
                , Html.p [] [ Html.text "Aqui vem um parágrafo descrevendo o projeto, contanto para que serve, como usar, etc." ]
                , Html.p [] [ Html.text "Comentar que nenhum dado é enviado ao servidor e que tudo fica apenas local, no computador de quem usa o site" ]
                , viewForm model
                ]
            , Html.div
                [ class "eight wide column print" ]
                (viewDocument model)
            ]
        , Html.footer
            [ class "ui divider" ]
            [ Html.a
                [ href "https://github.com/cuducos/em-nome-da-lai" ]
                [ Html.i [ class "git square icon" ] [] ]
            ]
        ]
