port module TimerControls exposing (init, view, update, subscriptions, css, namespace, Message, Model, Flags)

import Html exposing (text, h2, Html, div, span)
import Html.CssHelpers exposing (withNamespace)
import Html.Polymer exposing (paperSwatchPicker, color, paperButton, ironIcon, icon, colorList, columnCount)
import Html.Custom exposing (inlineInput, autofocus, placeholder, value)
import Html.Events exposing (on, onClick)
import Json.Decode exposing (at, string, map)
import Css exposing ((.), rgb, Snippet, fontFamilies, margin, margin4, marginRight, fontWeight, int, inherit, padding3, px, zero, rem, display, block, textAlign, right, opacity, num, none, property, cursor, pointer, hover)
import String
import Dict exposing (Dict)


-- MODEL


type alias Model =
    { initialColor : String
    , colorBreakpoints : Dict Int ColorBreakpoint
    , nextColorBreakpointIndex : Int
    }


type alias ColorBreakpoint =
    { color : String
    , seconds : Int
    }


type alias Flags =
    { initialColor : Maybe String
    }


colorFromMaybe : Maybe String -> String
colorFromMaybe =
    Maybe.withDefault "#000000"


init : Flags -> ( Model, Cmd message )
init flags =
    ( { initialColor = colorFromMaybe flags.initialColor
      , colorBreakpoints = Dict.empty
      , nextColorBreakpointIndex = 0
      }
    , Cmd.none
    )



-- UPDATE


type Message
    = PickInitialColor String
    | ReceiveInitialColor (Maybe String)
    | StartTimer
    | AddColorBreakpoint
    | SetBreakpointColor Int String


update : Message -> Model -> ( Model, Cmd message )
update message model =
    case message of
        PickInitialColor color ->
            { model
                | initialColor = color
            }
                ! [ sendInitialColor color ]

        ReceiveInitialColor maybeColor ->
            update (PickInitialColor <| colorFromMaybe maybeColor) model

        StartTimer ->
            model ! [ startTimer True ]

        AddColorBreakpoint ->
            { model
                | colorBreakpoints =
                    Dict.insert
                        model.nextColorBreakpointIndex
                        { seconds = 0, color = model.initialColor }
                        model.colorBreakpoints
                , nextColorBreakpointIndex =
                    model.nextColorBreakpointIndex + 1
            }
                ! []

        SetBreakpointColor index color ->
            let
                colorBreakpoints =
                    Dict.update
                        index
                        (Maybe.map <| \breakpoint -> { breakpoint | color = color })
                        model.colorBreakpoints
            in
                { model | colorBreakpoints = colorBreakpoints }
                    ! [ sendColorBreakpoints (Dict.values colorBreakpoints) ]


port sendInitialColor : String -> Cmd message


port sendColorBreakpoints : List ColorBreakpoint -> Cmd message


port startTimer : Bool -> Cmd message



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Message
subscriptions model =
    receiveInitialColor ReceiveInitialColor


port receiveInitialColor :
    (Maybe String -> message)
    -> Sub message



-- VIEW


namespace : String
namespace =
    "h28dne-"


{ class } =
    withNamespace namespace


view : Model -> Html Message
view model =
    div [] <|
        [ h2 []
            [ text "start with this color"
            ]
        , colorPicker PickInitialColor model.initialColor
        ]
            ++ List.concatMap colorBreakpoint (Dict.toList model.colorBreakpoints)
            ++ [ h2 []
                    [ span
                        [ class [ NewColorBreakpointPlaceholder ]
                        , onClick AddColorBreakpoint
                        ]
                        [ text "+ add color breakpoint"
                        ]
                    ]
               , div
                    [ class [ StartButtonContainer ]
                    ]
                    [ paperButton
                        [ onClick StartTimer
                        ]
                        [ ironIcon
                            [ icon "av:play-arrow"
                            , class [ StartButtonIcon ]
                            ]
                            []
                        , text "Ready to roll"
                        ]
                    ]
               ]


colorPicker : (String -> Message) -> String -> Html Message
colorPicker messageWithColor pickedColor =
    let
        onColorPickerSelected =
            let
                decode =
                    at [ "detail", "color" ] string
                        |> map messageWithColor
            in
                on "color-picker-selected" decode
    in
        paperSwatchPicker
            [ class [ SwatchPicker ]
            , color pickedColor
            , onColorPickerSelected
            , colorList """["#f44336", "#e91e63", "#9c27b0", "#673ab7", "#2196f3", "#3f51b5", "#00bcd4", "#03a9f4", "#4caf50", "#009688", "#cddc39", "#8bc34a", "#ffc107", "#ff9800", "#ff5722", "#000000"]"""
            , columnCount "8"
            ]
            []


colorBreakpoint : ( Int, ColorBreakpoint ) -> List (Html Message)
colorBreakpoint ( breakpointIndex, breakpoint ) =
    let
        timeChunk number =
            String.padLeft 2 '0' (toString number)
    in
        [ h2 []
            [ text "at "
            , inlineInput
                ([ value (timeChunk <| breakpoint.seconds // 60)
                 ]
                    ++ (autofocus True)
                )
                []
            , text ":"
            , inlineInput
                [ value (timeChunk <| breakpoint.seconds % 60)
                ]
                []
            , text ", set the color to"
            ]
        , colorPicker (SetBreakpointColor breakpointIndex) breakpoint.color
        ]



-- STYLES


type Classes
    = SwatchPicker
    | StartButtonContainer
    | StartButtonIcon
    | StartButtonIcon_Disabled
    | NewColorBreakpointPlaceholder


css : List Snippet
css =
    [ (.) SwatchPicker
        [ margin (px -16)
        ]
    , (.) StartButtonContainer
        [ margin4 (Css.rem 2) zero zero zero
        , textAlign right
        ]
    , (.) StartButtonIcon
        [ marginRight (Css.rem 0.2) ]
    , (.) StartButtonIcon_Disabled
        [ property "pointer-events" "none"
        , opacity (num 0.3)
        ]
    , (.) NewColorBreakpointPlaceholder
        [ opacity (num 0.5)
        , cursor pointer
        , hover
            [ opacity (num 1)
            ]
        ]
    ]
