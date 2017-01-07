module Main exposing (main)

import Html exposing (beginnerProgram)
import App


main : Program Never () App.Message
main =
    beginnerProgram
        { model = App.model
        , update = App.update
        , view = App.view
        }
