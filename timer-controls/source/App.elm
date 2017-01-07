module App exposing (model, view, update, css, namespace, Message, Model)

import Css exposing ((.), rgb, Snippet, color)
import Html exposing (text, h1, Html)
import Html.CssHelpers exposing (withNamespace)


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
        h1
            [ class [ Title ]
            ]
            [ text "Hello world!"
            ]



-- STYLES


type Classes
    = Title


css : List Snippet
css =
    [ (.) Title
        [ color (rgb 220 50 50)
        ]
    ]
