module Main exposing (Model, Msg, update, view, subscriptions, init)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Json.Decode as D
import Http

main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
    }


type alias Model =
    { user : String
    , int : Int
    , invStatus: Element Msg
    , inv : List Item
    , log : Element Msg
    }


init : () -> (Model, Cmd Msg)
init () =
    ({ user = ""
    , int = 1
    , invStatus= greenStatus "loading.."
    , inv = [{name = "..", office = "..", labeled = False, sent = False }]
    , log = Element.none
    } 
    , getInventory)


type Msg
    = GotInput String
    | GotInv (Result Http.Error (List Item))

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotInput newStr ->
            ( {model | user = newStr}
            , Cmd.none )

        GotInv result ->
            case result of
                Ok res ->
                    ( { model 
                        | invStatus = greenStatus "Inventory Loaded"
                        , log = Element.none
                        , inv = res}, Cmd.none )      

                Err err ->
                    ( {model | invStatus = redStatus "Could not load inventory"
                        , log =paragraph 
                            [ Font.size 15
                            , Font.light 
                            , Font.color <| rgb255 255 150 150
                            ]
                            [ text (Debug.toString err)] } , Cmd.none )
            
getInventory : Cmd Msg
getInventory =
  Http.get
    { url = "http://localhost:3000/computers"
    , expect = Http.expectJson GotInv invExpectDecoder
    }
-- getInventory =
--   Http.post
--     { url = "http://localhost:3000/computers"
--     , body = Http.emptyBody
--     , expect = Http.expectJson GotInv invExpectDecoder
--     }

invDecoder : D.Decoder (List Item)
invDecoder = 
    D.list <| D.field "computers" computerDecoder

invExpectDecoder : D.Decoder ( List Item )
invExpectDecoder = D.list computerDecoder


computerDecoder : D.Decoder Item
computerDecoder = 
    D.map4 Item
        (D.field "name" D.string)
        (D.field "office" D.string)
        (D.field "labeled" D.bool)
        (D.field "sent" D.bool)



                    
            



subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    Element.layout
        [ Background.color <| rgb255 33 33 33
        , Font.color <| rgb255 150 200 200
        , Font.size 18] <| mainColumn model
        
        
mainColumn : Model ->  Element Msg
mainColumn model = 
    column 
        [ centerX]
        [ column 
            [padding 15
            , alignRight
            ]
            [ model.log
            , model.invStatus ]
        , row 
            [ width fill
            -- , Border.width 1
            , padding 10
            ][itemsTable model.inv ]
        ]

redStatus : String -> Element Msg
redStatus str =
    el 
        [ Font.color <| rgb 1 1 1
        , Font.size 12
        , Border.solid
        , Border.width 2
        , Border.color <| rgb255 150 50 50
        , Border.rounded 25 
        , padding 5
        ] <| text str
       
greenStatus : String -> Element Msg
greenStatus str =
    el 
        [ Font.color <| rgb 1 1 1
        , Font.size 12
        , Border.solid
        , Border.width 2
        , Border.color <| rgb255 50 150 50
        , Border.rounded 25 
        , padding 5
        ] <| text str


type alias Item =
    { name : String
    , office : String
    , labeled : Bool
    , sent : Bool
    }

itemsTable : List Item -> Element Msg
itemsTable inv =
    table
        [ spacing 0 ]
        { data = inv
        , columns =
            [ { header = el
                [ Font.color (rgb255 100 100 100)
                , Border.widthEach {bottom = 2,left = 0,top = 0,right = 0}
                , Font.center
                , padding 10 ] (text "Computer Name")
              , width = fill
              , view =
                    \item ->
                        el
                            [ padding 5
                            , Font.center
                            , Border.width 1] 
                            (text item.name)
              }
            , { header = el
                [ Font.color (rgb255 100 100 100)
                , Border.widthEach {bottom = 2,left = 0,top = 0,right = 0}
                , Font.center
                , padding 10 ] (text "Office")
              , width = fill
              , view =
                    \item ->
                        el
                            [ padding 5
                            , Font.center
                            , Border.width 1] 
                            (text item.office)
              }
            , { header = el
                [ Font.color (rgb255 100 100 100)
                , Border.widthEach {bottom = 2,left = 0,top = 0,right = 0}
                , Font.center
                , padding 10 ] (text "Labeled")
              , width = fill
              , view =
                    \item ->
                        el
                            [ padding 5
                            , Font.center
                            , Border.width 1] 
                            (text ( boolToStr item.labeled ))
              }
            , { header = el
                [ Font.color (rgb255 100 100 100)
                , Border.widthEach {bottom = 2,left = 0,top = 0,right = 0}
                , Font.center
                , padding 10 ] (text "Sent")
              , width = fill
              , view =
                    \item ->
                        el
                            [ padding 5
                            , Font.center
                            , Border.width 1] 
                            (text ( boolToStr item.sent ))
              }
            ]
        }

boolToStr : Bool -> String
boolToStr bool =  
    if bool 
        then "Yes"
        else "No"

{--}
strInput : String -> Element Msg
strInput str =
    Input.username
        [ Input.focusedOnLoad
        , Font.color <| rgb255 33 33 100
        ]
        { onChange = GotInput
        , text = str
        , label =
            Input.labelBelow
                [ centerX
                , Font.size 14
                , Font.color <| rgb255 150 150 150
                , transparent True
                ]
                (text "[model.user]")
        -- , placeholder = Nothing
        , placeholder = Just (Input.placeholder [ ] (text "[model.user]"))
        }
--}


-- type Office
--     = Karhlsruhe
--     | Dublin
--     | Wiesbaden
--     | Caldicot
--     | Paris
--     | Solna
--     | Invalid

-- officeToText : Office -> String
-- officeToText office = 
--     case office of
--         Karhlsruhe ->
--             "Karhlsruhe"
--         Dublin -> 
--             "Dublin"
--         Wiesbaden ->
--             "Wiesbaden"
--         Caldicot -> 
--             "Caldicot"
--         Paris -> 
--             "Paris"
--         Solna ->
--             "Solna"
--         Invalid ->
--             "n/a"

            
-- strToOffice : String -> Office
-- strToOffice str = 
--     case str of
--         "Karhlsruhe" ->
--             Karhlsruhe
--         "Dublin" -> 
--             Dublin
--         "Wiesbaden" ->
--             Wiesbaden
--         "Caldicot" -> 
--             Caldicot
--         "Paris" -> 
--             Paris
--         "Solna" ->
--             Solna
--         _ ->
--             Invalid
    
