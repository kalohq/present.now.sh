port module Stylesheets exposing (..)

import Css.File exposing (CssFileStructure, CssCompilerProgram)
import Css exposing (stylesheet)
import Css.Namespace exposing (namespace)
import App


port files : CssFileStructure -> Cmd msg


fileStructure : CssFileStructure
fileStructure =
    Css.File.toFileStructure
        [ ( "dist/style.css"
          , Css.File.compile
                [ App.css |> namespace App.namespace |> stylesheet
                ]
          )
        ]


main : CssCompilerProgram
main =
    Css.File.compiler files fileStructure
