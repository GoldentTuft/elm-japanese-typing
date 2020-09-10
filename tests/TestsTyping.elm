module TestsTyping exposing (testGetHistory, testMakeRomaji, testTypeTo)

import Expect
import Test exposing (..)
import Typing as Typing


testGetHistory : Test
testGetHistory =
    let
        testList =
            [ { word = "じゃ", input = "z" }
            , { word = "じゃじゃ", input = "jaz" }
            ]
    in
    describe "Test getHistory"
        (List.map
            (\testItem ->
                test ("test " ++ testItem.word) <|
                    \_ ->
                        Typing.newData testItem.word Typing.romanTable
                            |> typeAllKeys2 testItem.input
                            |> Typing.getHistory
                            |> Expect.equal testItem.input
            )
            testList
        )


type alias MakeRomajiTestData =
    { rules : Typing.Rules
    , word : String
    , input : String
    , expect : Maybe String
    }


testMakeRomaji : Test
testMakeRomaji =
    let
        myRules1 =
            Typing.defaultPriorities Typing.romanTable

        myRules2 =
            Typing.romanTable
                |> Typing.setPriorities
                    [ Typing.PrintRule "n" "ん" 3
                    , Typing.PrintRule "xn" "ん" 2
                    , Typing.PrintRule "nn" "ん" 1
                    ]
                |> Typing.insertLowPriorities (Typing.defaultPriorities Typing.romanTable)

        testList =
            [ MakeRomajiTestData myRules1 "あいうえお" "" (Just "aiueo")
            , MakeRomajiTestData myRules1 "あか" "aka" (Just "")
            , MakeRomajiTestData myRules1 "じゃ" "z" (Just "ya")
            , MakeRomajiTestData myRules1 "じゃ" "j" (Just "a")
            , MakeRomajiTestData myRules1 "み" "t" Nothing
            , MakeRomajiTestData myRules1 "しゃかいじん" "" (Just "syakaijinn")
            , MakeRomajiTestData myRules1 "ぷろぐらみんぐげんご" "pur" (Just "oguramingugengo")
            , MakeRomajiTestData myRules1 "ちょこれーと" "" (Just "tyokore-to")
            , MakeRomajiTestData myRules1 "ちょこれーと" "c" (Just "yokore-to")
            , MakeRomajiTestData myRules1 "えんでぃんぐ" "" (Just "endhingu")
            , MakeRomajiTestData myRules1 "てんになる" "" (Just "tennninaru")
            , MakeRomajiTestData myRules1 "いっそ" "" (Just "isso")
            , MakeRomajiTestData myRules1 "あっそ" "a" (Just "sso")
            , MakeRomajiTestData myRules1 "にっし" "" (Just "nissi")
            , MakeRomajiTestData myRules1 "っく" "" (Just "kku")
            , MakeRomajiTestData myRules1 "うぃるす" "" (Just "wirusu")
            , MakeRomajiTestData myRules1 "ろんよりしょうこ" "" (Just "ronnyorisyouko")
            , MakeRomajiTestData myRules1 "くぉーと" "" (Just "qo-to")
            , MakeRomajiTestData myRules2 "んあ" "" (Just "xna")
            , MakeRomajiTestData myRules2 "んあ" "n" (Just "na")
            , MakeRomajiTestData myRules2 "んか" "" (Just "nka")
            , MakeRomajiTestData myRules2 "じゃんけんじゃん" "" (Just "jankenjaxn")
            , MakeRomajiTestData myRules1 "ゃんけんじゃん" "" (Just "lyankenjann")
            , MakeRomajiTestData myRules2 "じゃ" "ji" (Just "lya")
            , MakeRomajiTestData myRules2 "んかんあ" "" (Just "nkaxna")
            , MakeRomajiTestData myRules2 "んけん" "" (Just "nkexn")
            , MakeRomajiTestData myRules2 "んけん" "n" (Just "kexn")
            , MakeRomajiTestData myRules2 "ん" "n" (Just "n")
            ]
    in
    describe "Test makeRomaji"
        (List.map
            (\testItem ->
                test ("test " ++ testItem.word ++ "(" ++ testItem.input ++ ")") <|
                    \_ ->
                        let
                            data =
                                Typing.newData testItem.word testItem.rules
                                    |> typeAllKeys2 testItem.input
                        in
                        Typing.makeRomaji data
                            |> Expect.equal testItem.expect
            )
            testList
        )


testTypeTo : Test
testTypeTo =
    describe "Test testTypeTo"
        (List.concat
            [ testSuccess "んっこ"
                [ "xnkko"
                , "xncco"
                , "xnltuko"
                , "xnltuco"
                , "xnxtuko"
                , "xnxtuco"
                , "xnltsuko"
                , "xnltsuco"
                , "xnxtsuko"
                , "xnxtsuco"
                , "nkko"
                , "ncco"
                , "nltuko"
                , "nltuco"
                , "nxtuko"
                , "nxtuco"
                , "nltsuko"
                , "nltsuco"
                , "nxtsuko"
                , "nxtsuco"
                , "nnkko"
                , "nncco"
                , "nnltuko"
                , "nnltuco"
                , "nnxtuko"
                , "nnxtuco"
                , "nnltsuko"
                , "nnltsuco"
                , "nnxtsuko"
                , "nnxtsuco"
                ]
            , testSuccess "んしゃん"
                [ "nsyann"
                , "nnshaxn"
                , "nsilyann"
                ]
            , testFail "んしゃん"
                [ "nsyank"
                , "nsisyann"
                , "nssyann"
                ]
            , testNotFinish "んしゃん"
                [ "nsyan"
                , "nnsyan"
                ]
            , testSuccess "んじゃん"
                [ "njann"
                , "nzyann"
                , "nnzilyann"
                ]
            , testSuccess "かちょう"
                [ "katyou"
                , "cachou"
                , "kachilyowu"
                , "kacyou"
                ]
            , testFail "かちょう"
                [ "kathou"
                ]
            , testSuccess "べーこん"
                [ "be-konn"
                , "be-coxn"
                ]
            , testSuccess "らんにんぐ"
                [ "rannninngu"
                , "raxnningu"
                ]
            , testFail "らんにんぐ"
                [ "ranninngu"
                , "rannninngwo"
                ]
            , testSuccess "んじゃっこん"
                [ "njakkonn"
                , "nnzyaccoxn"
                , "njaltukonn"
                ]
            , testFail "んじゃっこん"
                [ "njaqqonn"
                ]
            , testNotFinish "んじゃっこん"
                [ "njakkon" ]
            , testSuccess "んじゃっ"
                [ "njaltu" ]
            , testFail "んじゃっ"
                [ "njakk"
                , "njak"
                ]
            , testSuccess "んじゃっこ"
                [ "njakko"
                , "nnjacco"
                ]
            , testSuccess "っ"
                [ "ltu"
                , "xtu"
                ]
            , testFail "っ"
                [ "qq"
                , "kko"
                , "q"
                ]
            , testReject "っ"
                [ "q"
                , "qq"
                ]
            , testSuccess "っく"
                [ "qqu"
                , "kku"
                ]
            , testSuccess "けんで"
                [ "kende"
                , "kennde"
                , "kexnde"
                ]
            , testFail "けんよ"
                [ "kenyo"
                ]
            , testSuccess "けんよ"
                [ "kennyo"
                , "kexnyo"
                ]
            ]
        )


testSuccessHelp : String -> String -> Test
testSuccessHelp words input =
    test ("success " ++ input ++ ":" ++ words) <|
        \_ ->
            let
                ( resData, resList ) =
                    typeAllKeys input words

                miss =
                    List.member Typing.Miss resList

                finish =
                    List.member Typing.Finish resList
            in
            if
                (miss == False)
                    && (finish == True)
                    && (words == Typing.getFixed resData)
                    && (input == Typing.getHistory resData)
            then
                Expect.pass

            else
                Expect.fail (input ++ "(1)")


testSuccess : String -> List String -> List Test
testSuccess words inputs =
    List.map (testSuccessHelp words) inputs


testFailHelp : String -> String -> Test
testFailHelp words input =
    test ("fail " ++ input ++ ":" ++ words) <|
        \_ ->
            let
                ( _, resList ) =
                    typeAllKeys input words

                miss =
                    List.member Typing.Miss resList
            in
            if miss == True then
                Expect.pass

            else
                Expect.fail (input ++ "(1)")


testFail : String -> List String -> List Test
testFail words inputs =
    List.map (testFailHelp words) inputs


testNotFinishHelp : String -> String -> Test
testNotFinishHelp words input =
    test ("not finish " ++ input ++ ":" ++ words) <|
        \_ ->
            let
                ( _, resList ) =
                    typeAllKeys input words

                finish =
                    List.member Typing.Finish resList
            in
            if finish == False then
                Expect.pass

            else
                Expect.fail (input ++ "(1)")


testNotFinish : String -> List String -> List Test
testNotFinish words inputs =
    List.map (testNotFinishHelp words) inputs


testRejectHelp : String -> String -> Test
testRejectHelp words input =
    test ("reject " ++ input ++ ":" ++ words) <|
        \_ ->
            let
                ( resData, resList ) =
                    typeAllKeys input words

                miss =
                    List.all (\a -> a == Typing.Miss) resList

                finish =
                    List.member Typing.Finish resList
            in
            if miss == True && finish == False && (words /= Typing.getFixed resData) then
                Expect.pass

            else
                Expect.fail (input ++ "(1)")


{-| どういう目的で作ったか忘れた。はじくべき入力か？
「あいっ」<-「aiqq」「aiqqu」は「あいっく」とかになるからqを受け付けるべきじゃない。
ルールを展開してしまったから必要なくなったのかなぁ???
-}
testReject : String -> List String -> List Test
testReject words inputs =
    List.map (testRejectHelp words) inputs


typeAllKeys : String -> String -> ( Typing.Data, List Typing.State )
typeAllKeys input words =
    let
        first =
            ( Typing.newData words Typing.romanTable, [] )

        keys =
            String.split "" input

        help k ( td, listState ) =
            let
                newTD =
                    Typing.typeTo k td
            in
            ( newTD, List.append listState [ Typing.getState newTD ] )
    in
    List.foldl help first keys


typeAllKeys2 : String -> Typing.Data -> Typing.Data
typeAllKeys2 inputs data =
    List.foldl (\input d -> Typing.typeTo input d) data (String.split "" inputs)
