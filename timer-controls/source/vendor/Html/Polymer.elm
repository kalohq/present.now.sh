module Html.Polymer exposing (..)

import Html exposing (node, Html, Attribute)
import Html.Attributes exposing (attribute)


type alias Node message =
    List (Attribute message) -> List (Html message) -> Html message


paperSwatchPicker : Node message
paperSwatchPicker =
    node "paper-swatch-picker"


paperButton : Node message
paperButton =
    node "paper-button"


ironIcon : Node message
ironIcon =
    node "iron-icon"


icon : String -> Attribute message
icon =
    attribute "icon"


color : String -> Attribute message
color =
    attribute "color"


colorList : String -> Attribute message
colorList =
    attribute "color-list"


columnCount : String -> Attribute message
columnCount =
    attribute "column-count"
