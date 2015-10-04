module Phoenix (connect, Socket) where

import Task exposing (Task)
import Effects exposing (Effects, Never)
import Native.Phoenix

type Socket = Socket

connect : String -> Task.Task x Socket
connect url = Native.Phoenix.connect url Nothing
