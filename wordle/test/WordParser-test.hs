import Test.DocTest(doctest)
import Test.HUnit(Test(TestCase, TestList, TestLabel),assertEqual, runTestTT)
import Test.QuickCheck(quickCheckAll)
import Test.Hspec(Spec, hspec, describe, shouldBe, it)
import Test.Hspec.QuickCheck(prop)
import WordParser(parse, applyGreen, greenCheck, runYellowCheck, yellowCheck, findIndex)

main :: IO ()
main = do
    doctest ["-isrc", "src/WordParser.hs"]
    hspec $ do
            spec_parse
            spec_applyGreen
            spec_greenCheck
            spec_runYellowCheck
            spec_yellowCheck
            spec_findIndex

spec_parse :: Spec
spec_parse = do
    it "parse ADIEU PROXY returns [('A',0),('D',0),('I',0),('E',0),('U',0)]" $
        parse "ADIEU" "PROXY" `shouldBe` [('A',0),('D',0),('I',0),('E',0),('U',0)]
    it "parse ADDED DREAD returns [('A',1),('D',1),('D',0),('E',1),('D',2)]" $
        parse "ADDED" "DREAD" `shouldBe` [('A',1),('D',1),('D',0),('E',1),('D',2)]
    it "parse RIGHT RIGHT [('R',2),('I',2),('G',2),('H',2),('T',2)]" $
        parse "RIGHT" "RIGHT" `shouldBe` [('R',2),('I',2),('G',2),('H',2),('T',2)]
    it "parse '' ''  []" $
        parse "" "" `shouldBe` []

spec_applyGreen :: Spec
spec_applyGreen = do
    it "applyGreen 2 'C' returns ' '" $
        applyGreen 2 'C' `shouldBe` ' '
    it "applyGreen 0 'C' returns 'C'" $
        applyGreen 0 'C' `shouldBe` 'C'
    it "applyGreen 1 'C' returns 'C'" $
        applyGreen 1 'C' `shouldBe` 'C'

spec_greenCheck :: Spec
spec_greenCheck = do
    it "greenCheck 'a' 'a' returns 2" $
        greenCheck 'a' 'a' `shouldBe` 2
    it "greenCheck 'a' 'b' returns 2" $
        greenCheck 'a' 'b' `shouldBe` 0

spec_runYellowCheck :: Spec
spec_runYellowCheck = do
    it "runYellowCheck ' NSWE' 'GUESS' [2,0,0,0,2] returns [2,0,1,0,2]" $
        runYellowCheck " NSWE" "GUESS" [2,0,0,0,2] `shouldBe` [2,0,1,1,2]
    it "runYellowCheck 'WRONG' 'ADIEU' [0,0,0,0,0] returns [0,0,0,0,0]" $
        runYellowCheck "WRONG" "ADIEU" [0,0,0,0,0] `shouldBe` [0,0,0,0,0]
    it "runYellowCheck 'NIGHT' 'THING' [0,0,0,0,0] returns [1,1,1,1,1]" $
        runYellowCheck "NIGHT" "THING" [0,0,0,0,0] `shouldBe` [1,1,1,1,1]

spec_yellowCheck :: Spec
spec_yellowCheck = do
    it "yellowCheck 'ANSWER' 'A' 0 returns 1" $
        yellowCheck "ANSWER" 'A' 0 `shouldBe` 1
    it "yellowCheck 'ANSWER' 'B' 0 returns 0" $
        yellowCheck "ANSWER" 'B' 0 `shouldBe` 0
    it "yellowCheck 'ANSWER' 'R' 2 returns 2" $
        yellowCheck "ANSWER" 'R' 2 `shouldBe` 2

spec_findIndex :: Spec
spec_findIndex = do
    it "findIndex 'a' 'answer' 0 returns 0" $
        findIndex 'a' "answer" 0 `shouldBe` 0
    it "findIndex 'r' 'answer' 0 returns 5" $
        findIndex 'r' "answer" 0 `shouldBe` 5
    it "findIndex 'g' 'plug' 0 returns 3" $
        findIndex 'g' "plug" 0 `shouldBe` 3