import Test.DocTest(doctest)
import Test.HUnit(Test(TestCase, TestList, TestLabel),assertEqual, runTestTT)
import Test.QuickCheck(quickCheckAll)
import Test.Hspec(Spec, hspec, describe, shouldBe, it)
import Test.Hspec.QuickCheck(prop)
import Game(find, checkWord, drawBoard, generateBoard, emptyLines,format)

main :: IO ()
main = do
    doctest ["-isrc", "src/Game.hs"]
    hspec $ do
            spec_find
            spec_checkWord
            spec_drawBoard
            spec_generateBoard
            spec_emptylines
            spec_format

spec_find :: Spec
spec_find = do
    it "find 'Hello' ['Hello','World'] returns True" $
        find "Hello" ["Hello","World"] `shouldBe` True
    it "find 'Hello' ['Goodbye','cruel','World'] returns False" $
        find "Hello" ["Goodbye","cruel","World"] `shouldBe` False
    it "find 'Hello' [] returns False" $
        find "Hello" [] `shouldBe` False

spec_drawBoard :: Spec
spec_drawBoard = do
    it "drawBoard ['Hello','World'] returns 'Hello\\nWorld\\n'" $
        drawBoard ["Hello","World"] `shouldBe` "Hello\nWorld\n"
    it "drawBoard [] returns ''" $
        drawBoard [] `shouldBe` ""
    it "drawBoard ['Hello'] returns 'Hello\\n'" $
        drawBoard ["Hello"] `shouldBe` "Hello\n"

spec_checkWord :: Spec
spec_checkWord = do
    it "checkWord 'answer' 'guess' ['guess','wrong']" $
        checkWord "answer" "guess" ["guess", "wrong"] `shouldBe` 1
    it "checkWord 'answer' 'answer' ['guess','correct']" $
        checkWord "answer" "answer" ["guess","right"] `shouldBe` 0
    it "checkWord 'answer' 'NOTREAL' ['guess','wrong']" $
        checkWord "answer" "NOTREAL" ["guess","right"] `shouldBe` 2
    it "checkWord 'answer' 'guess' []" $
        checkWord "answer" "guess" [] `shouldBe` 2

squareLine::String
squareLine = "\ESC[90m\9633 \9633 \9633 \9633 \9633\ESC[37m"

spec_generateBoard :: Spec
spec_generateBoard = do
    it "generateBoard [[('a',2),('d',2),('i',2),('e',2),('u',2)]] returns ['ADIEU','\9633\9633\9633\9633\9633','\9633\9633\9633\9633\9633','\9633\9633\9633\9633\9633','\9633\9633\9633\9633\9633','\9633\9633\9633\9633\9633']" $
        generateBoard [[('a',2),('d',2),('i',2),('e',2),('u',2)]] `shouldBe` ["\ESC[32mA \ESC[37m\ESC[32mD \ESC[37m\ESC[32mI \ESC[37m\ESC[32mE \ESC[37m\ESC[32mU \ESC[37m",squareLine,squareLine,squareLine,squareLine,squareLine]
    it "generateBoard [] returns [\9633\9633\9633\9633\9633,\9633\9633\9633\9633\9633,\9633\9633\9633\9633\9633,\9633\9633\9633\9633\9633,\9633\9633\9633\9633\9633,\9633\9633\9633\9633\9633]" $
        generateBoard [] `shouldBe` [squareLine,squareLine,squareLine,squareLine,squareLine,squareLine]

spec_emptylines :: Spec
spec_emptylines = do
    it "emptyLines 0 returns []" $
        emptyLines 0 `shouldBe` []
    it "emptyLines 2 returns ['\9633\9633\9633\9633\9633','\9633\9633\9633\9633\9633']" $
        emptyLines 2 `shouldBe` [squareLine,squareLine]

spec_format :: Spec
spec_format = do
    it "format [('a',2),('d',2),('i',2),('e',2),('u',2)] returns ['ADIEU']" $
        format [('a',2),('d',1),('i',0),('e',1),('u',2)] `shouldBe` "\ESC[32mA \ESC[37m\ESC[93mD \ESC[37m\ESC[90mI \ESC[37m\ESC[93mE \ESC[37m\ESC[32mU \ESC[37m"
    it "format [] returns []" $
        format [] `shouldBe` []