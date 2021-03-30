port module Update exposing (Msg(..), subscriptions, update)

import Model exposing (Institution, Location, Model, Person, Ticket)
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


updateLocation : String -> String -> Location -> Location
updateLocation key value location =
    if key == "city" then
        { location | city = value }

    else if key == "state" then
        { location | state = value }

    else
        location


updatePerson : String -> String -> Person -> Person
updatePerson key value person =
    if key == "name" then
        { person | name = value }

    else if key == "nationality" then
        { person | nationality = value }

    else if key == "occupation" then
        { person | occupation = value }

    else if key == "maritalStatus" then
        { person | maritalStatus = value }

    else if key == "personalId" then
        { person | personalId = value }

    else if key == "federalRevenueId" then
        { person | federalRevenueId = value }

    else if key == "address" then
        { person | address = value }

    else if key == "city" then
        { person | city = value }

    else if key == "state" then
        { person | state = value }

    else if key == "postalCode" then
        { person | postalCode = value }

    else
        person


updateInstitution : String -> String -> Institution -> Institution
updateInstitution key value institution =
    if key == "name" then
        { institution | name = value }

    else if key == "federalRevenueId" then
        { institution | federalRevenueId = value }

    else if key == "address" then
        { institution | address = value }

    else if key == "city" then
        { institution | city = value }

    else if key == "state" then
        { institution | state = value }

    else if key == "postalCode" then
        { institution | postalCode = value }

    else
        institution


updateTicket : String -> String -> Ticket -> Ticket
updateTicket key value ticket =
    if key == "id" then
        { ticket | id = value }

    else if key == "date" then
        { ticket | date = value }

    else if key == "deadline" then
        { ticket | deadline = value }

    else
        ticket


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
            update GetWordFile { model | location = updateLocation key value model.location }

        UpdatePerson key value ->
            update GetWordFile { model | person = updatePerson key value model.person }

        UpdateInstitution key value ->
            update GetWordFile { model | institution = updateInstitution key value model.institution }

        UpdateTicket key value ->
            update GetWordFile { model | ticket = updateTicket key value model.ticket }


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
