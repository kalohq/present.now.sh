module Html.Polymer exposing (..)

import Html exposing (node, Html, Attribute)
import Html.Attributes exposing (attribute)


type alias Node message =
    List (Attribute message) -> List (Html message) -> Html message


paperSwatchPicker : Node message
paperSwatchPicker =
    node "paper-swatch-picker"


color : String -> Attribute message
color =
    attribute "color"
