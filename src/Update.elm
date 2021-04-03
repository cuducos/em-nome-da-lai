port module Update exposing (Msg(..), subscriptions, update)

import Form.Model exposing (FieldSet)
import Form.Update
import Model exposing (Model)
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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
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
            update GetWordFile { model | location = Form.Update.set key value model.location }

        UpdatePerson key value ->
            update GetWordFile { model | person = Form.Update.set key value model.person }

        UpdateInstitution key value ->
            update GetWordFile { model | institution = Form.Update.set key value model.institution }

        UpdateTicket key value ->
            update GetWordFile { model | ticket = Form.Update.set key value model.ticket }


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
