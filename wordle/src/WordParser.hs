module WordParser where

-- Parse through  guess against answer and find correct color values per letter
parse :: String -> String -> [(Char,Int)]
parse guess answer = do  
    let colorsFirstPass = zipWith greenCheck guess answer -- Find green colors first
    let ansWithoutgreens = zipWith applyGreen colorsFirstPass answer -- Remove green letters from answer to prevent duplicate yellows of already green letters
    let colorsSecondPass = runYellowCheck ansWithoutgreens guess colorsFirstPass -- Find yellow colors

    zipWith combineData guess colorsSecondPass -- Combine colors with guess as array of tuples

combineData :: Char -> Int -> (Char,Int)
combineData x y = (x,y)

-- If green color, remove letter
applyGreen :: Int -> Char -> Char
applyGreen 2 _ = ' '
applyGreen 0 c = c

-- Check if letter should be green
greenCheck :: Char -> Char -> Int 
greenCheck x y = if x == y then 2 else 0

-- Runs a yellow check for each letter in guess against answer.
runYellowCheck :: String -> String -> [Int]-> [Int]
runYellowCheck _ [] [] = []
runYellowCheck ans (g:gs) (c:cs) = do
    let res = yellowCheck ans g c 
    if res == 1 then -- If found yellow letter
        res : runYellowCheck (insertArr " " (find g ans 0) ans) gs cs  -- Continue but with that letter removed from answer for further searches
    else
        res : runYellowCheck ans gs cs

-- Check if letter should be yellow
yellowCheck :: String -> Char -> Int -> Int
yellowCheck str c n = if n == 2 then n else if c `elem` str then 1 else 0

-- Find chars index in string
find :: Char -> String -> Int -> Int
find c (x:xs) n = if c == x then n else find c xs (n+1)

-- Insert new letter to string at index n
insertArr :: String -> Int -> String -> [Char]
insertArr letter n word = do
    let (x,(_:y)) = splitAt n word
    return (x ++ letter ++ y)!!0
