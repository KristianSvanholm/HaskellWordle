{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Used otherwise as a pattern" #-}
module Generate(generateGame, removeNth, merge) where

import ReadFile ( fileRead )
import System.Random ( mkStdGen, Random(randomR), RandomGen )
import Data.Time.Clock ( getCurrentTime, UTCTime(utctDayTime) )

{- | getRn
    Get random number between two integers
-}
getRn :: (RandomGen g) => Int -> Int -> g -> (Int,g)
getRn lo hi = randomR (lo,hi)

{- | generateGame
    generates a new game with an answer and an accepted word pool.
-}
generateGame:: IO (String,[String])
generateGame = do
    ansTxt <- fileRead "wordLists/answers.txt" -- Read all possible answers from answers.txt
    wordsTxt <- fileRead "wordLists/words.txt" -- Read all possible words from words.txt
    let answerPool = words ansTxt -- Split answers into list of possible answers
    let wordsPool = words wordsTxt -- Split words into list of words

    time <- getCurrentTime -- Get current time to seed randomness
    let init = mkStdGen (floor $ utctDayTime time :: Int) -- Init RNG
    let (num,_) = getRn 0 (length answerPool) init -- Run RNG and get number from between 0 and number of answers.

    let words = merge wordsPool (removeNth num answerPool) -- Merge wordpool and answerpool without the picked answer
    return (answerPool!!num,words) -- Return generated game with answer and possible words

{- | removeNth
    Remove nth element in array

    Tests:
    >>> removeNth 0 ["A","B"]
    ["B"]
    >>> removeNth 1 ["A","B"]
    ["A"]
    >>> removeNth 1 []
    []
-}
removeNth :: Int -> [] a -> [] a
removeNth _ [] = []
removeNth n list = case n of
      0 -> tail list
      otherwise -> head list : removeNth (n - 1) (tail list)

{- | merge
    merge two arrays into one.

    Tests:
    >>> merge ["A","B"] []
    ["A","B"]
    >>> merge [] ["A","B"]
    ["A","B"]
    >>> merge [] []
    []
    >>> merge [1,2] [3,4]
    [1,2,3,4]
-}
merge :: [a] -> [a] -> [a]
merge xs [] = xs
merge [] ys = ys
merge xs ys = xs++ys
