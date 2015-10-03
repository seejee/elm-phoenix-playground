import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp.Simple exposing (start)

main =
  StartApp.Simple.start
    { model = 0
    , update = update
    , view = view
    }

main =
  app.html

port tasks : Signal (Task.Task Never ())
port tasks = app.tasks

-- MODEL

type alias Model = Int

init : Int -> Model
init count = count

-- UPDATE

type Action = Increment | Decrement

update : Action -> Model -> Model
update action model =
  case action of
    Increment -> model + 1
    Decrement -> model - 1

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ button [ onClick address Decrement ] [ text "-" ]
    , div [ countStyle ] [ text (toString model) ]
    , button [ onClick address Increment ] [ text "+" ]
    ]

type alias Context =
    { actions : Signal.Address Action
    , remove : Signal.Address ()
    }

countStyle : Attribute
countStyle =
  style
    [ ("font-size", "20px")
    , ("font-family", "monospace")
    , ("display", "inline-block")
    , ("width", "50px")
    , ("text-align", "center")
    ]
