module Main exposing (Model, init, Msg, update, view, subscriptions)

import Html exposing (..)
import Browser
import Browser.Navigation as Nav
import Url
import Time exposing (Posix)


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = UrlRequested
        , onUrlChange = UrlChanged
    }


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , time : Posix
    }


init : Url.Url -> Nav.Key -> (Model, Cmd Msg)
init url key =
    (Model key url (Time.millisToPosix 0), Cmd.none)


type Msg
    = Tick Posix
    | Msg2
    | UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Tick newTime ->
            ({model | time = newTime}, Cmd.none)

        Msg2 ->
            (model, Cmd.none)

        UrlRequested urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Browser.Document Msg
view model =
    { title = "Application Title"
    , body =
        [ div []
            [ text "New Application" ]
      ]
    }


