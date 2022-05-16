module WordParser where

parse :: String -> String -> [(Char,Int)]
parse guess answer = do  
    let colorsFirstPass = zipWith greenCheck guess answer
    let ansWithoutgreens = zipWith applyGreen colorsFirstPass answer
    let colorsSecondPass = runYellowCheck ansWithoutgreens guess colorsFirstPass

    zipWith combineData guess colorsSecondPass

combineData :: Char -> Int -> (Char,Int)
combineData x y = (x,y)

applyGreen :: Int -> Char -> Char
applyGreen 2 _ = ' '
applyGreen 0 c = c

greenCheck :: Char -> Char -> Int
greenCheck x y = if x == y then 2 else 0

runYellowCheck :: String -> String -> [Int]-> [Int]
runYellowCheck _ [] [] = []
runYellowCheck ans (g:gs) (c:cs) = do
    let res = yellowCheck ans g c 
    if res == 1 then
        res : runYellowCheck (insertArr " " (find g ans 0) ans) gs cs 
    else
        res : runYellowCheck ans gs cs

yellowCheck :: String -> Char -> Int -> Int
yellowCheck str c n = if n == 2 then n else if c `elem` str then 1 else 0

find :: Char -> String -> Int -> Int
find c (x:xs) n = if c == x then n else find c xs (n+1)

insertArr :: String -> Int -> String -> [Char]
insertArr letter n word = do
    let (x,(_:y)) = splitAt n word
    return (x ++ letter ++ y)!!0
