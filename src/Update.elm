port module Update exposing (Msg(..), subscriptions, update)

import Dict exposing (Dict)
import Form.Model exposing (Field, FieldSet)
import Form.Update exposing (isFormValid, isValid)
import Http
import MinhaReceita.Model exposing (Company)
import MinhaReceita.Update exposing (loadCompany)
import Model exposing (Form, Model)
import Set
import Time exposing (Posix, Zone)


port print : () -> Cmd msg


port getWordFile : () -> Cmd msg


port updateWordFile : (String -> msg) -> Sub msg


type Msg
    = UpdateTime Posix
    | UpdateTimezone Zone
    | Print
    | GetWordFile
    | UpdateWordFile String
    | UpdateLocation String String
    | UpdatePerson String String
    | UpdateInstitution String String
    | UpdateTicket String String
    | LoadCompany (Result Http.Error Company)


validate : Form -> Form
validate form =
    let
        valid : Bool
        valid =
            isFormValid
                [ form.location
                , form.person
                , form.institution
                , form.ticket
                ]
    in
    { form | valid = valid }


updateForm : String -> Model -> Form -> ( Model, Cmd Msg )
updateForm key model form =
    let
        result : ( Model, Cmd Msg )
        result =
            update GetWordFile { model | form = validate form }
    in
    if key == "CNPJ" then
        updateAndLoadCompany result

    else
        result


updateAndLoadCompany : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
updateAndLoadCompany result =
    let
        model : Model
        model =
            Tuple.first result

        msg : Cmd Msg
        msg =
            Tuple.second result

        form : Form
        form =
            model.form

        institution : FieldSet
        institution =
            Form.Update.disable
                (Set.fromList [ "Razão social", "Endereço", "Cidade", "UF", "CEP" ])
                form.institution
    in
    if Form.Update.isValid "CNPJ" model.form.institution then
        ( { model | form = { form | institution = institution } }
        , Cmd.batch
            [ msg
            , model.form.institution
                |> Form.Update.get "CNPJ"
                |> Maybe.map .value
                |> Maybe.withDefault ""
                |> loadCompany LoadCompany
            ]
        )

    else
        result


updateCompany : Company -> Model -> ( Model, Cmd Msg )
updateCompany company model =
    let
        address : List String
        address =
            List.filter (String.isEmpty >> not)
                [ company.addressType, company.addressLine1, company.addressNumber, company.addressLine2 ]

        asDict : Dict String String
        asDict =
            Dict.fromList
                [ ( "Razão social", company.name )
                , ( "Endereço", String.join " " address )
                , ( "Cidade", company.city )
                , ( "UF", company.state )
                , ( "CEP", company.postalCode )
                ]

        form : Form
        form =
            model.form

        toUpdate : String -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
        toUpdate key ( m, msg ) =
            asDict
                |> Dict.get key
                |> Maybe.map (\v -> updateForm key m { form | institution = Form.Update.set key v m.form.institution })
                |> Maybe.withDefault ( m, msg )
                |> (\( newModel, newMsg ) -> ( newModel, Cmd.batch [ msg, newMsg ] ))
    in
    List.foldr toUpdate ( model, Cmd.none ) [ "Razão social", "Endereço", "Cidade", "UF", "CEP" ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        form : Form
        form =
            model.form
    in
    case msg of
        UpdateTime now ->
            update GetWordFile { model | now = Just now }

        UpdateTimezone zone ->
            ( { model | timezone = zone }, Cmd.none )

        Print ->
            ( model, print () )

        GetWordFile ->
            ( model, getWordFile () )

        UpdateWordFile documentInHtml ->
            ( { model | documentInHtml = documentInHtml }, Cmd.none )

        UpdateLocation key value ->
            updateForm key model { form | location = Form.Update.set key value form.location }

        UpdatePerson key value ->
            updateForm key model { form | person = Form.Update.set key value form.person }

        UpdateInstitution key value ->
            updateForm key model { form | institution = Form.Update.set key value form.institution }

        UpdateTicket key value ->
            updateForm key model { form | ticket = Form.Update.set key value form.ticket }

        LoadCompany (Ok company) ->
            updateCompany company model

        LoadCompany (Err err) ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.now of
        Just now ->
            updateWordFile UpdateWordFile

        Nothing ->
            Sub.batch
                [ updateWordFile UpdateWordFile
                , Time.every 1 UpdateTime
                ]
