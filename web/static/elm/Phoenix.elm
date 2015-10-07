module Phoenix (connect, channel, on, join, Socket, Channel, ChannelSpec) where

import Task exposing (Task)
import Effects exposing (Effects, Never)
import Native.Phoenix

type Socket = Socket
type Channel = Channel

type alias ChannelSpec = String

connect : String -> Task.Task x Socket
connect url = Native.Phoenix.connect url Nothing

channel : ChannelSpec -> Socket -> Channel
channel spec socket = Native.Phoenix.channel spec socket

on : String -> Signal message -> Channel -> Channel
on event portSignal channel = Native.Phoenix.on event portSignal channel

join : Channel -> Task.Task x Channel
join channel = Native.Phoenix.join channel
