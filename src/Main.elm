module Main exposing (Model, Msg, init, update, view)

import Browser
import Html exposing (Html)
-- import Html.Attributes as Attr exposing (placeholder, value)
import Element.Events exposing (onClick)

{-- ELM-UI --}
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input

--}
-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }



{-- USER TYPE --}
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
        , displayName = "guest101"
        }
    , str = "hello moto"
    }



-- UPDATE


type Msg
    = GotInput String
    | NoOp


update : Msg -> Model -> Model
update msg model =
    case msg of

        GotInput str  ->
             model 
        
        NoOp -> 
            model



-- VIEW


view : Model -> Html Msg
view model =
     Element.layout
        [ Background.color <| rgb255 33 33 33
        , Font.color <| rgb255 150 200 200 ] <| 
        row [ height fill 
            , width fill
            , padding 10
            , spacing 30 ]
            [useless model]
        

useless model = 
    column []
        [ el 
            [ padding 10
            , Border.solid
            , Border.rounded 5
            , Border.width 1
            , onClick GotInput]
            (text model.str)
        , myInput model.str
        ]
        
    

{--}
myInput: String -> Element (String -> msg)
myInput str =
     Input.username  
            [ padding 5
            , Border.width 1
            , Border.rounded 3
            , Border.color <| rgb255 200 200 200
            ] 
            { label = Input.labelHidden "gone"
            , onChange = GotInput "str"
            , placeholder = Just (Input.placeholder [] (text str))
            , text = "bye"
    }
    --}