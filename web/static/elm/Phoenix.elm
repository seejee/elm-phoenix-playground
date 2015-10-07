module Phoenix (connect, channel, on, join, Socket, Channel, Subscription, ChannelSpec) where

import Task exposing (Task)
import Effects exposing (Effects, Never)
import Native.Phoenix

type Socket = Socket
type Channel = Channel

type alias Subscription message =
    { event: String, address: Signal.Address message }

type alias ChannelSpec = String

connect : String -> Task.Task x Socket
connect url = Native.Phoenix.connect url Nothing

channel : ChannelSpec -> Socket -> Task.Task x Channel
channel socket spec = Native.Phoenix.channel socket spec

on : Subscription message -> Channel -> Task.Task x Channel
on sub channel = Native.Phoenix.on sub channel

join : Channel -> Task.Task x Channel
join channel = Native.Phoenix.join channel
