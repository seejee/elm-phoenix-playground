import Phoenix exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Effects exposing (Effects, Never)
import Task exposing (..)

import StartApp exposing (start)

app =
  StartApp.start
    { init = init
    , update = update
    , view = view
    , inputs = [setCounterFromServer]
    }

main =
  app.html

-- MODEL

type alias Model =
    { counter: Int
    , channel: Maybe Channel
    }

init : (Model, Effects Action)
init = (
    { counter = 0, channel = Nothing }
    , join)

-- UPDATE

type Action =
    Connected (Maybe Socket)
    | Joined (Maybe Channel)
    | Increment
    | Decrement
    | SetCounter Int

update : Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        Joined maybeChannel ->
            case maybeChannel of
                Just channel ->
                    ({ model | channel  <- maybeChannel }, Effects.none)
                Nothing ->
                    ({ model | counter <- -1 }, Effects.none)

        Increment ->
            ({model | counter <- model.counter + 1}, Effects.none)

        Decrement ->
            ({model | counter <- model.counter - 1}, Effects.none)

        SetCounter value ->
            ({model | counter <- value}, Effects.none)

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ button [ onClick address Decrement ] [ text "-" ]
    , div [ countStyle ] [ text (toString model.counter) ]
    , button [ onClick address Increment ] [ text "+" ]
    ]

countStyle : Attribute
countStyle =
  style
    [ ("font-size", "20px")
    , ("font-family", "monospace")
    , ("display", "inline-block")
    , ("width", "50px")
    , ("text-align", "center")
    ]

-- Ports

port tasks : Signal (Task.Task Never ())
port tasks = app.tasks

type alias NewCounterMessage = { value: Int }

newCounterMailbox : Signal.Mailbox NewCounterMessage
newCounterMailbox = Signal.mailbox { value = 1 }

setCounterFromServer : Signal Action
setCounterFromServer =
    Signal.map (\message -> SetCounter message.value) newCounterMailbox.signal

-- Effects

join : Effects Action
join =
    Phoenix.connect "/socket"
    `andThen`
    Phoenix.channel "counter"
    `andThen`
    Phoenix.on "new_counter" newCounterMailbox.address
    `andThen`
    Phoenix.join
    |> Task.toMaybe
    |> Task.map Joined
    |> Effects.task
