module Main exposing (main)

import Browser
import Html exposing (Html, br, text)
import Html.Attributes exposing (placeholder, style, value)
import Html.Events exposing (onInput)
import Model exposing (Institution, Location, Model, Person, Ticket)
import Task
import Time
import Update exposing (Msg(..), subscriptions, update)
import View exposing (view)


init : () -> ( Model, Cmd Msg )
init _ =
    ( { location = Location "" ""
      , person = Person "" "" "" "" "" "" "" "" "" ""
      , institution = Institution "" "" "" "" "" ""
      , ticket = Ticket "" "" ""
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
