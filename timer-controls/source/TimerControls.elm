port module TimerControls
    exposing
        ( init
        , view
        , update
        , subscriptions
        , css
        , namespace
        , Message
        , Model
        , Flags
        )

import Html exposing (text, h2, Html, div)
import Html.CssHelpers exposing (withNamespace)
import Html.Polymer
    exposing
        ( paperSwatchPicker
        , color
        , paperButton
        , ironIcon
        , icon
        )
import Html.Events exposing (on, onClick)
import Json.Decode exposing (at, string, map)
import Css
    exposing
        ( (.)
        , rgb
        , Snippet
        , fontFamilies
        , margin
        , margin4
        , marginRight
        , fontWeight
        , int
        , inherit
        , padding3
        , px
        , zero
        , rem
        , display
        , block
        , textAlign
        , right
        )


-- MODEL


type alias Model =
    { initialColor : String
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
      }
    , Cmd.none
    )



-- UPDATE


type Message
    = PickInitialColor String
    | ReceiveInitialColor (Maybe String)
    | StartTimer


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


view : Model -> Html Message
view model =
    let
        { class } =
            withNamespace namespace

        onColorPickerSelected messageWithColor =
            let
                decode =
                    at [ "detail", "color" ] string
                        |> map messageWithColor
            in
                on "color-picker-selected" decode
    in
        div []
            [ h2 []
                [ text "initial color"
                ]
            , paperSwatchPicker
                [ class [ SwatchPicker ]
                , color model.initialColor
                , onColorPickerSelected PickInitialColor
                ]
                []
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



-- STYLES


type Classes
    = SwatchPicker
    | StartButtonContainer
    | StartButtonIcon


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
    ]
