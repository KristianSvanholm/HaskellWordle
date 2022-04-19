{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant lambda" #-}
{-# HLINT ignore "Used otherwise as a pattern" #-}
module Generate(generateGame) where

import ReadFile
import System.Random
import Data.Time.Clock

getRn :: (RandomGen g) => Int -> Int -> g -> (Int,g)
getRn lo hi = randomR (lo,hi)

generateGame:: IO ([String],String)
generateGame = do
    ansTxt <- fileRead "wordLists/answers.txt"
    wordsTxt <- fileRead "wordLists/words.txt"
    let answerPool = words ansTxt
    let wordsPool = words wordsTxt

    time <- getCurrentTime
    let init = mkStdGen (floor $ utctDayTime time :: Int)
    let (num,_) = getRn 0 (length answerPool) init

    let words = merge wordsPool (removeNth num answerPool)
    return (words,answerPool!!num)

removeNth :: Int -> [] a -> [] a
removeNth = \ n list -> case n of
            0 -> tail list
            otherwise -> head list: removeNth (n-1) (tail list)

merge :: [a] -> [a] -> [a]
merge xs     []     = xs
merge []     ys     = ys
merge (x:xs) (y:ys) = x : y : merge xs ys