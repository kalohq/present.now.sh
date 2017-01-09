module Main exposing (main)

import Html exposing (programWithFlags)
import TimerControls


main : Program TimerControls.Flags TimerControls.Model TimerControls.Message
main =
    programWithFlags
        { init = TimerControls.init
        , update = TimerControls.update
        , view = TimerControls.view
        , subscriptions = TimerControls.subscriptions
        }
