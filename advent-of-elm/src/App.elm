module App exposing (..)

import Html exposing (Html, text, div, img)
import Html.Attributes exposing (src)
import Http


type alias Model =
    { message : String
    , solution : String
    }


type alias Challenge =
    { solution : String
    , name : String
    }


challenges : List Challenge
challenges =
    [ { name = "Project Euler 1: "
      , solution = toString (computeFizzBuzzSum 1000)
      }
    , { name = "Project Euler 2: "
      , solution = toString (computeFiboSum 4000000 1 2 0)
      }
    ]


init : String -> ( Model, Cmd Msg )
init path =
    ( { message = "Advent of Elm"
      , solution =
            ""
            -- , challenges =
            --       [ { input = "day6.txt"
            --         , solveFn = \x -> x
            --         , name = "Day 6"
            --         }
            --       ]
      }
    , fetchData
    )


type Msg
    = Day6Data (Result Http.Error String)


fetchData : Cmd Msg
fetchData =
    let
        request =
            Http.getString "input/day6.txt"
    in
        Http.send Day6Data request


generateAcc : Int -> List (List String)
generateAcc num =
    let
        listRange =
            List.range 0 (num - 1)
    in
        List.map (\x -> []) listRange


foldLines : Int -> String -> List (List String) -> List (List String)
foldLines lineLength val list =
    let
        v =
            Debug.log "v" val

        l =
            Debug.log "v" list
    in
        [ [ val ] ]


transposeList : List String -> Int -> List String
transposeList lines idx =
    List.map (\x -> String.slice (idx - 1) idx x) lines


updateModel : Model -> String -> Model
updateModel model response =
    { model | solution = "foo" }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Day6Data (Ok response) ->
            ( updateModel model response, Cmd.none )

        Day6Data (Err _) ->
            ( model, Cmd.none )


renderChallenge : Challenge -> Html Msg
renderChallenge challenge =
    div [] [ text challenge.name, text challenge.solution ]


computeFizzBuzzSum : Int -> Int
computeFizzBuzzSum upperBound =
    List.range 0 (upperBound - 1)
        |> List.filter (\x -> x % 3 == 0 || x % 5 == 0)
        |> List.sum


computeFiboSum : Int -> Int -> Int -> Int -> Int
computeFiboSum upperBound f1 f2 sum =
    let
        nextSum =
            case f1 % 2 of
                0 ->
                    sum + f1

                _ ->
                    sum
    in
        if f2 > upperBound then
            nextSum
        else
            computeFiboSum upperBound f2 (f1 + f2) nextSum


view : Model -> Html Msg
view model =
    div []
        (List.map renderChallenge challenges)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
