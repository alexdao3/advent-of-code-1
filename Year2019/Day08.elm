module Year2019.Day08 exposing (Input1, Input2, Output1, Output2, compute1, compute2, input_, main, parse1, parse2, tests1, tests2)

import Advent
    exposing
        ( Test
          -- , unsafeToInt
          -- , unsafeMaybe
        )
import Dict
import Dict.Extra
import List.Extra



-- 1. TYPES (what is the best representation of the problem?)


type alias Input1 =
    List (List Int)


type alias Input2 =
    List (List Int)


type alias Output1 =
    Int


type alias Output2 =
    Int



-- 2. PARSE (mangle the input string into the representation we decided on)


width : Int
width =
    25


height : Int
height =
    6


parse1 : String -> Input1
parse1 string =
    let
        ints =
            String.toList string
                |> List.map charToInt
    in
    List.Extra.groupsOf (width * height) ints


charToInt : Char -> Int
charToInt char =
    -- 48 == '0'
    Char.toCode char - 48


parse2 : String -> Input2
parse2 string =
    parse1 string



-- 3. COMPUTE (actually solve the problem)


compute1 : Input1 -> Output1
compute1 layers =
    let
        layerWithLeast0Digits =
            layers
                |> List.sortBy
                    (\layer ->
                        layer
                            |> List.filter ((==) 0)
                            |> List.length
                    )
                |> List.head
                |> Advent.unsafeMaybe

        freqs =
            Dict.Extra.frequencies layerWithLeast0Digits

        ones =
            Dict.get 1 freqs |> Advent.unsafeMaybe

        twos =
            Dict.get 2 freqs |> Advent.unsafeMaybe
    in
    ones * twos


compute2 : Input2 -> Output2
compute2 layers =
    let
        transposed =
            List.Extra.transpose layers

        firstVisiblePixel : List Int -> Int
        firstVisiblePixel layer =
            layer
                |> List.Extra.dropWhile ((==) 2)
                |> List.head
                |> Advent.unsafeMaybe

        visiblePixels : List Int
        visiblePixels =
            transposed
                |> List.map firstVisiblePixel
                |> print
    in
    -1


print : List Int -> List Int
print image =
    let
        _ =
            image
                |> List.map
                    (\int ->
                        if int == 1 then
                            "#"

                        else
                            " "
                    )
                |> List.Extra.groupsOf width
                |> List.reverse
                |> List.map (String.concat >> Debug.log "")
    in
    image



-- 4. TESTS (uh-oh, is this problem a hard one?)


tests1 : List (Test Input1 Output1)
tests1 =
    [{- Test "example"
        "input"
        Nothing -- Just "parsed-input"
        -1
     -}
    ]


tests2 : List (Test Input2 Output2)
tests2 =
    []



-- BOILERPLATE (shouldn't have to touch this)


input_ : String
input_ =
    """
222222122222222202222122222022222102022222122222222001222222222221122222212222222202220222222222110222220122202222222222222222222222222222022022210222222222122222222222222122222222222002122222022222222012222222222220222222212222222222221222222222212222222122202222222222222222222222222222022022210222222222022222222202222022222122222102222222122222222202222222222222022222202222222212222222222222100222221122202222222222222222222222222222222122221222222222222222222202222022222022222112122222022222222221222222222220022222212222222202220222222222012222222022212222222222222222222222222222122222210222222222222222222202222222222022222002222222222222222220222222222221222222212222222202220222222222121222222022212222222222222222222222222222222022222222222222122222222202222222222022222212102222122222222212222222222220022222222222222022220222222222201222222122222222222222222222222222222222022122222222222222022222222202222122222222222212112222222202222012222222222221222222222222222222222222222222200222222222222222222222122222222222220222122022211222222222222222222202222022222122222202112222120202222111222222220220022222222222222112221222222222102222221222202222222222022222222222220222022122202222222222222222222212222022222222222022102222220222222220222222221220222222202222222222221222222222201222221022202222222222022222222222222222222022210222222222222222222222222122222122222012002222220202222102222222220222022222222222222202220222222222122222220122212222222222222222222222221222122222201222222222122222222202222122222122222122102222121212222112222222222220122222212222222102222222222202000222221122222222222222222222222222222222222022222222222222122222222222222022220022222002102222222222222110222222220221022222202222222012222222222222200222221122212222222222122222222222220222022222201222222222222222222202222122220222222112110222021222222111222222220221022022202222222002222222222222201222221222202222222222222222222222220222022122201222222222022222222222222022221022222002200222122202222021222222222221122022222222222222221222202202001222220022202222222222222222222222222222022122201222222222022222222202222122220022222022011222121202222021222222222222022222222222222212221222202202121022221022212222222222122222222222220222122022220222222222122222222202222020222122222121211222220202222021222222221221022222212222222002221222222212020122221222222222222222022222222222221222222222222222222222122222222222222020220122222102102222122202222021222222021222022222212222222102221222202212202222222222202222222222222222222222220222122222220222222022222222222212222020221122222110200222121222222022222222021222122222212222222102220222202212012022221222222222222222122222222222220222122022200222222022222222222202222022220222222100010222121222222022222222221221122022202222222112220222202212120222120122212222222222022222222222220222222022212222222022122222222222222222220122222021201222221202222221222222021221122022222222222002222222212222202222221022222222222222022222222222221222122222210222222022022222221212222222220122222101211222221222222010222222022222022022212222222222220222202212122022121022202222222222222222222222222222022222202222222222022222222212222220221022222222202222220212222021222222121221122222202222222002222202212222010022220122212222222222222222222222222222222122220222222222122222221222222021222022222002211222122222222220222222022222022222202221222122221202212202000022021222212222222222122222222222221222122222220222222022222222220222222221222122222011211222120222222211222222121220222122212220222112222212212202020122221222202222222222222222222222220222222022200222222222122222221212222122221222222111222222120222222110222222021221022122202222222212220202222222020022122122222222222222222222222222222222222022202222222222022222222212222120221222222210021222022222222102222222020220022122202222222102222202222202021022021022222222222222222222222222221222222222222222222022122222221222222122220222222222101222022222222110222222022220022022202222222002220222222202020222022122212222222222022222222222220222122022221222222222022222220222222222222122222222020222022202222121222222021221122222222222222022221222202212211122220222202222222222022222222222221222022222210222222022122222221222222020222222222222210222021212222220222022121221222022212220222202220200202212011022222122202222222222022222222222221222122022221222222222222222222212221022220122222101002222021212222022222122221222122222212221222012222220222202011022020222222222222222122202222222222222122122201222222222022222222212222220221222222222221222022222222111222222221220222122222221222012220222202212210122022222202222222222022212222222220222002222210222222222222222221212221021221022222101220122120222222002222022220222222122212220222122222200202212000122021122202222222222222212222222222221022022222222222222122222222212222211222022222022210122120212222110222222021222222222212221222122221200222212121222021122212222222222022212222222222222202222202222222122222222222222222101220122222221202122121202222122222222121222122022212220222222221222202222112022220022202212222222122222222222222222112122210222222222122222221222220112220122220212022222221222222002222222022202122222202220222212222222202212021222122022202212222222022212222222221221222122200222222122122222221202220100221022220012221222122222222021222122021202222122222221222112221210202222010222122222202212222222122212222222222222012222202222222022022222221222221012222122221101220122120202222211222122221210022122222220222012221212202222212222121222212202222222222222222222220220112222220022222222222222220222220102222022220112010022220212222021222122122120122122212221222112222210202202222222220222212222222222122212222222222220202222210222222022022222221202220110220022220002001022220212122020222022120202022222212221222202220202212202021022221022212212222222222202222222221220202022220012222122122222201212221020221222222020200222020222122201222222122000122222202221222212222201222202201022121122202202222222222222222222220220002022222222222022122222211212220201222022222012110022220212222222222022121101222022212222222102220210202222121022022022212202222222022212222222220220222122202202222122022222211202220102222022220021100122121222022210222122221112122022202221222012220212212222202122221222212222222222122212222222220200112222202122222022222222222222222120222022220112000022020222022021222022220121222222212222222022220221202212222122222022220202222222022222222222222210112022222202221122122222200202222121222122220101100022021212222200022122120110022222222222222112220222212222111222221122201202222222022222222222222210212222202012221022222222210212220112221222221020202212120202022220122022020111022222222221222012221200212222221022220022201212222222022212222222221220212222201122221022222222212212222110220122220022122002220212222102222122120000022222222221222002220220212202001222220022222222222220222012222222220220222122210022222002222222212222222001221122222001201122221212222121222222221020222222202220222222222210212222012022122022211212222220221202222222220212002122202222222122222222222212220021220122222101220102120202222120222022120111022222222220222122221220222202101122222222211202222220020002222222221201212222212002222102222222222222220011222022201022121222120212222022022022221101022222212221202222220221222202102122022022221202222222020202222222220210102222200212220112022222221212221000220122201220022212120210022002222022222020122222202220212012221212202212220222220022102202222222021202222222222211002222222002221002122222210222221221222222210021100002022212222012022122221000022012222222222202221220212212112222221222102212222221022122222222220202222222210222222212222022202212220012222022202011100222220210222221022022021021220102212220202202222222222212002222021222002212222221120012222222221202112122200012221022222022211222221120220222212011200112221201222200122122120001122112212222222012220210222212111222100122100202222222220212222222220220012222212222220112122222212112220210222122210210100222020200022201122222222101021102202221202012220210202222002122010122002202222221022222222202220220002122212112222012222222211112121021221222221220011012021200222101222222222120022102222222212122222222212202000022000222210202222221020102222212222221222122220002221002222122212102121211220222201101020212022220022022222222220121121022212221222102222212222222212122200022112222222221022102222212220200212122211222221222222022211202021000220022222012110022120210122002022022022212020122212222212222222220202202212022201022022202222221220002222222220202022122222012221122222222210102022121222122211120211112221221022222122022021222122202222221212202220221202212202022210022022202222220120222222212221210112202211102222012122222202112220001220122200000002002021221022210122122021112220002222220212122222202202202221122102122100202222222021212222222220202202002200212221212022122210222021220222222211202101022022200022020022022021202120200222222222022221201212202221022000022010212222221222002222212221212122102200202220002222122221212222000220022201022222022221222102211222022220000221001202222222212222200202222000222211122020012222220122222222212222210122022211222222012122022211212222201222122220011220012222210222202122122121112020002222221212102222220202212100222021022001022222221220022222212220202012022212022220202122022210002221002221222222220020202222221112020022022020201221120222220202102220200212202221022200022022022222222021012222212221221102112210002222222222022220122122020222222200111210112021201122111220122122121021112212222212002220201212212002222200022220012222222122002222222221201112002210212221222022022222112120120222022211102201102221212012001120122221122220201222222202122221202212222222122112022111112222221020112222202220220002012222202220002222122200022022112222022220200210002022201012021221022220021121200212221202012221221222212111022222022222002222202021002222222220222022202211222221012222122201102220020222222202110101102020200022110122022120000122211202222202102222202202212220222221222202122222220121202222212222220202102212122220222022222202112222112221122211011022002221202012120222122221212222021212222222002221210212212110022221022112102222211021002222222222220012022200222222202222122211022120201220022200002201012222101012102222222021211120221202212212122221201212212020122001022221102222221120022222212221200112102210202221002122222201202022200220222221001201212221001222111022022122200022000222212202202222212202012011222022022121022222200222122222202120210212012220012222022222222212102222002222122220010221112120011212212120122120220220002222201202012220210222212002022122222122112222221020222222202221220002002210022220102022122201012221022221022200020212012222222202101120022220012220112202220212212221202202202221222122122012002222222221002222212222221012222211002222112120222210012022001221220212100122212122221222012222222121012221110212202222122222222212222201122021022010002222210222022222222022212222102201212220102021222221212021210222120222111220122122211112011022122222112221122202210202202220202202202021122011022001122222200022212222212220210022022200002222022222222201202001111220221200202000202022222012222221222121201020211222211202202221220202222110022211022022002222221121012222222222201012122212102221202121222220102021111221122210001011122121200202202122122021102120200222221212122222210212012000022020222210012222222022212222212022210102102202202111202221122212122210001221021201012022012121201102011022222022102021022222220222112220211212012000122122022010012222200020012222212022210022202220222010102120012202022212002221220222220210122221110002011120022021201222110202220212212222211222112012222101202210022220220222222222222022221222022212202121022220122201212121110220121202000202112122220212221221022221102120111222221202202221201212122020122022212111002222222021202222212222212202122220212111122020202202210200101220121200012120122221122112112012222022000121012212212202002221212222212210122010012121222222110120022222222021210202112210200220202120022212210101020221020222220001002221020202200021222021121120000222222222102222201222212211222100002212012222200021012222212221221112002012120002222020202200112120111220220200120012122120120102020001222022011121102222201222012220222212112212122002122222012220110220101222222122201112112212221122202021022222111112210220221221020021022020202212022202220120121220211222211212002220202222112022122012202021012221121221111222202120200222012020221011222120222222202101211222021201210222012121120122111121222221122222000212212222102222210212122022222012102000012221212022220222222021220112112110011212112222202210221010001220121222022012202220012102220210020120021222012222200222002220222222212202022212112212102221112121210222222122221112202022222212000022222221000011201220220201102122022022120122220201022020221220010212202212012021211222002100222100202011022220220022122222212021202012122010022011002020012211000000202222022222100002020220100012011001021020001120022212210212222222212212012202022002122211212221210122220222202201201112122201010022201021022211110001120222222221010112010120020022000202020122101022100212201212202121211222222212222112002121202220010220210222222000022202022101100110221222002220002012001221222200110122221020012022020201220122102120021002212212212022211212222100222011122020112222210220112222222011122112212210122102201220222211011022021221221211210110121121200022101210121020012220112202211221222020222202002002122112210012012220000120011221202220112022112122222220022021112201220100022221221121022001000022102101012021022021101121020112202200012021220212222101222220012022102220210220212220202212100212022211101011211020202201200220101222122112211221212122220102221210122222121222211012201202212222221212002011222112120102112222122120121222222202001102112210022110221210002202000211202220022021100202221121200201010020021220101020100022222220012121222212022122122220101001012222200221110220202121000202122121200120000210202200021120020220022021010212021120211011200002222120022121021212210200002020121222122021122021122011022221222220102222202121002112112020010001112110122220020112020222022011200120101120101002120201222021120122022102221210012022221222222001222122100112122222020220011220222210100212212011111012022012002212001010120220121200222121200220121211021120120120211222200022222212102022102202012002022002110101122220002221210222202101021102002212111221110000122221001122020020121212111111222020112000211212222220122122010112210210222222121202122020122022110001012220121020202220222221002102002211021200110200102221221122122022122201200020010122210111002022200020001021112102220201002121102222012211022010121122102222022122122220012200212122122210110101012121112211121122202220021022012220110001222112200200201022002221101022200200102021210212102001222010202120122222110120111221122001112022202021112010200121100011112210101212010212110200120111101120201201200211002200211210110002020001102101011221110112120002100010111001100002121202121101021211120
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
