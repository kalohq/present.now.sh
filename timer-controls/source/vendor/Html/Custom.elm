module Html.Custom exposing (..)

import Html exposing (node, Html, Attribute)
import Html.Attributes exposing (attribute)


type alias Node message =
    List (Attribute message) -> List (Html message) -> Html message


inlineInput : Node message
inlineInput =
    node "inline-input"


autofocus : Bool -> List (Attribute message)
autofocus on =
    if on then
        [ attribute "autofocus" "" ]
    else
        []


placeholder : String -> Attribute message
placeholder =
    attribute "placeholder"


valueOnBlur : String -> Attribute message
valueOnBlur =
    attribute "value-on-blur"
