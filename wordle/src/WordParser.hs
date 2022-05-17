module WordParser where

{-
    Parse through a guess against answer and find correct color values per letter
-}
parse :: String -> String -> [(Char,Int)]
parse guess answer = do  
    let colorsFirstPass = zipWith greenCheck guess answer -- Find green colors first
    let ansWithoutgreens = zipWith applyGreen colorsFirstPass answer -- Remove green letters from answer to prevent duplicate yellows of already green letters
    let colorsSecondPass = runYellowCheck ansWithoutgreens guess colorsFirstPass -- Find yellow colors

    zipWith (\x y -> (x,y)) guess colorsSecondPass -- Combine colors with guess as array of tuples

{-
    Checks color value, if value is 2 (green), return an empty char
    if value is 0 (gray), return the original char.
-}
applyGreen :: Int -> Char -> Char
applyGreen 2 _ = ' '
applyGreen 0 c = c

{-
    Checks letter against corresponding letter in answer.
    If correct, return 2 (green) else return 0 (gray)
-}
greenCheck :: Char -> Char -> Int 
greenCheck x y = if x == y then 2 else 0

{-
    Runs a yellow check for each letter in guess against answer.
    If a yellow is found, that letter is removed from the answer string to prevent duplicates
-}
runYellowCheck :: String -> String -> [Int]-> [Int]
runYellowCheck _ [] [] = []
runYellowCheck ans (g:gs) (c:cs) = do
    let colorCode = yellowCheck ans g c 
    if colorCode == 1 then -- If found yellow letter
        colorCode : runYellowCheck (insertArr " " (find g ans 0) ans) gs cs  -- Continue but with that letter removed from answer for further searches
    else
        colorCode : runYellowCheck ans gs cs -- Continue with same answer string

{-
    Checks if letter exists within answer and if so and not already green, returns 1 (yellow)
-}
yellowCheck :: String -> Char -> Int -> Int
yellowCheck str c n = if n == 2 then n else if c `elem` str then 1 else 0

{-
    Find chars index within a string going left to right.
-}
find :: Char -> String -> Int -> Int
find c (x:xs) n = if c == x then n else find c xs (n+1)

{-
    Insert new letter into string at index n
-}
insertArr :: String -> Int -> String -> [Char]
insertArr letter n word = do
    let (x,(_:y)) = splitAt n word
    return (x ++ letter ++ y)!!0
