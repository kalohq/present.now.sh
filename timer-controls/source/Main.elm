module Main exposing (main)

import Html exposing (programWithFlags)
import App


main : Program App.Flags App.Model App.Message
main =
    programWithFlags
        { init = App.init
        , update = App.update
        , view = App.view
        , subscriptions = App.subscriptions
        }
