import Phoenix exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Effects exposing (Effects, Never)
import Task exposing (..)

import StartApp exposing (start)

port counter : Signal Model

signals = [Signal.map SetCounter counter]

app =
  StartApp.start
    { init = init
    , update = update
    , view = view
    , inputs = signals
    }

main =
  app.html

port tasks : Signal (Task.Task Never ())
port tasks = app.tasks

-- MODEL

type alias Model = Int

init : (Model, Effects Action)
init = (0, connect)

-- UPDATE

type Action =
    Connected (Maybe Socket)
    | Increment
    | Decrement
    | SetCounter Int

update : Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        Connected socket -> (model + 17, Effects.none)
        Increment -> (model + 1, Effects.none)
        Decrement -> (model - 1, Effects.none)
        SetCounter value -> (value, Effects.none)

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ button [ onClick address Decrement ] [ text "-" ]
    , div [ countStyle ] [ text (toString model) ]
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

-- Effects

connect : Effects Action
connect =
    Phoenix.connect "/socket"
    |> Task.toMaybe
    |> Task.map Connected
    |> Effects.task
