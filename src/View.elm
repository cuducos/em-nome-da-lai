module View exposing (view)

import Form.Model exposing (FieldSet)
import Form.View exposing (isValid)
import Html exposing (Html)
import Html.Attributes exposing (class, download, href, id, src, style, type_, value)
import Html.Events exposing (onClick, onInput)
import Model exposing (Model)
import Time exposing (Month(..), Posix)
import Update exposing (Msg(..))


viewForm : Model -> Html Msg
viewForm model =
    let
        nodes : List (Html Msg)
        nodes =
            List.concat
                [ Form.View.set model.form.location UpdateLocation
                , Form.View.set model.form.person UpdatePerson
                , Form.View.set model.form.institution UpdateInstitution
                , Form.View.set model.form.ticket UpdateTicket
                , [ Form.View.button
                        "Baixar como arquivo do Word"
                        "word file"
                        model.form.valid
                        [ href model.documentInHtml
                        , download "em-nome-da-lai.doc"
                        ]
                  , Form.View.button
                        "Imprimir"
                        "print"
                        model.form.valid
                        [ onClick Print ]
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


viewTitle : FieldSet -> List (Html Msg)
viewTitle location =
    if location.valid then
        let
            value : String
            value =
                String.concat
                    [ "Juiz de Direito do Juizado Especial Cível da Comarca de "
                    , Form.View.value "Cidade" location
                    , "/"
                    , Form.View.value "UF" location
                    ]
        in
        [ Html.h1 [ style "text-transform" "uppercase" ] [ Html.text value ] ]

    else
        [ Html.h1 [ style "text-transform" "uppercase" ] [ Html.text "Juiz de Direito do Juizado Especial Cível" ] ]


viewId : FieldSet -> List (Html Msg)
viewId person =
    if person.valid then
        let
            value : String
            value =
                String.concat
                    [ Form.View.value "Nome completo" person
                    , ", "
                    , Form.View.value "Nacionalidade" person
                    , ", "
                    , Form.View.value "Ocupação" person
                    , ", "
                    , Form.View.value "Estado civil" person
                    , ", RG "
                    , Form.View.value "RG" person
                    , ", CPF "
                    , Form.View.value "CPF" person
                    , ", residente na "
                    , Form.View.value "Endereço" person
                    , ", "
                    , Form.View.value "Cidade" person
                    , "/"
                    , Form.View.value "UF" person
                    , ", CEP "
                    , Form.View.value "CEP" person
                    , ", vem propor a seguinte:"
                    ]
        in
        [ Html.p [] [ Html.text value ] ]

    else
        placeholder


viewInstitution : FieldSet -> List (Html Msg)
viewInstitution institution =
    if institution.valid then
        let
            value : String
            value =
                String.concat
                    [ "Em face de "
                    , Form.View.value "Razão sozial" institution
                    , ", pessoa jurídica de direito público integrante da administração pública, inscrita no CNPJ sob o nº "
                    , Form.View.value "CNPJ" institution
                    , ", com sede na "
                    , Form.View.value "Endereço" institution
                    , ", "
                    , Form.View.value "Cidade" institution
                    , "/"
                    , Form.View.value "UF" institution
                    , ", CEP "
                    , Form.View.value "CEP" institution
                    , ":"
                    ]
        in
        [ Html.p [] [ Html.text value ] ]

    else
        placeholder


viewTicket : Model -> List (Html Msg)
viewTicket model =
    if model.form.ticket.valid && isValid "Razão social" model.form.institution then
        let
            paragraph1 : String
            paragraph1 =
                String.concat
                    [ "Em "
                    , Form.View.value "Data do protocolo" model.form.ticket
                    , " a parte autora protocolou pedido de acesso à informação, com base no art. 10 da Lei Federal 12.527/2011 (LAI) (Doc.1), perante "
                    , Form.View.value "Razão social" model.form.institution
                    , ", cujo registro de protocolo foi "
                    , Form.View.value "Número de protocolo" model.form.ticket
                    ]

            paragraph2 : String
            paragraph2 =
                String.concat
                    [ "Sendo assim, o termo final para entrega da resposta era "
                    , Form.View.value "Data para resposta" model.form.ticket
                    , ". Entretanto, até a data de ajuizamento desta ação, não houve resposta. Assim, faz-se necessária esta ação, uma vez que não há outro meio de exercer o direito fundamental de acesso à informação neste caso senão pelo Judiciário."
                    ]
        in
        [ Html.p [] [ Html.text "Razão deste processo: o pedido de acesso à informação não foi respondido no prazo legal." ]
        , Html.p [] [ Html.text paragraph1 ]
        , Html.p [] [ Html.text "Pela LAI, o prazo de resposta é de 20 dias, prorrogáveis, de forma fundamentada e cientificada, por mais 10 dias (art.  11, §§1º e 2º). De acordo com o art. 66 e art. 67 da Lei Federal 9.784/1999, a contagem dos prazos: a) começa no dia da ciência oficial, excluindo o dia do começo e incluindo o do vencimento; b) cair em feriado ou final de semana, prorroga-se até o primeiro dia útil seguinte; c) contam-se em dias corridos." ]
        , Html.p [] [ Html.text paragraph2 ]
        ]

    else
        placeholder


viewSignature : Model -> List (Html Msg)
viewSignature model =
    if isValid "Nome completo" model.form.person && isValid "Cidade" model.form.location then
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
                String.concat [ Form.View.value "Cidade" model.form.location, ", ", dateAsString ]
        in
        [ Html.div
            []
            [ Html.text (Form.View.value "Nome completo" model.form.person)
            , Html.br [] []
            , Html.text value
            ]
        ]

    else
        placeholder


viewDocument : Model -> List (Html Msg)
viewDocument model =
    let
        nodes : List (Html Msg)
        nodes =
            List.concat
                [ viewTitle model.form.location
                , viewId model.form.person
                , [ Html.strong [ style "text-transform" "uppercase" ] [ Html.text "Ação de obrigação de fazer" ] ]
                , viewInstitution model.form.institution
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
