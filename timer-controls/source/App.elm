module App exposing (model, view, update, css, namespace, Message, Model)

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
        div []
            [ h2 []
                [ text "initial color"
                ]
            , paperSwatchPicker
                [ class [ SwatchPicker ]
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
