port module Stylesheets exposing (..)

import Css.File exposing (CssFileStructure, CssCompilerProgram)
import Css exposing (stylesheet)
import Css.Namespace exposing (namespace)
import TimerControls


port files : CssFileStructure -> Cmd msg


fileStructure : CssFileStructure
fileStructure =
    Css.File.toFileStructure
        [ ( "../public/components/timer-controls/style.css"
          , Css.File.compile
                [ TimerControls.css |> namespace TimerControls.namespace |> stylesheet
                ]
          )
        ]


main : CssCompilerProgram
main =
    Css.File.compiler files fileStructure
