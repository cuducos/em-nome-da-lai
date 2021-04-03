port module Update exposing (Msg(..), subscriptions, update)

import Form.Model exposing (FieldSet)
import Form.Update exposing (isFormValid)
import Model exposing (Form, Model)
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


updateForm : Model -> Form -> ( Model, Cmd Msg )
updateForm model form =
    update GetWordFile { model | form = validate form }


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
            updateForm model { form | location = Form.Update.set key value form.location }

        UpdatePerson key value ->
            updateForm model { form | person = Form.Update.set key value form.person }

        UpdateInstitution key value ->
            updateForm model { form | institution = Form.Update.set key value form.institution }

        UpdateTicket key value ->
            updateForm model { form | ticket = Form.Update.set key value form.ticket }


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
