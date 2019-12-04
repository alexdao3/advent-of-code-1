module Year2018.Day08 exposing (Input1, Input2, Metadata, Output1, Output2, Tree(..), compute1, compute2, input_, main, parse1, parse2, tests1, tests2)

import Advent
    exposing
        ( Test
          -- , unsafeToInt
          -- , unsafeMaybe
        )
import Dict exposing (Dict)



-- 1. TYPES (what is the best representation of the problem?)


type alias Input1 =
    Tree


type alias Input2 =
    Tree


type alias Output1 =
    Int


type alias Output2 =
    Int


type Tree
    = Node (List Tree) (List Metadata)


type alias Metadata =
    Int



-- 2. PARSE (mangle the input string into the representation we decided on)


parse1 : String -> Input1
parse1 string =
    let
        startingInts : List Int
        startingInts =
            string
                |> String.words
                |> List.map Advent.unsafeToInt

        buildNTimes : Int -> List Int -> ( List Tree, List Int )
        buildNTimes toDo ints =
            buildNTimesHelp toDo [] ints

        buildNTimesHelp : Int -> List Tree -> List Int -> ( List Tree, List Int )
        buildNTimesHelp toDo builtSoFar ints =
            if toDo == 0 then
                ( builtSoFar, ints )

            else
                let
                    ( newBuilt, newInts ) =
                        build ints

                    newBuiltSoFar : List Tree
                    newBuiltSoFar =
                        builtSoFar ++ [ newBuilt ]
                in
                buildNTimesHelp (toDo - 1) newBuiltSoFar newInts

        build : List Int -> ( Tree, List Int )
        build ints =
            case ints of
                childrenCount :: metadataCount :: restOfInts ->
                    let
                        ( children, intsAfterChildren ) =
                            buildNTimes childrenCount restOfInts

                        metadata : List Int
                        metadata =
                            List.take metadataCount intsAfterChildren

                        intsAfterMetadata : List Int
                        intsAfterMetadata =
                            List.drop metadataCount intsAfterChildren
                    in
                    ( Node children metadata, intsAfterMetadata )

                _ ->
                    Debug.todo "wrong input 1"
    in
    build startingInts
        |> Tuple.first


parse2 : String -> Input2
parse2 string =
    parse1 string



-- 3. COMPUTE (actually solve the problem)


sumMetadata : Tree -> Int
sumMetadata (Node children metadata) =
    let
        current =
            List.sum metadata

        childrens =
            List.sum (List.map sumMetadata children)
    in
    current + childrens


compute1 : Input1 -> Output1
compute1 input =
    sumMetadata input


value : Tree -> Int
value (Node children metadata) =
    if List.isEmpty children then
        List.sum metadata

    else
        let
            indexedChildren : Dict Int Tree
            indexedChildren =
                children
                    |> List.indexedMap (\i c -> ( i + 1, c ))
                    |> Dict.fromList
        in
        metadata
            |> List.filterMap (\index -> Dict.get index indexedChildren)
            |> List.map value
            |> List.sum


compute2 : Input2 -> Output2
compute2 input =
    value input



-- 4. TESTS (uh-oh, is this problem a hard one?)


tests1 : List (Test Input1 Output1)
tests1 =
    [ Test "example"
        "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
        Nothing
        138
    ]


tests2 : List (Test Input2 Output2)
tests2 =
    []



-- BOILERPLATE (shouldn't have to touch this)


input_ : String
input_ =
    """
8 11 6 3 5 5 3 4 1 9 0 7 1 2 1 6 9 1 9 1 1 2 1 2 1 1 2 3 1 6 0 9 1 4 3 8 8 3 6 1 1 2 1 1 2 2 3 1 7 0 10 4 1 1 3 9 8 5 6 2 6 1 3 2 3 3 1 3 3 2 1 2 3 7 1 6 0 6 3 1 1 9 9 4 1 3 1 3 2 3 1 9 0 10 9 5 5 2 5 9 1 5 4 2 2 1 3 2 1 1 2 1 2 1 7 0 9 9 1 3 4 5 9 7 6 8 2 2 3 1 1 1 3 1 4 2 3 2 1 3 3 7 1 6 0 10 8 6 1 7 3 3 4 1 1 8 3 2 1 3 1 1 1 8 0 11 3 5 9 3 8 1 2 9 4 1 6 3 3 2 1 2 1 2 1 1 6 0 6 3 1 7 4 6 7 2 1 3 1 1 1 1 5 2 2 1 5 1 3 5 1 5 0 8 4 9 8 8 4 6 2 1 1 3 3 1 1 1 6 0 11 2 8 7 5 1 5 9 2 8 1 2 1 2 3 3 3 3 1 9 0 11 6 9 2 3 1 5 7 3 2 4 1 2 1 1 2 3 3 2 1 1 2 3 1 1 4 3 7 1 7 0 7 8 2 8 9 3 1 2 1 1 3 3 3 3 1 1 5 0 11 9 1 5 8 1 6 8 4 8 3 2 2 1 1 1 1 1 5 0 11 4 4 1 5 2 8 7 9 2 9 2 2 2 1 1 2 3 3 1 5 5 5 1 4 1 3 6 5 5 3 3 6 1 5 0 10 5 6 2 4 7 1 2 1 3 2 1 1 2 2 3 1 9 0 8 2 4 5 6 1 7 2 1 3 1 2 3 2 2 3 2 3 1 9 0 11 9 6 8 1 9 6 1 2 1 2 4 2 1 2 3 1 3 3 3 1 2 5 3 1 4 2 3 7 1 5 0 9 3 1 2 8 2 5 2 9 4 3 1 3 3 1 1 8 0 6 1 5 5 1 4 6 1 3 2 2 1 1 1 3 1 5 0 7 8 4 2 4 1 4 8 3 2 1 1 2 5 4 2 1 5 2 1 3 4 1 9 0 8 3 3 1 1 8 5 1 7 2 3 2 3 2 3 1 2 1 1 5 0 6 1 4 7 5 6 1 1 2 2 1 2 1 6 0 7 1 2 1 6 8 1 9 1 3 1 2 1 3 3 2 5 4 3 4 1 5 0 8 1 4 5 3 1 1 1 7 1 1 1 3 2 1 7 0 7 8 7 5 1 7 8 1 2 1 3 1 3 3 1 1 7 0 7 5 3 1 5 6 7 9 2 3 2 2 3 2 1 3 4 1 5 3 5 1 8 0 10 7 9 1 9 9 7 2 3 4 9 1 3 1 1 2 1 2 1 1 6 0 11 9 1 4 1 5 8 3 6 3 1 3 1 2 2 1 3 2 1 5 0 9 5 4 2 1 9 1 6 7 4 3 3 1 2 1 2 1 5 1 3 6 2 5 5 4 3 4 1 9 0 6 4 4 2 5 5 1 1 3 1 2 1 3 3 3 2 1 5 0 10 1 7 1 2 3 8 6 1 3 7 2 3 1 3 1 1 5 0 7 1 7 6 8 8 1 9 1 1 1 1 3 1 2 4 3 3 4 1 6 0 7 5 4 5 4 2 1 3 3 1 2 3 2 3 1 9 0 8 1 2 2 3 3 5 5 9 3 2 2 1 1 1 3 2 3 1 9 0 6 2 2 7 6 4 1 3 3 2 1 2 2 1 1 3 3 4 2 4 3 5 1 7 0 11 4 3 7 1 5 7 3 3 1 2 1 1 2 1 1 2 3 2 1 9 0 10 5 6 9 9 9 6 1 4 2 1 1 3 3 1 2 2 3 1 2 1 6 0 8 5 3 6 3 8 1 4 3 3 1 1 2 3 1 5 5 5 3 4 3 4 1 5 0 7 4 1 1 1 4 2 8 3 1 1 2 1 1 8 0 6 3 9 6 1 7 5 3 2 3 3 3 3 1 2 1 7 0 11 7 2 1 5 8 8 1 5 6 1 3 3 3 1 2 2 3 1 1 5 5 2 3 7 1 6 0 10 7 3 1 7 8 2 5 7 6 1 1 3 1 2 1 2 1 9 0 9 6 3 6 9 4 2 1 8 7 3 2 1 3 2 3 1 3 1 1 6 0 9 6 3 5 7 5 6 1 5 8 3 3 1 1 3 1 4 4 4 4 2 2 4 7 3 4 4 4 5 3 7 1 9 0 7 4 1 2 6 5 3 5 1 2 2 2 2 1 3 2 3 1 7 0 8 3 7 1 8 9 1 9 7 3 2 1 1 1 1 2 1 8 0 6 4 1 1 8 1 1 3 1 3 3 1 1 2 3 1 2 1 1 1 2 4 3 5 1 7 0 6 4 4 1 9 2 1 3 2 3 1 1 1 2 1 7 0 9 8 9 1 4 6 7 4 2 1 2 2 1 2 1 3 1 1 6 0 6 1 3 9 1 4 7 1 1 1 3 2 1 3 2 1 1 5 3 4 1 6 0 11 8 7 1 4 7 9 1 1 8 1 7 3 1 3 1 1 3 1 5 0 10 2 2 2 6 6 2 2 3 4 1 1 1 1 1 2 1 7 0 9 6 3 3 1 2 2 8 3 7 1 2 3 1 2 3 1 5 1 1 3 3 4 1 8 0 10 5 8 1 1 6 7 3 1 3 6 1 2 1 3 3 2 1 2 1 5 0 10 1 5 1 3 2 2 7 9 1 6 3 1 1 3 2 1 9 0 8 1 7 6 1 5 6 7 7 1 1 3 1 1 1 1 1 2 1 1 1 5 5 2 5 3 4 4 5 3 5 1 9 0 9 5 8 2 4 1 7 3 1 1 3 2 3 2 2 1 1 2 3 1 7 0 7 8 6 8 1 6 9 8 2 3 1 1 3 1 1 1 5 0 11 8 4 1 7 5 8 2 2 2 2 7 3 1 3 1 1 2 3 3 4 3 3 4 1 9 0 7 8 7 4 8 1 4 1 1 1 3 2 1 1 3 3 3 1 9 0 7 5 7 3 9 8 9 1 2 2 3 2 1 3 3 1 2 1 6 0 6 1 3 6 1 4 1 1 2 1 2 2 3 2 1 4 4 3 4 1 9 0 10 7 7 1 8 8 9 1 9 4 4 1 3 2 1 1 1 1 3 3 1 7 0 8 2 1 1 4 4 4 7 2 2 1 1 2 1 2 2 1 8 0 8 4 2 4 2 3 6 5 1 3 2 3 1 1 1 1 1 4 1 1 5 3 5 1 5 0 11 8 1 1 4 4 4 7 9 5 9 3 1 1 1 3 1 1 6 0 8 1 6 7 3 9 3 6 5 2 2 1 2 2 1 1 9 0 11 1 1 7 2 5 1 1 8 7 1 2 2 2 2 2 2 2 2 1 2 1 5 5 1 3 5 1 5 6 6 5 4 3 7 1 8 0 8 6 1 1 2 1 7 9 6 1 3 1 2 3 3 1 3 1 6 0 8 5 9 1 7 3 4 4 1 2 1 3 1 2 1 1 8 0 8 1 6 5 4 4 7 7 1 2 3 3 2 2 2 1 2 5 5 4 3 2 3 1 3 7 1 8 0 6 8 1 1 1 5 1 3 1 1 2 2 3 1 2 1 7 0 8 1 4 7 1 9 2 1 7 2 2 2 1 2 2 1 1 8 0 11 1 2 7 8 4 6 7 4 1 8 6 1 1 1 1 1 1 3 1 1 1 1 3 5 1 2 3 4 1 5 0 6 4 5 9 9 1 5 1 1 1 3 3 1 9 0 8 1 2 5 3 7 7 2 1 3 1 3 3 3 3 2 3 3 1 7 0 10 8 2 5 3 1 6 4 1 2 6 1 2 2 1 2 3 3 2 3 3 3 3 7 1 5 0 10 1 3 5 8 6 4 7 7 2 4 3 1 3 1 1 1 7 0 8 5 4 1 4 4 9 4 3 1 1 2 3 1 1 2 1 7 0 10 7 9 7 8 7 2 1 3 2 4 2 3 3 1 2 2 1 4 1 5 4 3 4 2 3 4 1 8 0 9 1 7 9 7 8 1 4 8 9 2 2 3 2 1 3 1 2 1 5 0 7 4 2 3 3 1 2 8 1 2 1 3 1 1 8 0 7 7 1 1 1 4 5 8 1 2 3 1 1 3 3 2 5 1 5 3 2 4 4 2 1 5 6 6 3 5 3 3 5 1 7 0 10 4 7 3 5 1 7 3 9 3 1 2 1 2 1 2 2 2 1 5 0 10 6 2 1 5 5 7 2 6 2 9 1 3 1 1 3 1 9 0 10 7 2 3 8 8 2 1 6 4 5 1 2 2 2 2 3 2 3 2 5 3 4 2 3 3 6 1 8 0 9 3 1 4 9 5 3 5 6 7 1 2 2 1 3 3 3 2 1 6 0 11 2 9 5 1 4 7 3 3 1 8 7 2 2 2 2 1 1 1 9 0 10 3 3 7 5 1 1 6 3 7 2 3 2 2 1 1 1 1 3 2 2 2 2 5 2 1 3 5 1 7 0 11 2 2 1 5 1 6 5 6 7 4 7 3 2 1 3 2 1 1 1 8 0 6 4 1 1 6 1 1 1 2 1 3 1 3 1 1 1 7 0 10 2 1 5 2 7 6 5 9 2 2 3 1 3 1 2 2 3 1 4 5 2 4 3 5 1 7 0 6 3 8 4 4 7 1 1 1 3 3 1 2 1 1 8 0 6 9 2 9 5 7 1 3 1 3 3 3 1 2 3 1 5 0 7 9 6 2 1 1 4 8 1 1 1 1 2 4 3 3 3 2 3 5 1 5 0 8 1 1 1 8 1 2 1 8 1 2 1 2 1 1 8 0 9 5 1 8 2 8 5 2 1 1 1 2 1 1 3 2 3 1 1 8 0 8 7 1 6 8 9 1 2 1 3 2 1 1 3 1 3 2 1 2 2 4 2 4 7 5 5 3 3 5 1 5 0 7 8 1 6 1 8 3 4 3 1 2 3 1 1 9 0 6 1 8 5 5 7 7 1 3 1 1 1 1 1 2 1 1 9 0 6 1 7 6 7 9 7 1 2 2 3 1 3 2 1 3 5 5 3 1 3 3 6 1 7 0 6 1 4 9 7 1 1 1 2 3 1 2 3 3 1 8 0 10 9 4 1 5 3 3 4 1 1 4 1 2 1 2 2 1 1 3 1 7 0 11 1 9 3 8 3 6 9 2 6 4 7 1 3 1 1 2 3 2 4 3 5 4 2 4 3 5 1 9 0 8 4 9 8 3 1 1 1 5 2 3 3 1 1 1 2 1 1 1 8 0 10 6 7 6 9 4 1 8 7 1 4 2 3 3 1 2 1 1 1 1 7 0 6 3 1 5 6 9 6 3 3 1 3 2 3 2 2 2 1 1 4 3 6 1 8 0 9 1 9 2 1 8 2 3 3 2 1 2 2 3 3 2 2 2 1 7 0 10 6 3 5 6 1 2 3 4 2 3 3 1 1 2 3 3 3 1 8 0 9 7 5 6 2 2 2 7 9 1 2 2 2 1 1 2 3 1 5 1 3 2 3 2 3 6 1 6 0 8 1 2 2 6 1 5 6 2 3 3 2 1 1 3 1 5 0 8 6 8 9 2 8 5 3 1 2 2 3 3 1 1 6 0 11 7 3 1 4 8 2 4 6 2 5 6 1 1 1 2 1 2 1 5 4 3 3 1 3 2 1 5 4 3 4 1 7 0 9 6 4 1 6 7 3 5 1 3 1 2 3 2 2 2 1 1 5 0 6 1 3 8 8 8 6 3 3 3 1 3 1 8 0 8 3 5 6 4 1 1 2 7 2 1 2 1 1 2 1 1 5 1 3 2 3 4 1 5 0 7 1 9 4 3 8 9 9 3 1 1 3 1 1 8 0 10 9 6 2 9 6 9 5 5 1 1 1 3 1 2 3 3 1 2 1 5 0 8 5 4 5 2 1 7 6 1 1 1 1 1 3 1 2 3 3 3 6 1 8 0 11 2 6 7 5 6 1 9 3 4 6 6 3 2 1 1 3 3 1 1 1 7 0 8 1 1 5 8 7 1 2 9 3 3 2 1 2 2 3 1 7 0 6 9 1 5 1 4 7 1 1 1 1 3 1 2 4 2 5 1 4 2 3 5 1 7 0 9 3 3 8 6 1 5 5 6 7 2 2 1 3 2 3 3 1 6 0 11 1 8 4 3 2 2 7 1 9 5 9 1 1 1 3 2 3 1 8 0 10 2 1 7 7 1 5 8 8 3 3 3 1 2 1 1 1 3 3 2 5 3 5 2 3 4 1 6 0 9 9 3 6 6 4 4 1 3 7 2 1 2 1 3 1 1 5 0 8 1 6 7 7 1 9 3 5 2 2 2 2 1 1 8 0 6 1 9 1 2 2 7 1 1 1 1 3 2 3 2 1 1 2 5 3 4 1 4 5 4 3 6 1 6 0 8 6 2 3 2 5 8 8 1 1 1 2 3 2 2 1 9 0 9 1 7 9 1 9 4 5 7 9 2 3 2 2 2 1 1 1 2 1 7 0 8 2 7 3 3 5 4 1 7 1 2 3 2 1 3 1 4 2 2 5 1 2 3 6 1 8 0 10 9 4 2 2 1 9 3 8 1 9 2 3 2 2 3 1 3 1 1 6 0 8 1 1 6 9 1 9 3 4 3 1 1 1 3 1 1 7 0 8 7 1 3 6 1 3 1 2 1 3 3 2 2 1 1 2 2 1 3 4 1 3 4 1 6 0 10 1 2 9 4 2 1 4 3 1 6 1 3 1 1 1 2 1 6 0 11 5 1 8 4 7 2 3 8 6 4 1 1 1 2 2 2 2 1 5 0 9 9 7 4 4 2 1 4 2 9 2 3 2 3 1 1 1 3 1 3 7 1 5 0 9 5 1 2 7 1 8 5 1 8 2 1 1 3 1 1 6 0 10 7 9 1 9 1 1 3 7 8 3 3 1 2 2 2 2 1 9 0 11 7 5 9 5 1 6 5 8 8 9 7 2 1 2 1 1 2 2 2 1 3 4 1 1 2 2 3 3 7 1 6 0 8 6 8 3 8 9 9 1 6 1 2 3 2 3 1 1 7 0 10 5 1 4 9 2 1 9 9 9 1 1 1 1 2 1 1 1 1 8 0 9 9 5 5 8 7 4 1 5 4 1 1 3 2 1 3 1 3 4 3 4 3 3 1 2 7 4 1 5 4 5 3 6 1 7 0 8 6 3 1 9 8 8 3 4 1 1 2 2 1 1 3 1 6 0 10 5 3 9 1 3 7 3 3 3 1 1 1 1 1 1 3 1 6 0 7 1 6 2 6 9 9 5 2 2 1 1 3 3 3 3 2 4 1 5 3 4 1 8 0 8 8 2 1 4 1 6 9 7 2 3 3 3 3 1 3 3 1 7 0 8 3 3 4 1 1 2 3 5 3 3 1 3 3 1 3 1 7 0 7 2 1 8 6 3 4 6 2 1 2 1 1 3 1 2 2 4 1 3 7 1 8 0 7 6 5 1 5 1 8 5 3 3 1 1 1 3 1 3 1 6 0 6 6 3 1 6 3 6 2 2 1 3 1 1 1 7 0 9 9 1 6 8 3 9 3 4 8 1 1 1 1 1 1 2 1 3 2 3 2 3 1 3 5 1 8 0 6 3 3 9 1 1 6 3 3 2 1 1 1 2 3 1 8 0 6 6 1 5 8 5 6 3 1 1 3 2 1 1 1 1 9 0 10 5 1 1 9 7 4 6 1 2 3 1 1 2 3 3 1 1 1 1 2 3 2 3 5 4 4 6 2 1 5 3 3 5 1 6 0 7 3 4 8 6 2 1 1 3 1 3 1 1 1 1 7 0 11 9 5 2 8 9 7 3 6 9 1 8 2 2 1 1 2 1 1 1 5 0 11 2 5 8 1 9 7 7 9 1 7 8 1 3 3 1 3 2 1 5 3 3 3 4 1 5 0 6 1 6 1 3 3 9 3 2 2 1 1 1 6 0 11 7 1 5 1 4 8 7 9 9 5 9 1 3 2 1 3 2 1 7 0 9 7 2 4 5 1 2 1 5 3 1 1 1 2 1 3 3 1 2 3 5 3 4 1 6 0 9 2 8 2 2 1 1 8 5 8 3 1 2 2 2 2 1 9 0 9 8 6 2 7 5 8 8 1 4 2 3 2 2 1 3 2 1 2 1 5 0 10 2 1 9 9 4 6 9 1 6 6 2 1 1 3 2 4 2 4 1 3 6 1 5 0 8 1 8 1 9 7 8 9 1 3 1 1 2 2 1 7 0 9 3 4 6 7 2 1 6 5 4 3 1 3 1 1 2 1 1 6 0 9 2 8 9 3 3 8 1 8 5 2 1 1 2 1 2 5 5 1 3 2 5 3 6 1 9 0 10 2 7 8 5 2 4 2 1 3 1 2 1 1 3 1 1 3 1 2 1 6 0 6 7 2 3 4 1 9 3 1 1 1 1 1 1 9 0 8 9 1 4 2 7 4 6 3 2 3 3 3 1 3 1 1 1 2 2 5 3 3 5 5 2 7 5 5 5 7 2 5 3 3 4 1 5 0 7 1 6 6 1 9 2 2 3 1 3 1 2 1 5 0 10 7 1 2 8 1 1 1 6 4 4 1 1 2 3 1 1 8 0 7 6 9 1 1 4 1 5 1 3 3 2 2 2 1 1 1 2 3 3 3 6 1 7 0 7 5 6 1 8 4 4 7 3 2 1 1 1 3 3 1 7 0 8 1 6 2 3 3 6 4 3 1 2 2 1 1 2 1 1 9 0 6 9 5 1 1 3 9 1 1 3 1 3 1 3 3 1 4 3 3 3 3 3 3 7 1 9 0 9 4 2 5 7 2 2 1 2 4 1 3 3 3 2 2 1 1 2 1 9 0 10 9 2 2 5 5 8 1 9 3 7 1 2 1 1 3 1 1 1 1 1 6 0 7 7 8 2 6 7 1 4 1 1 3 1 3 1 3 4 3 2 4 5 4 3 7 1 5 0 11 5 6 9 6 1 3 4 5 8 2 1 3 3 2 3 1 1 5 0 8 2 7 8 9 6 2 1 7 1 3 1 2 3 1 5 0 7 7 1 1 6 1 9 3 1 1 1 2 1 5 3 1 3 1 1 3 3 6 1 9 0 10 1 7 9 9 7 4 7 2 4 1 2 2 2 3 1 2 2 2 3 1 9 0 8 4 4 4 5 4 2 7 1 3 1 1 1 3 1 2 3 1 1 8 0 6 9 3 8 8 8 1 1 2 2 3 2 2 1 3 2 3 5 3 3 2 6 2 2 5 4 3 6 1 9 0 10 2 5 9 6 1 9 1 6 9 5 1 2 3 1 2 1 2 3 2 1 7 0 11 1 1 3 8 2 6 9 2 1 4 7 1 2 3 1 3 3 1 1 7 0 9 6 9 4 1 7 6 1 2 9 2 3 3 3 2 3 1 2 1 2 1 5 3 3 7 1 7 0 10 1 2 8 7 9 2 9 5 9 4 2 1 1 1 3 3 3 1 5 0 7 9 3 3 8 9 7 1 1 3 2 1 2 1 7 0 11 7 6 1 5 8 7 2 3 6 1 1 3 3 3 1 1 2 1 1 5 3 1 1 3 2 3 5 1 8 0 11 6 7 6 8 6 9 7 8 1 6 5 3 3 3 3 2 1 3 2 1 5 0 7 8 7 8 4 5 4 1 1 3 2 2 1 1 8 0 6 2 9 2 4 9 1 3 2 2 2 1 3 2 3 2 3 2 3 4 3 5 1 5 0 11 6 7 5 2 4 1 2 3 1 3 2 2 1 1 1 1 1 7 0 11 5 2 2 8 1 5 1 7 1 4 1 1 1 2 2 3 2 1 1 8 0 11 2 8 2 6 7 9 9 5 1 9 4 1 2 3 1 1 1 2 3 2 4 1 2 3 3 4 1 8 0 9 2 1 8 6 8 4 7 5 3 2 1 3 1 3 2 1 2 1 5 0 7 3 4 7 4 3 4 1 3 2 1 3 2 1 6 0 9 7 1 1 7 7 2 7 6 2 3 1 2 2 3 1 4 3 3 4 5 3 6 4 4 4 3 7 1 5 0 11 1 4 2 6 3 9 9 8 7 1 9 3 1 1 1 3 1 5 0 7 4 3 1 9 8 1 4 2 1 2 3 2 1 9 0 8 1 6 5 6 6 2 8 1 1 2 2 1 3 2 2 1 3 3 3 4 1 5 2 3 3 6 1 7 0 11 1 1 3 3 2 3 3 6 6 1 1 3 1 2 1 1 3 2 1 6 0 11 2 6 1 8 1 3 2 6 5 5 2 1 3 3 1 3 3 1 8 0 7 3 9 5 2 9 4 1 1 3 3 2 2 1 3 3 3 3 1 2 5 3 3 5 1 8 0 8 6 2 3 6 5 4 8 1 3 3 2 1 1 1 3 2 1 7 0 10 2 9 2 9 5 1 1 1 3 6 1 1 1 2 1 2 1 1 9 0 7 9 2 1 1 7 1 7 1 1 2 2 2 3 2 3 1 1 2 2 3 4 3 5 1 8 0 9 7 1 6 1 9 4 1 8 5 2 3 3 2 1 2 1 1 1 5 0 8 1 5 5 5 2 4 6 2 2 1 2 1 1 1 8 0 8 3 9 9 1 6 2 1 8 3 2 2 2 1 3 2 3 5 1 2 4 2 1 2 3 4 5 4 3 5 1 8 0 8 4 6 4 1 4 4 9 7 3 1 2 3 1 2 1 1 1 6 0 10 1 5 1 6 3 2 5 1 8 8 1 1 3 1 3 2 1 8 0 11 2 1 5 7 8 2 3 8 5 7 5 1 2 1 2 2 3 3 2 3 4 3 4 3 3 6 1 9 0 9 1 3 3 9 3 6 3 1 9 3 1 1 1 1 1 1 2 3 1 5 0 10 2 7 6 6 2 6 7 1 8 4 1 2 2 3 2 1 9 0 6 8 8 5 9 9 1 3 2 2 1 1 3 1 1 3 2 1 4 3 4 5 3 5 1 5 0 8 8 5 1 8 6 3 2 3 1 1 3 1 3 1 7 0 6 9 7 6 9 4 1 1 1 1 3 3 3 1 1 9 0 11 9 1 6 6 6 7 9 5 3 1 1 3 1 2 1 2 1 2 3 1 3 5 3 1 4 3 7 1 8 0 9 6 2 1 4 3 7 9 9 5 2 1 1 3 1 3 1 3 1 7 0 9 1 3 2 3 8 5 3 5 3 1 2 3 1 3 2 1 1 7 0 8 5 7 7 6 1 3 6 2 1 3 1 3 1 3 1 3 5 2 3 2 4 5 3 6 1 7 0 9 1 2 5 4 4 4 6 8 5 2 3 2 3 3 1 1 1 8 0 8 6 6 4 5 1 6 8 3 1 1 2 1 1 3 1 3 1 6 0 6 1 5 7 5 3 9 3 1 1 2 1 3 3 5 3 1 3 2 4 2 6 3 5 4 3 4 1 6 0 9 4 6 8 3 2 4 2 3 1 3 1 2 2 2 2 1 6 0 7 3 4 4 9 1 7 4 3 2 3 1 2 2 1 6 0 10 1 5 1 8 6 8 6 1 1 1 2 1 3 2 1 1 2 4 3 1 3 5 1 8 0 8 6 3 1 1 5 4 7 5 3 1 1 3 3 1 1 2 1 7 0 7 5 5 1 1 7 9 6 2 1 3 2 2 1 1 1 5 0 7 9 9 1 7 2 1 1 2 1 1 1 1 4 1 1 3 1 3 6 1 5 0 10 1 4 4 9 3 1 9 8 8 7 1 2 1 1 3 1 5 0 6 2 1 1 2 9 4 2 3 3 1 1 1 8 0 8 6 9 7 3 3 5 1 7 3 3 1 1 1 3 2 1 1 3 5 4 2 3 3 5 1 9 0 11 4 4 4 8 6 3 1 8 1 8 2 2 2 2 1 1 2 2 1 1 1 6 0 6 1 9 6 7 9 7 1 1 1 2 1 2 1 5 0 9 3 1 3 6 5 1 2 4 6 1 1 1 3 3 3 5 2 2 5 3 7 1 6 0 10 3 4 9 2 1 1 3 5 4 8 2 1 2 1 1 1 1 6 0 7 6 1 3 4 1 9 3 2 2 2 1 1 2 1 7 0 11 1 6 4 3 1 8 8 4 3 6 5 1 2 1 1 1 3 3 1 4 1 5 3 5 5 7 3 2 1 4 3 3 5 1 7 0 9 9 1 8 7 7 1 5 2 1 1 2 2 3 1 1 3 1 8 0 7 5 6 2 8 5 2 1 1 1 2 2 1 3 1 2 1 9 0 6 4 7 8 1 6 2 1 1 1 1 3 1 3 3 3 4 3 3 5 2 3 4 1 5 0 8 2 5 5 1 2 2 7 8 1 3 3 1 2 1 7 0 7 6 2 3 8 3 1 4 2 3 1 3 1 2 2 1 6 0 7 2 4 8 4 7 1 2 1 3 1 2 3 3 4 5 1 1 3 6 1 6 0 10 9 7 7 1 1 3 9 3 1 4 3 1 1 2 2 3 1 7 0 11 2 1 6 4 9 8 1 8 1 6 4 3 2 1 1 3 3 1 1 8 0 10 7 7 5 1 1 6 3 1 7 3 1 2 1 1 1 2 2 1 3 5 4 1 3 2 3 7 1 7 0 11 6 5 8 4 3 6 1 2 8 6 4 1 1 1 1 3 3 2 1 9 0 8 2 2 1 7 1 8 6 7 1 1 1 3 2 3 2 1 3 1 7 0 6 1 1 4 8 9 5 1 2 2 1 2 3 3 3 5 5 3 2 3 1 2 3 3 5 3 3 4 1 5 0 8 5 1 2 5 9 4 5 2 1 3 2 3 1 1 9 0 9 8 9 9 1 5 7 6 1 4 1 1 3 3 2 3 1 1 2 1 8 0 10 3 1 1 6 5 8 4 9 1 8 1 1 2 2 1 1 1 3 5 2 4 5 3 7 1 7 0 6 8 7 8 7 1 6 2 3 2 1 3 1 3 1 6 0 11 9 9 6 1 3 5 3 3 2 7 1 1 1 1 2 1 1 1 7 0 9 9 1 3 6 8 2 5 4 1 2 1 3 3 1 2 3 4 1 2 3 4 1 3 3 5 1 9 0 8 1 6 1 3 5 1 1 9 2 2 1 1 1 1 3 1 3 1 7 0 11 2 6 5 5 5 5 6 6 1 9 1 1 3 3 3 2 1 1 1 9 0 7 1 1 1 1 6 3 1 1 2 3 3 1 2 1 3 3 4 5 1 1 4 3 6 1 5 0 9 3 1 2 9 2 9 8 8 6 1 2 2 1 2 1 5 0 10 7 1 5 1 2 7 3 9 7 7 1 2 3 3 3 1 9 0 9 4 5 9 7 6 8 2 4 1 2 1 1 1 3 1 2 3 3 1 2 2 5 4 2 3 5 1 5 0 7 4 1 3 4 5 1 3 3 3 1 2 3 1 6 0 11 7 1 9 1 5 1 1 9 6 2 2 2 1 3 1 2 1 1 5 0 8 5 9 8 1 2 6 3 9 1 2 1 1 2 3 1 5 5 4 5 5 7 3 1 7 2 5 3 3 6 1 5 0 11 9 4 3 1 9 8 8 8 4 6 3 2 3 1 1 1 1 8 0 9 4 2 2 6 1 3 5 1 9 2 3 2 1 1 2 1 2 1 5 0 9 9 5 4 2 9 9 2 1 9 3 2 3 1 3 1 2 1 5 3 4 3 5 1 5 0 7 5 8 6 1 2 8 3 1 2 1 1 2 1 5 0 7 7 5 1 6 3 6 8 1 2 2 1 3 1 5 0 7 1 8 7 2 1 7 5 2 1 1 1 1 1 3 3 3 3 3 7 1 8 0 11 1 4 3 3 9 7 6 9 1 1 9 1 1 3 2 3 3 3 1 1 5 0 8 4 2 5 8 1 3 4 6 3 1 1 2 3 1 5 0 8 1 2 2 6 1 9 2 8 1 1 2 2 1 4 2 4 4 3 3 1 3 5 1 6 0 8 7 7 2 8 1 9 9 8 1 2 1 1 3 3 1 9 0 11 4 3 7 6 2 1 1 2 1 6 2 2 3 2 2 1 3 1 2 1 1 5 0 10 4 6 8 1 5 6 8 4 6 6 1 1 2 3 2 2 5 4 2 4 3 5 1 7 0 7 8 4 8 3 7 6 1 1 3 1 2 2 2 3 1 6 0 6 3 1 5 2 7 8 2 2 2 1 3 3 1 9 0 9 4 1 4 4 1 3 2 7 4 2 2 3 2 3 2 3 1 1 4 2 4 3 1 7 4 2 5 4 3 5 1 7 0 6 7 4 1 1 8 4 1 2 3 3 3 3 2 1 6 0 7 6 3 8 1 1 4 4 1 3 1 1 2 2 1 5 0 8 8 1 1 5 2 3 2 3 3 2 1 3 3 4 5 4 2 2 3 6 1 7 0 9 4 1 1 4 9 1 2 3 3 2 1 3 2 3 3 1 1 5 0 8 7 8 1 8 4 6 3 1 1 3 1 1 1 1 9 0 7 1 2 2 7 4 7 7 1 1 3 1 2 1 1 1 1 4 2 4 2 2 2 3 5 1 5 0 11 1 6 5 4 8 9 9 2 1 5 4 1 3 3 3 2 1 9 0 11 1 8 6 3 3 5 9 7 8 7 2 3 3 1 3 1 1 2 3 1 1 5 0 6 5 9 1 3 9 2 1 1 2 1 3 5 1 3 5 4 3 5 1 8 0 7 6 1 6 7 9 3 6 2 3 1 1 3 1 3 1 1 6 0 7 2 1 3 2 7 1 4 1 2 2 1 1 2 1 5 0 8 6 1 9 9 8 4 1 4 3 1 2 2 1 5 3 2 3 1 3 4 1 9 0 10 7 5 2 1 5 8 3 6 4 9 3 3 1 1 2 3 3 3 1 1 8 0 6 3 4 5 5 7 1 3 3 1 1 1 2 2 1 1 5 0 6 1 7 6 3 5 3 1 1 1 1 3 2 3 1 2 4 2 1 4 4 5 3 4 1 7 0 10 7 9 5 4 1 1 2 8 7 5 1 1 1 3 1 1 1 1 8 0 9 1 8 6 8 1 9 6 5 6 1 1 3 1 2 2 1 2 1 6 0 7 9 1 6 8 4 9 4 1 1 3 2 3 2 2 5 4 5 3 4 1 9 0 7 4 7 2 8 5 1 5 2 2 1 3 1 1 3 1 2 1 8 0 7 4 8 5 3 9 6 1 1 2 2 2 3 1 1 2 1 6 0 9 2 6 1 5 8 3 5 9 7 3 2 1 3 1 2 3 3 2 2 3 5 1 8 0 6 8 1 9 3 1 9 1 1 1 2 1 2 3 1 1 5 0 7 7 8 8 8 4 1 1 1 2 3 1 1 1 6 0 7 5 6 9 1 1 9 1 3 2 1 1 2 1 1 5 3 2 3 3 7 1 7 0 6 1 6 1 6 9 4 1 2 1 1 3 1 2 1 6 0 10 2 5 8 7 4 1 2 2 4 8 3 3 2 1 3 2 1 6 0 7 7 2 1 6 5 7 1 1 1 1 1 3 2 5 3 2 2 5 2 3 6 6 6 4 3 5 4 3 4 1 5 0 7 5 6 5 1 7 1 9 3 3 2 2 1 1 8 0 7 9 2 5 1 8 9 1 1 3 1 2 1 3 1 3 1 5 0 11 6 4 1 6 7 6 4 1 4 1 1 3 2 1 3 3 1 2 5 3 3 6 1 8 0 11 8 7 6 8 3 1 3 6 7 1 2 3 2 2 1 1 2 3 2 1 6 0 6 3 1 3 1 1 3 1 2 2 1 2 3 1 9 0 9 1 1 6 1 2 6 4 8 2 1 3 1 3 2 2 1 1 2 3 3 3 1 2 4 3 7 1 5 0 10 7 3 8 1 8 1 1 5 5 1 3 1 2 1 2 1 8 0 9 1 3 1 7 4 9 9 3 1 2 1 3 3 1 3 1 3 1 6 0 7 7 5 8 9 1 8 5 2 2 1 1 3 3 4 1 4 3 4 4 2 3 7 1 9 0 9 9 1 1 8 2 1 6 5 5 3 1 2 2 1 1 2 1 3 1 8 0 10 9 8 2 7 1 4 3 8 2 6 3 3 2 2 1 1 1 1 1 6 0 9 3 5 8 6 9 3 7 7 1 2 3 1 1 2 2 2 3 1 2 4 4 5 3 4 1 8 0 10 5 1 5 1 9 2 1 3 6 7 3 2 2 1 3 3 3 2 1 8 0 8 6 5 9 9 1 3 4 3 2 1 1 3 3 1 1 3 1 9 0 9 2 1 3 7 5 1 3 4 2 1 1 3 1 1 1 1 1 2 2 1 4 1 5 7 4 1 5 5 3 5 1 7 0 9 8 4 2 6 1 1 2 1 7 2 1 3 2 1 1 3 1 8 0 10 9 1 1 9 8 2 4 4 5 7 3 2 2 1 1 2 3 1 1 5 0 11 9 3 1 9 8 5 6 1 4 3 5 1 1 3 2 1 4 1 3 4 5 3 7 1 7 0 10 9 6 9 1 9 1 3 8 2 5 3 2 2 2 2 2 1 1 5 0 9 5 8 3 1 2 1 5 9 3 3 2 1 3 2 1 9 0 8 1 4 9 3 4 1 1 8 1 2 1 1 2 1 2 1 3 2 3 3 4 4 4 3 3 5 1 9 0 10 9 5 6 6 3 6 1 7 2 1 1 3 1 2 2 1 2 2 3 1 9 0 7 4 1 7 2 9 8 7 2 3 1 2 1 1 3 3 3 1 8 0 9 2 4 1 6 8 8 4 5 6 1 3 2 2 3 2 3 1 3 2 4 3 2 3 7 1 5 0 9 8 1 6 1 6 6 8 5 7 1 1 1 1 1 1 8 0 7 1 5 2 5 5 5 4 2 1 2 2 3 1 3 3 1 6 0 6 8 7 1 6 1 1 1 2 1 1 2 1 2 3 2 4 2 3 1 3 4 1 8 0 10 6 1 5 4 6 9 4 2 4 7 1 2 2 2 1 2 1 3 1 9 0 6 8 1 1 2 8 3 1 3 2 3 2 2 1 3 3 1 7 0 10 4 7 9 1 3 4 9 1 2 5 1 3 1 1 2 3 2 2 2 3 1 5 4 4 6 1 5 3 3 5 1 9 0 7 8 1 6 2 4 9 4 2 3 3 3 3 1 1 1 2 1 7 0 9 9 7 1 5 1 4 7 2 4 1 2 3 1 3 1 2 1 6 0 8 3 1 9 8 7 1 1 4 2 3 2 1 2 2 5 5 2 1 1 3 4 1 7 0 8 8 1 9 9 8 3 6 5 3 2 1 1 3 3 3 1 9 0 7 2 5 6 4 1 6 1 3 1 1 3 3 3 3 1 2 1 7 0 7 3 3 2 2 1 7 1 1 1 1 2 3 2 2 3 5 5 2 3 7 1 6 0 6 4 1 8 5 1 2 1 1 2 1 2 1 1 9 0 10 8 5 2 9 1 1 9 6 1 5 2 3 2 3 2 1 1 2 1 1 6 0 10 1 7 6 9 8 1 3 1 5 2 2 3 1 1 3 3 3 1 3 3 1 1 5 3 5 1 9 0 11 1 9 2 6 5 8 6 6 1 5 4 2 2 2 3 3 2 1 2 2 1 9 0 11 7 3 4 8 1 3 3 1 8 8 9 3 1 1 1 3 1 2 2 3 1 9 0 7 1 4 5 8 6 1 2 1 3 2 3 1 3 2 2 1 3 2 3 1 2 3 5 1 5 0 6 9 7 6 1 8 8 2 2 1 3 2 1 6 0 10 8 8 1 3 1 1 1 6 2 2 1 3 3 2 3 2 1 6 0 8 3 8 9 1 1 1 1 2 2 3 1 1 2 1 2 3 1 1 3 2 3 4 5 3 3 4 1 7 0 7 9 4 1 3 1 9 8 1 1 2 3 1 2 2 1 5 0 6 1 3 8 8 7 4 1 3 3 3 3 1 6 0 7 5 1 4 5 3 7 1 3 1 1 2 1 1 3 3 1 3 3 7 1 6 0 6 6 8 4 3 1 1 1 3 1 1 1 1 1 9 0 8 8 1 4 4 1 9 2 6 2 2 3 1 2 1 2 3 3 1 8 0 11 9 2 9 3 8 1 8 1 7 3 5 1 1 1 3 1 1 2 1 3 2 1 4 2 3 2 3 4 1 8 0 9 4 1 1 5 2 3 6 6 1 1 2 1 1 1 2 3 2 1 7 0 6 1 8 7 9 8 9 3 3 1 3 2 2 1 1 8 0 6 3 7 1 3 4 4 2 3 2 1 1 3 1 3 2 5 5 3 3 6 1 5 0 11 3 9 7 5 1 9 5 4 9 3 9 2 1 1 2 2 1 8 0 9 1 5 8 4 1 3 3 3 1 1 1 1 1 1 2 3 1 1 9 0 11 1 6 2 6 6 4 2 1 5 5 7 1 2 2 3 1 1 1 1 1 4 3 4 3 2 2 3 4 1 8 0 9 7 4 3 8 9 1 2 6 6 2 1 3 1 2 2 1 3 1 7 0 8 1 1 1 3 3 1 9 3 1 3 1 1 2 3 1 1 5 0 8 2 1 4 1 4 1 6 2 1 1 1 1 1 2 2 5 5 5 3 2 1 7 7 2 5 4 3 6 1 5 0 7 3 1 1 1 7 3 3 2 1 2 1 2 1 9 0 10 9 1 9 9 7 1 4 2 8 3 3 1 3 3 3 3 2 1 2 1 9 0 11 4 8 7 1 5 5 9 3 1 6 2 3 3 1 3 2 3 1 2 3 1 1 1 1 2 3 3 4 1 9 0 6 1 2 2 9 9 8 3 2 1 2 2 3 3 1 2 1 6 0 11 9 4 7 1 4 5 2 1 4 5 1 1 2 3 2 3 2 1 9 0 9 4 1 6 1 1 2 7 4 3 1 3 2 3 2 2 1 3 2 3 3 2 1 3 5 1 8 0 7 6 8 1 1 1 6 5 1 1 3 2 2 2 3 2 1 7 0 8 9 9 7 4 1 9 7 1 1 1 1 2 2 2 2 1 7 0 8 3 6 4 1 9 5 2 3 3 1 2 2 1 2 2 2 1 3 2 3 3 7 1 9 0 9 4 4 1 7 8 7 7 1 9 1 1 1 2 1 3 2 1 3 1 5 0 6 1 7 6 7 3 9 3 3 1 3 1 1 9 0 10 2 1 8 5 3 2 9 1 5 9 3 1 2 3 1 2 1 3 1 5 1 4 4 5 1 3 3 7 1 7 0 7 5 4 4 3 1 2 5 3 1 2 2 1 3 1 1 9 0 8 3 2 1 1 9 8 8 9 1 1 1 2 1 1 2 3 1 1 7 0 11 4 1 8 6 1 7 1 7 7 9 6 1 1 3 2 1 3 1 4 1 2 2 1 1 2 2 6 4 4 5 5 3 4 1 7 0 10 4 1 2 9 2 1 6 2 1 8 3 1 1 1 3 3 3 1 5 0 7 2 9 2 5 2 1 4 2 3 3 1 1 1 6 0 7 5 8 7 4 1 7 1 3 1 1 3 1 2 3 5 2 1 3 4 1 9 0 9 9 1 5 5 3 4 9 1 7 2 2 2 2 1 2 1 1 1 1 6 0 10 9 5 5 6 1 8 1 9 4 9 1 1 1 2 2 2 1 8 0 8 5 1 6 9 1 5 1 5 1 3 2 1 1 2 1 3 1 1 2 4 3 5 1 5 0 7 2 1 7 5 4 1 1 1 2 3 3 1 1 5 0 7 4 1 6 8 5 9 9 3 2 1 3 2 1 9 0 8 5 9 4 5 5 8 2 1 2 2 3 1 1 1 3 3 2 1 3 1 2 2 3 4 1 6 0 7 3 3 4 8 1 4 8 2 1 3 3 1 3 1 9 0 10 5 9 1 6 1 4 5 3 3 9 1 1 3 1 2 3 2 1 3 1 9 0 7 7 8 4 5 1 7 4 1 2 2 1 1 2 2 2 3 4 2 1 3 3 7 1 8 0 10 2 1 6 1 8 4 5 8 4 6 2 2 2 1 1 1 3 2 1 7 0 11 9 3 9 4 1 6 5 1 5 7 3 1 1 1 1 3 1 2 1 7 0 7 8 9 9 9 4 7 1 3 1 2 3 2 1 1 1 5 3 2 3 3 4 3 2 4 1 5 5 3 3 4 1 7 0 7 6 2 8 6 4 1 9 3 3 1 1 1 2 2 1 9 0 11 9 8 3 9 1 3 2 8 4 1 4 2 1 2 1 2 2 3 2 2 1 9 0 10 7 5 7 1 6 1 1 8 1 6 1 2 1 3 1 2 2 1 3 2 2 4 3 3 4 1 7 0 9 8 5 4 3 6 4 4 1 5 1 2 2 2 2 3 3 1 9 0 7 9 4 4 4 9 2 1 2 3 3 3 2 3 3 1 3 1 6 0 6 1 7 3 8 4 9 2 3 2 3 1 1 4 3 1 1 3 5 1 7 0 7 3 1 1 1 8 2 7 2 3 1 2 2 1 3 1 7 0 10 3 4 1 1 1 5 7 5 6 1 1 1 1 2 3 2 3 1 6 0 6 3 5 1 5 5 1 1 1 3 1 2 1 3 2 3 5 3 3 4 1 6 0 7 1 4 7 1 1 4 9 1 2 3 2 2 3 1 8 0 8 6 2 6 9 1 5 1 1 1 3 3 3 3 3 2 3 1 7 0 10 2 4 2 1 2 6 1 3 1 9 2 2 2 3 1 2 3 2 3 2 5 3 6 1 9 0 7 6 1 8 8 1 9 3 1 1 1 2 3 3 2 1 3 1 5 0 11 1 8 3 5 7 8 8 5 6 6 8 2 2 1 1 3 1 7 0 6 5 2 1 9 8 8 2 1 1 1 1 3 1 1 4 3 1 1 4 2 4 6 5 3 3 5 1 9 0 6 9 8 1 7 4 6 3 1 1 2 1 1 1 3 3 1 5 0 9 4 3 6 5 9 7 5 1 2 1 3 2 3 2 1 8 0 6 1 5 7 2 4 4 2 2 1 1 3 2 2 3 1 4 1 5 3 3 7 1 8 0 8 8 6 4 6 7 3 4 1 1 3 1 1 1 2 3 1 1 6 0 6 6 1 5 6 1 5 1 2 1 1 1 2 1 8 0 7 9 7 8 9 8 4 1 3 2 3 3 1 3 3 3 2 4 5 4 3 3 5 3 5 1 6 0 9 1 3 2 4 3 8 9 2 8 1 1 3 3 3 2 1 5 0 10 1 4 3 5 6 1 8 7 4 1 1 3 2 3 3 1 8 0 8 3 6 5 1 7 5 3 4 2 3 3 2 1 1 2 3 1 1 1 2 1 3 7 1 7 0 11 3 1 1 5 3 2 3 4 5 4 9 1 1 3 2 2 3 2 1 8 0 10 1 5 6 5 9 7 9 5 5 6 1 1 3 1 2 2 3 2 1 8 0 6 8 6 1 8 6 8 2 1 1 2 3 3 2 2 3 4 4 3 2 1 1 3 7 1 9 0 7 9 1 5 9 8 3 1 1 1 1 3 2 1 3 2 2 1 5 0 11 1 4 7 3 7 2 4 2 6 4 7 1 3 2 1 2 1 7 0 11 8 5 4 2 1 1 5 3 5 2 6 1 1 2 3 1 3 1 3 4 1 3 5 5 3 4 2 6 5 5 3 6 1 8 0 9 6 6 9 1 3 4 1 8 6 1 1 3 1 2 2 3 3 1 7 0 7 1 5 3 8 9 1 2 2 3 1 2 1 2 1 1 8 0 7 2 1 2 2 6 5 5 3 3 1 2 2 1 1 2 3 2 2 5 4 1 3 4 1 9 0 10 6 7 4 1 7 1 8 4 3 3 3 1 1 3 1 1 3 2 3 1 7 0 9 5 2 2 6 1 4 1 4 2 2 1 2 1 3 2 1 1 5 0 9 5 9 1 4 2 6 1 9 3 2 3 1 1 3 5 1 2 5 3 6 1 6 0 9 3 8 4 9 1 5 8 7 6 2 3 3 1 3 1 1 9 0 6 8 4 5 5 1 9 1 1 1 3 1 1 1 1 1 1 9 0 10 1 4 1 3 4 3 4 2 3 3 2 1 1 3 2 1 2 1 1 4 1 5 4 2 1 3 4 1 9 0 6 5 8 1 1 2 4 1 3 2 2 2 1 1 2 2 1 9 0 6 2 2 9 5 5 1 2 3 1 3 2 2 2 3 3 1 7 0 11 4 1 8 3 5 1 1 2 4 7 7 3 2 1 1 2 3 2 2 4 2 3 3 5 1 6 0 7 1 9 3 5 5 2 1 1 3 3 1 3 1 1 8 0 10 9 3 5 1 6 4 4 4 9 4 3 2 2 1 1 1 1 3 1 7 0 6 5 4 1 1 8 2 3 1 1 2 1 1 3 5 1 4 3 2 3 6 5 2 5 5 4 3 7 1 7 0 9 1 7 1 7 5 3 5 7 7 3 3 1 2 2 3 2 1 8 0 11 2 6 1 9 6 2 6 2 8 7 1 3 3 2 1 3 1 2 2 1 6 0 11 1 4 8 7 2 5 2 6 4 3 4 2 1 1 1 2 2 2 3 5 5 3 3 1 3 5 1 7 0 6 8 4 1 8 4 1 1 1 3 2 1 1 3 1 6 0 10 3 6 7 1 8 7 7 1 4 3 3 3 1 1 1 1 1 8 0 7 2 9 1 1 6 8 8 2 1 2 2 1 1 1 2 2 1 2 2 1 3 5 1 5 0 9 1 2 4 9 7 1 3 4 9 1 3 2 2 1 1 8 0 9 8 4 8 5 9 7 5 9 1 3 2 3 1 3 2 3 1 1 5 0 10 4 9 9 2 2 1 5 1 9 2 2 2 2 2 1 3 4 2 2 4 3 4 1 7 0 9 7 7 4 4 8 1 7 9 1 3 3 1 1 1 3 3 1 5 0 6 1 1 4 5 3 4 1 2 3 2 1 1 5 0 11 4 7 5 4 7 1 5 1 6 2 5 1 2 2 3 1 1 2 2 4 3 6 1 5 0 11 6 1 7 4 2 9 9 1 4 9 8 1 1 3 3 3 1 7 0 7 6 6 1 1 5 8 1 1 3 1 3 1 1 2 1 7 0 6 1 1 4 8 2 7 1 2 2 3 3 2 1 3 2 2 1 2 2 1 3 4 4 4 5 3 6 1 7 0 6 6 8 1 2 3 5 1 2 1 1 1 1 2 1 7 0 6 2 6 9 8 2 1 3 2 1 2 1 1 1 1 6 0 11 6 5 1 1 4 7 2 5 5 2 6 2 1 1 1 2 1 5 2 3 4 2 5 3 6 1 5 0 7 2 1 5 6 4 8 1 2 2 1 1 2 1 6 0 8 1 3 3 7 8 7 1 4 1 1 3 3 1 1 1 6 0 6 3 8 4 9 9 1 2 2 1 3 3 3 4 4 1 2 1 1 3 6 1 8 0 7 2 1 7 1 2 4 4 3 3 1 2 3 1 2 1 1 8 0 11 7 5 6 5 1 2 9 7 8 1 3 1 3 2 2 3 3 3 1 1 8 0 7 1 2 6 3 1 4 9 1 1 2 1 1 2 3 3 2 3 2 5 2 3 3 7 1 7 0 7 7 1 9 7 8 8 9 3 3 3 1 1 3 3 1 5 0 6 6 3 1 5 7 2 1 2 3 1 3 1 5 0 6 4 5 8 1 9 1 1 2 3 2 1 2 1 4 4 2 1 2 3 2 5 2 1 5 5 7 2 5 5 3 6 1 8 0 7 1 3 1 9 4 8 6 3 1 2 2 2 1 1 3 1 7 0 8 1 7 5 9 2 5 5 8 1 2 1 3 3 3 3 1 6 0 8 8 1 8 2 9 9 9 5 1 3 2 1 3 1 3 5 1 4 2 3 3 5 1 8 0 8 5 1 4 2 2 4 3 1 3 1 2 3 3 1 1 3 1 9 0 10 1 1 1 8 7 2 5 1 4 1 2 3 1 2 1 1 1 3 1 1 6 0 6 1 3 3 4 6 9 1 3 1 1 2 3 1 3 4 5 2 3 5 1 6 0 6 3 2 4 4 9 1 1 3 1 1 2 1 1 9 0 6 8 2 1 3 8 2 1 3 3 1 1 1 1 1 2 1 6 0 11 1 9 6 4 2 1 6 5 4 3 7 3 1 3 3 3 1 1 5 5 2 2 3 6 1 5 0 11 3 1 7 6 4 7 3 3 9 8 5 1 2 1 2 2 1 7 0 7 7 6 3 8 3 1 4 1 1 3 1 1 2 3 1 7 0 11 1 9 7 3 5 6 8 6 3 9 4 1 1 3 1 1 1 2 1 3 1 5 1 4 3 7 1 6 0 9 8 7 4 2 4 5 7 1 8 1 1 3 1 1 2 1 5 0 6 7 1 1 6 3 1 2 1 1 2 2 1 6 0 11 1 9 5 7 1 4 1 5 7 3 4 1 2 1 2 1 1 3 1 5 5 1 4 4 5 5 2 7 3 4 4 3 6 1 8 0 8 6 5 1 8 5 5 1 8 2 3 3 1 2 1 1 3 1 9 0 11 7 1 6 2 6 5 3 3 1 2 1 1 2 1 1 2 1 3 3 2 1 9 0 10 2 1 2 7 2 1 7 6 4 4 3 1 1 2 1 1 2 1 1 1 3 3 1 2 2 3 6 1 7 0 6 4 9 6 8 3 1 1 2 3 1 2 1 2 1 7 0 8 2 4 8 1 3 2 1 5 3 1 2 1 3 1 2 1 7 0 10 1 5 6 6 4 5 4 2 4 9 3 2 3 1 1 1 1 2 3 5 5 3 4 3 5 1 5 0 6 5 8 1 3 1 2 1 1 1 1 3 1 9 0 7 4 7 6 2 7 1 9 2 2 2 2 1 1 1 1 2 1 7 0 6 7 8 1 1 2 1 2 3 1 1 3 2 3 1 4 2 4 3 3 4 1 9 0 6 4 4 1 2 4 6 3 3 3 3 1 2 3 1 1 1 6 0 8 1 3 8 2 1 7 1 6 2 3 3 1 1 2 1 9 0 10 9 5 2 1 6 9 1 9 8 2 2 2 1 2 1 2 1 1 3 1 5 3 1 2 3 5 2 5 4 3 4 1 5 0 9 5 4 8 3 6 2 3 1 1 2 1 1 1 3 1 7 0 11 7 4 3 7 1 6 2 1 5 5 7 2 3 3 1 2 1 2 1 7 0 6 8 1 7 1 4 6 2 2 3 1 3 1 2 3 3 1 3 3 5 1 8 0 11 3 3 6 1 7 1 1 1 6 5 2 1 1 1 3 2 3 3 3 1 8 0 6 1 2 4 8 6 2 2 2 3 3 2 1 1 2 1 5 0 8 1 1 6 2 8 3 1 7 1 1 3 1 1 4 5 1 2 2 3 7 1 7 0 10 1 5 9 5 6 1 1 3 8 6 1 3 3 1 2 3 1 1 8 0 10 7 7 7 1 9 7 3 9 2 1 3 1 2 2 2 1 1 2 1 5 0 9 6 9 1 9 6 7 5 7 1 3 2 3 1 3 1 4 3 4 4 2 4 3 6 1 6 0 11 2 5 2 7 1 8 1 7 7 2 6 1 1 1 3 1 2 1 9 0 6 3 4 3 9 1 1 1 1 2 3 3 1 1 1 1 1 9 0 8 4 3 4 9 1 3 3 4 3 1 1 2 3 3 2 3 1 3 1 5 5 3 1 3 7 1 5 0 6 3 9 1 2 3 7 1 1 3 3 1 1 7 0 7 2 1 6 4 4 1 4 3 2 2 3 1 1 3 1 7 0 8 3 4 2 8 8 2 9 1 3 1 2 2 2 1 1 4 4 2 3 5 5 3 1 6 3 1 4 3 3 7 1 9 0 9 8 1 8 9 5 5 5 9 8 3 2 1 2 2 1 1 2 3 1 8 0 9 2 9 4 6 2 5 6 1 3 2 1 1 2 1 3 2 1 1 5 0 10 1 1 4 8 8 3 3 6 2 7 1 2 3 3 1 4 1 5 3 4 2 2 3 7 1 5 0 8 4 8 7 1 8 9 7 7 3 2 1 1 3 1 6 0 7 1 5 5 4 8 3 7 3 2 2 1 2 2 1 6 0 8 8 7 1 2 5 6 9 9 1 3 1 2 2 1 5 3 1 1 2 2 2 3 6 1 7 0 11 2 8 2 8 1 1 5 2 8 3 5 1 1 3 2 1 2 1 1 7 0 7 1 3 3 7 6 6 3 2 2 1 3 3 2 3 1 7 0 8 8 2 1 8 3 3 2 6 3 1 3 1 3 1 2 3 2 2 1 1 3 3 6 1 8 0 7 1 5 6 1 9 6 3 2 2 2 1 1 2 1 3 1 5 0 10 5 1 9 1 5 3 4 3 3 5 2 1 3 1 3 1 9 0 10 7 6 4 2 9 6 1 5 9 4 1 1 3 2 1 3 1 2 1 5 1 3 5 4 4 3 5 1 4 3 3 5 1 8 0 8 7 3 5 8 3 3 1 3 2 2 2 2 3 1 1 3 1 5 0 9 5 1 3 9 1 3 1 4 3 2 2 1 1 3 1 6 0 10 6 1 7 1 1 1 7 1 1 4 3 1 2 1 1 2 1 4 3 2 3 3 4 1 9 0 6 9 1 1 4 8 1 2 3 2 1 1 1 3 1 1 1 8 0 10 2 2 4 1 1 1 7 8 2 7 3 1 3 3 3 3 1 3 1 9 0 11 4 4 9 2 7 1 7 1 9 1 6 1 1 1 2 3 2 2 2 1 2 5 1 3 3 5 1 8 0 6 9 5 1 1 6 9 2 3 3 3 1 1 2 1 1 7 0 8 8 4 6 2 3 1 5 1 2 1 3 1 1 2 1 1 9 0 7 9 7 8 1 1 8 2 2 2 3 1 1 1 2 2 3 2 3 5 5 2 3 6 1 9 0 6 9 2 4 1 6 8 3 2 2 1 1 1 1 2 2 1 7 0 10 1 3 6 1 2 2 8 2 9 9 2 1 3 2 3 1 3 1 8 0 9 7 6 6 9 4 1 9 7 4 1 1 2 1 3 2 3 1 1 4 2 4 5 4 3 1 3 5 3 3 7 1 7 0 6 9 1 4 9 3 2 2 3 3 1 1 2 3 1 9 0 11 9 3 4 6 1 7 2 3 2 6 4 1 3 1 2 1 2 1 2 2 1 6 0 10 6 8 1 8 6 8 2 5 6 9 3 3 3 2 2 1 2 4 4 4 3 4 1 3 6 1 8 0 6 1 9 3 1 1 1 3 2 1 2 1 1 3 1 1 7 0 11 5 8 7 1 1 6 6 3 2 3 1 1 2 1 1 2 1 1 1 9 0 8 3 7 2 5 5 1 8 9 1 3 1 3 3 3 2 3 1 3 3 4 1 4 3 3 4 1 7 0 10 2 8 1 9 4 2 7 1 8 1 3 1 1 1 1 2 1 1 8 0 9 2 9 1 5 5 2 1 9 5 3 2 3 2 1 2 2 3 1 9 0 8 4 6 1 1 8 1 5 6 2 1 1 2 1 1 1 3 1 5 1 4 3 3 7 1 6 0 11 2 4 5 5 1 4 3 3 1 8 5 1 2 1 1 3 1 1 9 0 11 9 6 4 8 2 2 1 5 3 4 1 2 3 1 1 1 3 1 1 2 1 5 0 9 1 3 2 5 9 1 1 9 9 1 3 1 3 2 1 2 4 1 2 5 3 3 4 1 6 0 10 5 2 6 7 1 2 3 8 1 3 1 1 2 3 3 1 1 8 0 9 1 3 9 7 7 5 1 7 2 2 1 2 1 1 1 1 2 1 6 0 10 2 1 8 7 4 1 1 2 7 2 3 2 1 1 1 2 3 1 2 2 5 2 4 4 4 3 4 1 7 0 11 9 3 8 6 6 3 1 6 3 1 1 1 3 2 3 2 1 2 1 9 0 6 1 4 8 5 9 3 2 1 1 2 3 1 2 3 3 1 5 0 8 9 8 4 1 3 9 8 2 1 1 3 1 2 5 3 5 4 3 5 1 7 0 10 2 7 2 1 5 1 2 3 1 1 1 1 1 2 1 1 3 1 7 0 8 1 1 8 6 7 6 2 1 1 1 1 1 1 1 3 1 8 0 7 7 1 4 6 1 7 5 2 2 3 1 1 3 3 1 5 3 5 5 3 3 6 1 6 0 11 2 9 1 3 1 5 9 6 8 8 5 3 2 1 1 2 3 1 9 0 7 7 7 6 1 2 7 6 1 3 3 1 2 2 2 1 2 1 9 0 7 3 7 1 6 3 1 1 2 1 2 3 1 2 3 2 3 4 4 4 1 2 1 3 6 1 9 0 7 1 9 3 1 6 5 6 1 2 2 1 1 2 1 1 1 1 5 0 9 9 4 2 1 5 3 4 7 9 3 3 2 3 1 1 6 0 10 5 8 1 6 4 9 1 8 7 3 1 2 3 1 3 2 3 1 4 4 1 2 4 4 6 4 4 5 7 3 4 5 3 4 1 6 0 6 2 6 1 8 1 4 2 3 2 1 2 1 1 7 0 11 1 7 6 5 2 5 2 2 1 4 1 2 2 1 1 3 1 1 1 9 0 11 3 6 3 4 1 1 3 5 6 6 7 1 1 2 1 3 1 3 1 2 3 1 4 3 3 5 1 9 0 11 8 1 7 1 6 6 4 5 3 4 4 2 1 3 2 3 3 3 3 2 1 5 0 10 5 2 4 8 3 1 6 2 5 8 3 2 2 2 1 1 6 0 7 6 8 1 6 6 9 7 2 2 1 3 3 2 3 5 3 5 4 3 6 1 6 0 6 8 1 7 9 1 7 3 1 2 3 1 1 1 8 0 9 3 9 2 1 3 6 9 4 6 1 2 1 1 3 2 1 2 1 8 0 6 1 2 3 8 4 6 1 1 3 2 1 2 2 1 2 4 2 1 1 4 3 5 1 6 0 7 4 9 1 2 5 9 3 1 1 3 3 2 3 1 6 0 7 1 7 9 9 4 4 1 1 3 1 2 2 1 1 5 0 9 3 1 1 9 4 2 4 2 2 3 3 3 1 3 3 2 3 1 4 6 1 5 2 2 5 5 3 6 1 6 0 9 4 8 4 1 2 1 2 8 4 1 2 1 1 2 3 1 9 0 11 1 9 2 4 7 1 4 9 3 7 7 2 2 3 3 1 2 2 2 1 1 6 0 6 5 9 4 4 1 8 2 1 1 2 2 1 4 1 5 1 3 5 3 7 1 7 0 8 1 4 5 2 1 5 3 5 3 1 2 1 2 1 1 1 9 0 9 4 4 5 1 6 1 1 1 7 1 3 3 3 3 2 3 2 1 1 5 0 7 7 1 4 1 1 4 4 3 2 1 1 1 5 2 3 1 2 4 3 3 6 1 8 0 11 5 3 5 2 5 7 4 1 4 4 5 1 3 1 1 2 3 3 3 1 5 0 6 1 3 7 4 1 3 3 2 1 1 1 1 8 0 9 4 9 2 7 5 1 4 4 1 3 3 2 1 3 3 2 3 4 5 2 1 3 4 3 6 1 5 0 10 9 7 3 1 2 5 9 1 6 8 2 1 3 1 3 1 5 0 7 1 1 4 3 1 4 1 3 1 1 1 1 1 7 0 11 1 6 1 3 4 7 9 9 5 8 8 1 1 1 1 2 3 2 1 2 4 3 1 2 3 4 1 9 0 6 1 3 8 3 1 7 1 3 1 2 1 1 1 2 3 1 7 0 11 6 7 9 3 1 8 5 1 8 6 2 1 1 3 1 2 1 1 1 5 0 7 6 1 7 8 8 9 6 1 1 1 1 2 3 5 3 4 4 2 5 3 3 5 4 3 5 1 7 0 10 8 1 4 8 9 1 8 5 1 4 1 2 1 2 1 3 1 1 9 0 6 9 6 3 3 1 2 1 1 1 3 1 1 3 3 1 1 8 0 9 4 1 1 3 2 3 3 8 4 3 1 2 3 1 3 1 2 3 4 3 3 2 3 4 1 8 0 9 8 2 1 9 9 1 5 8 3 3 3 2 1 2 1 2 1 1 9 0 6 8 7 9 4 9 1 1 2 1 1 1 1 3 1 2 1 7 0 9 1 5 2 9 4 2 6 3 2 1 1 3 2 3 2 3 3 4 1 2 3 6 1 5 0 11 8 8 7 1 6 9 1 4 7 3 1 2 3 1 1 2 1 8 0 8 3 3 4 1 2 5 4 8 1 3 1 1 3 1 1 3 1 9 0 7 5 3 2 5 1 7 6 2 1 1 2 2 3 1 3 1 5 5 2 2 4 3 3 6 1 6 0 10 5 8 1 2 2 9 3 5 7 1 1 3 1 3 3 1 1 6 0 8 6 1 2 3 9 4 7 1 1 1 1 3 3 2 1 5 0 6 6 8 3 1 2 1 2 1 2 3 1 4 3 1 3 4 2 3 7 1 9 0 9 3 8 1 9 3 2 7 2 3 1 3 2 3 2 3 3 3 1 1 5 0 7 1 2 5 9 8 2 1 3 1 1 2 1 1 7 0 6 9 2 9 3 6 1 1 2 1 3 1 1 3 2 3 3 1 2 4 1 7 6 2 3 5 4 3 4 1 5 0 10 1 9 3 2 4 3 5 8 1 2 1 3 2 3 3 1 5 0 6 1 4 9 9 5 6 1 2 1 1 1 1 5 0 9 3 8 1 2 1 2 1 8 8 1 1 2 3 2 1 1 1 3 3 4 1 9 0 7 2 2 5 6 1 5 1 3 1 1 3 2 1 1 2 3 1 6 0 10 2 4 3 7 1 3 8 1 3 8 1 1 3 1 3 1 1 5 0 7 4 8 4 2 8 1 1 1 3 3 3 3 1 3 4 2 3 6 1 6 0 7 1 5 5 1 5 1 4 1 1 3 2 3 1 1 6 0 7 5 6 5 1 1 5 5 1 2 1 1 2 1 1 9 0 8 1 7 1 9 7 5 1 4 2 3 2 2 1 3 3 1 2 3 1 2 3 5 5 3 7 1 7 0 11 4 4 1 4 6 6 1 5 1 3 3 1 1 1 1 1 1 1 1 6 0 10 5 8 1 2 9 9 2 6 5 7 1 3 3 2 3 1 1 9 0 10 1 8 7 6 9 2 4 9 8 3 2 2 3 1 2 2 3 1 1 5 3 5 1 3 1 3 3 7 1 9 0 11 6 4 7 5 5 3 1 6 3 1 5 1 1 3 2 1 3 2 1 1 1 9 0 10 4 1 6 7 8 4 4 4 8 4 1 2 1 3 1 2 2 2 1 1 7 0 7 8 7 1 8 5 4 4 1 2 2 1 1 2 1 2 4 3 1 1 5 2 4 5 3 6 5 4 3 7 1 8 0 11 9 4 5 7 6 1 1 6 7 1 1 3 1 1 1 1 2 2 3 1 6 0 7 1 5 6 5 9 5 4 1 1 1 3 3 2 1 9 0 8 3 1 5 7 5 9 2 6 1 3 1 3 1 1 2 2 2 4 5 1 1 1 3 5 3 7 1 5 0 11 2 5 9 7 2 8 1 3 9 3 3 2 1 2 1 2 1 6 0 10 5 9 9 2 4 1 7 5 1 1 1 2 3 1 1 2 1 5 0 11 1 7 3 1 7 9 5 7 4 8 7 2 2 3 1 2 4 5 4 2 1 2 5 3 6 1 8 0 9 3 1 3 9 1 7 4 4 4 3 2 2 1 1 1 3 2 1 6 0 9 6 9 2 2 2 2 6 1 7 2 2 3 3 1 1 1 5 0 6 1 1 9 3 2 6 2 2 1 1 1 2 5 5 4 2 1 3 4 1 5 0 7 4 7 1 3 1 3 6 3 3 1 3 1 1 9 0 8 7 1 1 8 5 9 9 5 3 3 1 1 1 2 3 2 2 1 6 0 11 4 4 2 1 7 1 4 4 7 3 6 1 2 2 3 3 2 3 4 3 5 3 6 1 9 0 11 5 1 4 7 4 3 9 4 4 9 1 2 3 1 1 3 2 3 3 2 1 9 0 10 6 6 1 5 7 4 4 8 4 3 3 1 1 1 1 3 3 3 3 1 8 0 8 4 4 3 8 1 1 4 1 2 1 1 2 3 2 3 2 1 3 5 4 2 1 2 5 7 3 5 4 3 5 1 8 0 8 2 4 1 3 1 5 6 4 1 1 1 2 2 3 3 2 1 7 0 8 1 7 5 4 6 9 6 1 3 1 3 1 1 1 3 1 7 0 11 4 7 7 1 3 7 3 5 2 9 3 3 2 2 1 2 2 1 3 1 4 2 1 3 7 1 5 0 6 7 1 1 1 8 1 3 1 3 3 1 1 8 0 6 1 9 9 8 2 6 1 1 2 1 2 1 3 1 1 7 0 8 7 1 3 4 6 7 8 6 2 2 2 1 1 3 1 1 4 1 1 4 5 3 3 7 1 7 0 8 6 4 8 7 4 4 1 9 2 2 2 3 1 3 1 1 7 0 11 2 3 1 9 8 6 1 9 3 3 6 1 3 1 1 2 1 2 1 8 0 9 9 1 8 7 4 7 3 5 3 3 3 1 1 3 1 2 1 2 4 1 2 5 1 2 3 6 1 8 0 11 8 4 9 3 6 7 8 3 4 1 6 1 1 2 3 3 2 1 1 1 8 0 6 4 8 6 4 9 1 1 3 2 1 3 2 2 1 1 5 0 10 1 9 6 3 7 4 5 5 7 9 1 1 1 1 1 2 5 2 2 1 1 3 5 1 7 0 9 2 8 8 9 8 1 2 6 8 1 1 1 2 3 2 1 1 6 0 6 7 1 7 6 4 2 2 3 2 1 3 3 1 6 0 7 8 7 6 6 2 2 1 2 2 1 3 2 2 3 3 1 3 4 2 5 7 4 4 4 3 6 1 6 0 9 1 7 6 3 3 6 1 4 9 2 3 2 2 1 1 1 8 0 6 8 1 5 8 8 4 1 3 3 3 2 1 1 2 1 6 0 7 1 4 9 1 1 2 4 3 1 1 1 2 1 5 1 2 1 1 1 3 5 1 6 0 7 1 1 9 1 4 6 1 1 1 3 2 1 1 1 9 0 6 5 6 1 3 7 5 1 3 3 2 2 1 2 1 2 1 9 0 10 1 6 6 3 3 8 8 2 9 5 2 3 2 1 3 2 1 2 3 1 5 1 1 4 3 4 1 8 0 6 8 1 7 5 9 9 3 3 1 1 2 2 1 1 1 8 0 10 5 1 5 2 2 2 5 8 3 3 1 3 1 1 3 3 2 3 1 9 0 7 9 5 9 1 1 6 4 3 2 1 2 3 3 1 2 1 1 4 3 3 3 4 1 5 0 6 5 8 1 5 2 8 1 2 3 2 3 1 8 0 6 1 8 4 5 6 1 2 3 1 1 3 2 1 3 1 7 0 8 5 3 1 8 8 8 1 8 3 1 1 3 3 2 2 4 1 3 4 1 5 6 3 6 2 4 6 2 5 5 3 4 1 5 0 11 3 8 2 2 5 3 7 4 2 4 1 3 1 3 1 3 1 5 0 11 9 9 4 7 7 4 7 4 1 7 9 2 1 2 3 1 1 8 0 7 2 7 6 9 1 9 4 3 1 2 1 2 3 3 2 4 2 1 1 3 7 1 9 0 7 8 5 9 7 3 1 7 1 1 1 2 3 1 1 2 2 1 5 0 7 2 8 8 6 1 9 4 2 2 3 2 1 1 5 0 6 8 1 5 9 6 7 1 3 1 3 2 4 1 3 4 4 1 2 3 4 1 8 0 6 8 6 9 1 6 3 2 1 1 1 3 1 1 1 1 9 0 8 5 7 7 4 3 1 1 8 3 1 1 2 2 3 2 2 1 1 8 0 11 5 3 6 1 4 6 7 1 2 1 5 1 1 2 1 1 3 1 1 4 3 1 4 3 4 1 6 0 7 9 8 8 6 7 1 7 1 3 3 3 1 1 1 9 0 6 2 6 1 1 9 6 2 3 1 3 2 1 1 2 1 1 5 0 9 6 5 2 1 8 8 3 2 1 1 2 1 1 1 2 2 3 1 3 4 1 8 0 10 9 4 4 9 8 7 5 7 3 1 3 1 1 2 2 1 1 2 1 8 0 11 7 1 3 1 6 8 9 8 1 8 4 1 2 3 3 3 2 2 1 1 8 0 7 1 2 1 1 7 9 2 3 2 1 1 1 2 1 1 3 1 2 4 4 4 3 2 1 5 5 3 7 1 5 0 7 9 6 4 1 1 2 5 1 3 1 2 2 1 7 0 7 9 1 7 8 8 9 7 1 1 1 2 3 3 3 1 5 0 11 4 9 1 1 9 1 2 6 3 9 4 2 1 3 3 1 1 1 2 2 5 5 3 3 6 1 9 0 6 1 3 5 9 4 1 1 1 3 2 3 2 2 3 1 1 5 0 9 4 8 9 1 1 7 3 1 8 2 1 3 1 2 1 5 0 11 9 1 5 7 7 4 2 2 6 7 9 2 2 1 2 3 4 2 1 3 3 1 3 4 1 8 0 10 4 1 2 3 7 6 5 8 3 4 1 1 1 3 3 3 1 2 1 6 0 10 9 9 6 5 1 1 7 9 3 1 2 1 2 1 2 3 1 5 0 10 5 8 4 7 2 4 8 1 1 1 1 2 1 1 3 2 2 1 3 3 6 1 7 0 9 9 7 7 2 5 7 9 1 3 1 2 1 1 2 2 3 1 5 0 6 1 9 5 3 1 5 3 3 3 1 2 1 6 0 9 6 7 1 3 5 3 3 6 5 1 1 3 1 3 2 1 3 5 2 1 3 3 5 1 5 0 8 6 9 4 1 6 3 1 6 1 2 2 1 3 1 7 0 8 7 8 3 1 5 7 3 1 1 1 2 2 3 1 3 1 6 0 7 8 1 3 9 1 3 8 3 1 3 2 1 1 2 4 1 5 1 7 7 6 4 2 4 4 3 6 1 5 0 11 1 1 4 4 2 6 6 8 9 6 3 2 1 1 1 2 1 5 0 8 5 1 4 1 9 7 2 1 2 3 3 1 3 1 6 0 8 2 1 1 5 5 9 2 2 3 1 3 1 2 3 5 3 1 5 5 2 3 7 1 5 0 10 1 8 1 1 4 3 6 6 7 1 1 2 3 1 3 1 6 0 6 6 6 3 2 1 1 2 1 3 1 3 3 1 7 0 9 5 1 4 7 7 5 1 9 7 2 3 2 3 3 1 2 2 2 4 2 2 2 3 3 5 1 9 0 10 9 1 9 8 5 5 5 1 1 5 2 3 1 2 1 1 3 3 2 1 5 0 8 1 8 2 3 1 1 1 7 1 3 3 1 3 1 5 0 9 5 6 5 9 1 1 1 4 6 3 1 3 3 3 3 4 2 4 1 3 6 1 9 0 9 6 1 2 6 3 6 4 1 9 1 1 3 3 1 2 2 2 1 1 7 0 8 1 7 1 6 1 9 2 3 1 2 3 2 3 1 3 1 7 0 8 8 5 5 9 3 1 3 1 2 2 2 1 3 3 2 2 2 2 3 5 5 1 6 4 4 5 3 3 6 1 5 0 10 8 1 4 9 5 3 2 8 2 1 3 3 3 1 3 1 5 0 8 3 9 5 8 2 4 1 1 3 2 1 1 1 1 8 0 6 1 4 7 8 3 7 2 1 2 3 2 3 2 1 4 5 1 4 2 1 3 4 1 8 0 9 1 4 5 1 8 2 3 3 7 1 1 3 2 3 3 2 1 1 6 0 7 6 1 6 5 6 9 1 3 2 1 2 2 1 1 9 0 8 1 8 9 5 4 8 6 8 3 3 2 3 1 1 2 1 1 3 4 3 3 3 6 1 6 0 8 3 9 9 4 9 1 7 5 1 2 3 2 3 3 1 6 0 11 4 4 7 1 5 6 3 2 7 3 6 2 1 1 1 1 3 1 7 0 6 9 8 1 6 8 6 2 2 3 1 1 2 1 5 2 1 2 3 4 3 7 1 8 0 9 5 4 3 5 3 9 7 7 1 2 3 2 3 1 3 1 1 1 9 0 6 5 1 4 3 3 7 3 2 2 3 1 3 1 2 2 1 5 0 10 7 9 6 9 6 1 3 6 7 9 2 1 2 3 1 4 4 2 1 2 4 4 3 5 1 7 0 8 9 1 8 4 8 9 9 4 1 2 1 2 2 3 3 1 7 0 7 5 4 1 1 7 1 7 1 2 3 3 1 2 1 1 8 0 8 8 1 6 1 7 3 1 9 2 2 3 1 1 2 3 1 1 3 1 4 5 3 5 7 5 3 3 4 1 5 0 10 3 2 6 1 1 4 1 2 6 2 1 2 1 2 2 1 9 0 7 3 1 5 4 7 1 5 1 3 1 3 3 1 3 1 1 1 9 0 6 6 1 8 6 8 7 3 1 3 2 1 1 3 3 1 1 1 1 3 3 5 1 7 0 7 7 1 5 7 4 1 5 1 1 3 1 1 3 2 1 5 0 7 1 1 2 9 8 3 7 1 2 1 1 2 1 7 0 7 2 7 1 3 2 5 2 1 3 1 3 3 1 1 4 5 5 1 3 3 4 1 5 0 8 1 6 5 3 6 6 1 2 1 1 3 2 2 1 9 0 9 6 1 2 6 1 2 1 4 7 3 3 3 1 2 3 2 2 2 1 6 0 11 9 6 3 6 6 1 2 5 2 1 7 3 1 3 3 2 3 4 5 4 2 3 6 1 8 0 9 8 1 5 7 8 8 1 3 6 3 3 3 1 2 1 2 2 1 8 0 6 5 5 1 1 3 4 1 3 3 1 2 2 3 1 1 9 0 8 8 2 2 5 4 1 5 6 3 1 1 2 2 1 1 3 2 3 2 5 2 1 5 3 7 1 6 0 10 6 5 4 7 6 1 1 8 6 6 3 3 1 1 2 3 1 6 0 11 2 2 4 7 1 6 1 6 8 9 7 2 2 2 1 1 1 1 8 0 10 3 8 3 9 1 5 8 5 7 5 3 1 2 1 3 1 1 3 2 3 1 3 4 3 5 4 3 3 4 3 3 5 1 7 0 6 5 2 2 1 1 6 2 2 2 1 3 1 2 1 7 0 6 2 2 7 4 9 1 3 2 3 3 1 3 1 1 9 0 11 8 2 7 2 2 1 6 9 6 9 1 1 3 1 1 1 2 1 2 1 1 1 3 2 2 3 7 1 9 0 11 4 6 6 9 6 6 6 3 1 4 4 1 2 3 2 1 2 3 3 3 1 5 0 6 2 8 3 4 6 1 2 2 3 1 1 1 8 0 10 8 1 1 2 9 4 3 2 9 4 1 3 2 2 1 2 1 2 5 3 5 4 5 3 4 3 6 1 5 0 7 9 1 3 4 1 4 3 3 1 2 1 1 1 8 0 10 4 9 5 4 1 1 8 6 3 7 3 2 1 1 1 1 1 1 1 5 0 8 7 8 1 9 1 6 2 7 3 3 3 3 1 1 2 2 2 3 1 3 7 1 8 0 8 4 2 7 1 7 5 7 1 1 3 1 1 2 1 2 2 1 7 0 11 9 8 7 1 7 3 1 3 3 3 6 3 1 2 2 1 1 2 1 8 0 10 1 8 1 5 6 5 6 7 3 4 1 1 1 3 2 1 1 2 3 2 5 5 5 2 3 4 5 5 8 3 2 4 8 7 3 10 6 1 1 5 4
"""
        |> Advent.removeNewlinesAtEnds


main : Program () ( Output1, Output2 ) Never
main =
    Advent.program
        { input = input_
        , parse1 = parse1
        , parse2 = parse2
        , compute1 = compute1
        , compute2 = compute2
        , tests1 = tests1
        , tests2 = tests2
        }
