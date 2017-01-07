module Html.Polymer exposing (..)

import Html exposing (node, Html, Attribute)


type alias Node message =
    List (Attribute message) -> List (Html message) -> Html message


paperSwatchPicker : Node message
paperSwatchPicker =
    node "paper-swatch-picker"
