module Main exposing (Model, Msg, init, update, view)

import Browser
import Html exposing (..)



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    { text : String
    }


init : Model
init =
    { text = "helloooo"
    }



-- UPDATE


type Msg
    = Msg1
    | Msg2


update : Msg -> Model -> Model
update msg model =
    case msg of
        Msg1 ->
            model

        Msg2 ->
            model



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ text model.text ]
