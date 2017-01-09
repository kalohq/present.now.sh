port module App exposing (init, view, update, subscriptions, css, namespace, Message, Model)

import Html exposing (text, h2, Html, div)
import Html.CssHelpers exposing (withNamespace)
import Html.Polymer exposing (paperSwatchPicker)
import Html.Events exposing (on)
import Json.Decode exposing (at, string, map)
import Css
    exposing
        ( (.)
        , rgb
        , Snippet
        , color
        , fontFamilies
        , margin
        , fontWeight
        , int
        , inherit
        , padding3
        , px
        , zero
        )


-- MODEL


type alias Model =
    { initialColor : String
    }


init : ( Model, Cmd message )
init =
    ( { initialColor = "#000000"
      }
    , Cmd.none
    )



-- UPDATE


type Message
    = PickInitialColor String


update : Message -> Model -> ( Model, Cmd message )
update message model =
    case message of
        PickInitialColor color ->
            { model
                | initialColor = color
            }
                ! [ sendInitialColor color ]


port sendInitialColor : String -> Cmd message


subscriptions : Model -> Sub Message
subscriptions _ =
    Sub.none



-- VIEW


namespace : String
namespace =
    "h28dne-"


view : Model -> Html Message
view _ =
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
                , onColorPickerSelected PickInitialColor
                ]
                []
            ]



-- STYLES


type Classes
    = SwatchPicker


css : List Snippet
css =
    [ (.) SwatchPicker
        [ margin (px -16)
        ]
    ]
