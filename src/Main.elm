module Main exposing (Model, Msg, init, update, view)

import Browser
import Html exposing (Html, br, div, input, text)
import Html.Attributes as Attr exposing (placeholder, value)
import Html.Events exposing (onInput)



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
    { name : String
    , familyName : String
    , age : Int
    }


init : Model
init =
    { name = "n/a"
    , familyName = "n/a"
    , age = -1
    }



-- UPDATE


type Msg
    = NameInput String
    | FamilyNameInput String
    | AgeInput String


update : Msg -> Model -> Model
update msg model =
    case msg of
        NameInput nameIn ->
            { model | name = nameIn }

        FamilyNameInput fNameIn ->
            { model | familyName = fNameIn }

        AgeInput ageStr ->
            { model
                | age = Maybe.withDefault -1 (String.toInt ageStr)
            }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ text ("name: " ++ model.name ++ " " ++ model.familyName)
        , br [] []
        , text ("age: " ++ String.fromInt model.age)
        , div []
            [ input [ onInput NameInput, placeholder "name" ] []
            , input [ onInput FamilyNameInput, placeholder "family name" ] []
            , input
                [ onInput AgeInput
                , Attr.type_ "number"
                , value (String.fromInt model.age)
                ]
                []
            ]
        ]
