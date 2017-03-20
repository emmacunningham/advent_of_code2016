module App exposing (..)

import Html exposing (Html, text, div, img)
import Html.Attributes exposing (src)


type alias Model =
    { message : String
    , logo : String
    , challenges : List Challenge
    }


type alias Challenge =
    { input : String
    , solveFn : String -> String
    , name : String
    }


init : String -> ( Model, Cmd Msg )
init path =
    ( { message = "Advent of Elm"
      , logo = path
      , challenges =
            [ { input = "day5.txt"
              , solveFn = \x -> x
              , name = "Day 5"
              }
            ]
      }
    , Cmd.none
    )


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


renderChallenge : Challenge -> Html Msg
renderChallenge challenge =
    div [] [ text challenge.name ]


view : Model -> Html Msg
view model =
    div []
        -- [ img [ src model.logo ] []
        -- , div [] [ text model.message ]
        -- ]
        (List.map renderChallenge model.challenges)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
