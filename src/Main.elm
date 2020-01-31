module Main exposing (Model, Msg, init, update, view)

{--ELM-UI --}

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)



--}



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }



{--USER TYPE --}


type alias User =
    { session : Session
    , id : Int
    , displayName : String
    }


type Session
    = Guest
    | Valid String
--}



-- MODEL


type alias Model =
    { user : User
    , str : String
    }


init : Model
init =
    { user =
        { session = Guest
        , id = 0
        , displayName = "[model.user.displayName]"
        }
    , str = "Hello World"
    }



-- UPDATE


type Msg
    = GotInput String


update : Msg -> Model -> Model
update msg model =
    case msg of
        GotInput newStr ->
            { model | str = newStr }



-- VIEW


view : Model -> Html Msg
view model =
    Element.layout
        [ Background.color <| rgb255 33 33 33
        , Font.color <| rgb255 150 200 200
        , Element.explain Debug.todo
        ]
    <|
        column
            [ centerX
            , centerY ]
            [ row
                [ height fill
                , width fill
                , padding 10
                , spacing 30
                ]
                [ strField model ]
            , row
                []
                [ myInput model ]
            ]


strField : Model -> Element msg
strField model =
    el [] <| text model.str


{--}
myInput : Model -> Element Msg
myInput model =
    Input.username
        [ Input.focusedOnLoad
        , Border.rounded 25
        , Border.widthXY 8 3
        , Font.color <| rgb255 33 33 100
        ]
        { onChange = GotInput
        , text = model.str
        , label =
            Input.labelBelow
                [ centerX
                , Font.size 14
                , Font.color <| rgb255 150 150 150
                ]
                (text "[model.str]")
        , placeholder = Nothing

        -- , placeholder = Just (Input.placeholder [ ] (text "[model.str]"))
        }
--}
