module Phoenix (foo) where

import Native.Phoenix

foo : Int
foo =
    Native.Phoenix.foo ()
