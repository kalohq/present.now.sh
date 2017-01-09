module App exposing (model, view, update, css, namespace, Message, Model)

import Css
    exposing
        ( (.)
        , rgb
        , Snippet
        , color
        , fontFamilies
        , marginLeft
        , fontWeight
        , int
        , inherit
        , padding3
        , px
        , zero
        )
import Html exposing (text, h2, Html, div)
import Html.CssHelpers exposing (withNamespace)
import Html.Polymer exposing (paperSwatchPicker)


-- MODEL


type alias Model =
    ()


model : Model
model =
    ()



-- UPDATE


type alias Message =
    ()


update : Message -> Model -> Model
update _ _ =
    ()



-- VIEW


namespace : String
namespace =
    "h28dne-"


view : Model -> Html Message
view _ =
    let
        { class } =
            withNamespace namespace
    in
        div
            [ class [ Root ]
            ]
            [ h2
                [ class [ Label ]
                ]
                [ text "initial color"
                ]
            , paperSwatchPicker
                [ class [ SwatchPicker ]
                ]
                []
            ]



-- STYLES


type Classes
    = Root
    | Label
    | SwatchPicker


css : List Snippet
css =
    [ (.) Root
        [ fontFamilies [ "roboto", "sans-serif" ]
        , fontWeight (int 300)
        ]
    , (.) Label
        [ fontWeight inherit
        , padding3 (px 30) zero zero
        ]
    , (.) SwatchPicker
        [ marginLeft (px -16)
        ]
    ]
