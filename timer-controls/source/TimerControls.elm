port module TimerControls exposing (init, view, update, subscriptions, css, namespace, Message, Model, Flags)

import Html exposing (text, h2, Html, div, span)
import Html.CssHelpers exposing (withNamespace)
import Html.Polymer exposing (paperSwatchPicker, color, paperButton, ironIcon, icon)
import Html.Custom exposing (inlineInput, autofocus, placeholder, value)
import Html.Events exposing (on, onClick)
import Json.Decode exposing (at, string, map)
import Css exposing ((.), rgb, Snippet, fontFamilies, margin, margin4, marginRight, fontWeight, int, inherit, padding3, px, zero, rem, display, block, textAlign, right, opacity, num, none, property, cursor, pointer, hover)


-- MODEL


type alias Model =
    { initialColor : String
    , colorBreakpoints : List ColorBreakpoint
    }


type ColorBreakpoint
    = SettingTime
        { minutes : String
        , seconds : String
        }
    | AllSet
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
      , colorBreakpoints = []
      }
    , Cmd.none
    )



-- UPDATE


type Message
    = PickInitialColor String
    | ReceiveInitialColor (Maybe String)
    | StartTimer
    | AddColorBreakpoint


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
                    model.colorBreakpoints
                        ++ [ SettingTime { minutes = "", seconds = "00" }
                           ]
            }
                ! []


port sendInitialColor : String -> Cmd message


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
    let
        onColorPickerSelected messageWithColor =
            let
                decode =
                    at [ "detail", "color" ] string
                        |> map messageWithColor
            in
                on "color-picker-selected" decode
    in
        div [] <|
            [ h2 []
                [ text "start with this color"
                ]
            , paperSwatchPicker
                [ class [ SwatchPicker ]
                , color model.initialColor
                , onColorPickerSelected PickInitialColor
                ]
                []
            ]
                ++ List.concatMap colorBreakpoint model.colorBreakpoints
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


colorBreakpoint : ColorBreakpoint -> List (Html Message)
colorBreakpoint breakpoint =
    case breakpoint of
        SettingTime { minutes, seconds } ->
            [ h2 []
                [ text "at "
                , inlineInput
                    ([ placeholder "mm"
                     , value minutes
                     ]
                        ++ (autofocus True)
                    )
                    []
                , text ":"
                , inlineInput
                    [ placeholder "ss"
                    , value seconds
                    ]
                    []
                , text ", set the color to"
                ]
            ]

        _ ->
            []



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
