import Test.DocTest(doctest)
import Test.HUnit(Test(TestCase, TestList, TestLabel),assertEqual, runTestTT)
import Test.QuickCheck(quickCheckAll)
import Test.Hspec(Spec, hspec, describe, shouldBe, it)
import Test.Hspec.QuickCheck(prop)
import Generate(removeNth, merge)

spec_removeNth :: Spec
spec_removeNth = do
    it "removeNth 2 [1,2,3,4,5] returns [1,2,4,5]" $
        removeNth 2 [1,2,3,4,5] `shouldBe` [1,2,4,5]
    it "removeNth 0 [] returns []" $
        removeNth 0 ([] :: [Int]) `shouldBe` []
    it "removeNth 1 [hello,Cruel,World] returns [hello,world]" $
        removeNth 1 ["hello","Cruel","world"] `shouldBe` ["hello","world"]

spec_merge :: Spec
spec_merge = do
    it " merge [] [] returns []" $
        merge  ([] :: [Int])  ([] :: [Int]) `shouldBe` []
    it "merge [1,2,3] [] returns [1,2,3]" $
        merge [1,2,3]  ([] :: [Int]) `shouldBe` [1,2,3]
    it " merge [] ['a','b','c'] returns ['a','b','c']" $
        merge  ([] :: [Char]) ['a','b','c'] `shouldBe` ['a','b','c']
    it "merge [1,2,3] [4,5,6] returns [1,2,3,4,5,6]" $
        merge [1,2,3] [4,5,6] `shouldBe` [1,2,3,4,5,6]

main :: IO ()
main = do
    doctest ["-isrc", "src/Generate.hs"]
    hspec $ do
            spec_removeNth
            spec_merge