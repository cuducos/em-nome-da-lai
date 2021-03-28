module Update exposing (Msg(..), subscriptions, update)

import Model exposing (Institution, Location, Model, Person, Ticket)
import Time exposing (Posix, Zone)


type Msg
    = UpdateTime Posix
    | UpdateTimezone Zone
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


updateModel : Msg -> Model -> Model
updateModel msg model =
    case msg of
        UpdateTime now ->
            { model | now = now }

        UpdateTimezone zone ->
            { model | timezone = zone }

        UpdateLocation key value ->
            { model | location = updateLocation key value model.location }

        UpdatePerson key value ->
            { model | person = updatePerson key value model.person }

        UpdateInstitution key value ->
            { model | institution = updateInstitution key value model.institution }

        UpdateTicket key value ->
            { model | ticket = updateTicket key value model.ticket }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( updateModel msg model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 5000 UpdateTime
