module Phoenix (connect, join, Socket, Channel, Subscription, ChannelSpec) where

import Task exposing (Task)
import Effects exposing (Effects, Never)
import Native.Phoenix

type Socket  = Socket
type Channel = Channel

type alias Subscription action =
    { event: String, portName: String }

type alias ChannelSpec a =
    { name: String , subscriptions: List (Subscription a) }

connect : String -> Task.Task x Socket
connect url = Native.Phoenix.connect url Nothing

join : Socket -> ChannelSpec a -> Task.Task x Channel
join socket spec = Native.Phoenix.join socket spec
