module Main exposing (..)

import Html exposing (beginnerProgram, h1, text)


main : Program Never () msg
main =
    beginnerProgram
        { model = ()
        , update = \_ -> \_ -> ()
        , view = \_ -> h1 [] [ text "Hello world!" ]
        }
