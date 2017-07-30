port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


port username : String -> Cmd msg


main : Program Never TempModel InputEvents
main =
    program
        { init = ( globalModel, Cmd.none )
        , view = globalView
        , update = globalUpdate
        , subscriptions = subscriptions
        }


port sendToPort : String -> Cmd msg


port suggestions : (String -> msg) -> Sub msg


subscriptions : TempModel -> Sub InputEvents
subscriptions model =
    suggestions Suggest


type alias TempModel =
    { word : String
    }


type InputEvents
    = NameEntered String
    | PasswordEntered String
    | PasswordEnteredAgain String
    | ButtonClicked
    | Suggest String


globalModel : TempModel
globalModel =
    { word = ""
    }


globalUpdate : InputEvents -> TempModel -> ( TempModel, Cmd messageReceived )
globalUpdate message localModel =
    case message of
        NameEntered name ->
            let
                d =
                    Debug.log "asd" name
            in
            ( localModel, sendToPort name )

        PasswordEntered password ->
            ( localModel, sendToPort password )

        PasswordEnteredAgain password ->
            ( localModel, sendToPort password )

        ButtonClicked ->
            ( localModel, sendToPort "Submit" )

        Suggest list ->
            let
                d =
                    Debug.log "subscription" list
            in
            ( localModel, Cmd.none )


globalView : TempModel -> Html InputEvents
globalView localModel =
    div []
        [ text "Hello World"
        , loginForm
        ]


globalTempView : TempModel -> Html String
globalTempView localModel =
    text "Hello World"


labelBox : String -> Html nothing
labelBox enterText =
    div [] [ input [ placeholder <| ("Enter " ++ enterText) ] [] ]


buttonBox : String -> InputEvents -> Html InputEvents
buttonBox enterText eventName =
    div [ onClick eventName ] [ input [ placeholder <| ("Enter " ++ enterText) ] [] ]


inputBox : String -> (String -> InputEvents) -> Html InputEvents
inputBox enterText eventName =
    div [] [ input [ onInput eventName, placeholder <| ("Enter " ++ enterText) ] [] ]


loginForm : Html InputEvents
loginForm =
    div [ style [ ( "border", "1px solid blue" ) ] ]
        [ inputBox "Name" NameEntered
        , inputBox "Password" PasswordEntered
        , inputBox "Password" PasswordEnteredAgain
        , buttonBox "Password" ButtonClicked
        ]
