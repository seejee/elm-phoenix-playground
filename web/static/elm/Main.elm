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
    , inputs = [Signal.map (\message -> SetCounter message.value) newCounter]
    }

main =
  app.html

-- MODEL

type alias Model =
    { counter: Int
    , socket: Maybe Socket
    }

init : (Model, Effects Action)
init = (
    { counter = 0, socket = Nothing }
    , connect)

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
        Connected maybeSocket ->
            case maybeSocket of
                Just socket ->
                    ({ model | socket  <- maybeSocket }, (join socket))
                Nothing ->
                    ({ model | counter <- -1 }, Effects.none)

        Joined maybeChannel ->
            ({model | counter <- model.counter + 1}, Effects.none)

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

port newCounter : Signal NewCounterMessage

-- Effects

channelSpec : ChannelSpec Action
channelSpec = {
    name = "counter"
    , subscriptions = [ { event = "new_counter", portName = "newCounter"} ]
    }

connect : Effects Action
connect =
    Phoenix.connect "/socket"
    |> Task.toMaybe
    |> Task.map Connected
    |> Effects.task

join : Socket -> Effects Action
join socket =
    Phoenix.join socket (channelSpec)
    |> Task.toMaybe
    |> Task.map Joined
    |> Effects.task

