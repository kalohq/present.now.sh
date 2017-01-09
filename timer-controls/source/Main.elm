module Main exposing (main)

import Html exposing (program)
import App


main : Program Never App.Model App.Message
main =
    program
        { init = App.init
        , update = App.update
        , view = App.view
        , subscriptions = App.subscriptions
        }
