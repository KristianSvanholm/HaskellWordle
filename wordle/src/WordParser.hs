module WordParser where

{- | parse
    Parse through a guess against answer and find correct color values per letter

    Tests:
    >>> parse "ADIEU" "PROXY" 
    [('A',0),('D',0),('I',0),('E',0),('U',0)]
    >>> parse "ADDED" "DREAD"
    [('A',1),('D',1),('D',0),('E',1),('D',2)]
    >>> parse "RIGHT" "RIGHT"
    [('R',2),('I',2),('G',2),('H',2),('T',2)]
    >>> parse "" ""
    []
-}
parse :: String -> String -> [(Char,Int)]
parse guess answer = do  
    let colorsFirstPass = zipWith greenCheck guess answer -- Find green colors first
    let ansWithoutgreens = zipWith applyGreen colorsFirstPass answer -- Remove green letters from answer to prevent duplicate yellows of already green letters
    let colorsSecondPass = runYellowCheck ansWithoutgreens guess colorsFirstPass -- Find yellow colors

    zipWith (\x y -> (x,y)) guess colorsSecondPass -- Combine colors with guess as array of tuples

{- | applyGreen
    Checks color value, if value is 2 (green), return an empty char
    if value is 0 (gray), return the original char.

    Tests:
    >>>  applyGreen 2 'C'
    ' '
    >>> applyGreen 0 'C'
    'C'
    >>>  applyGreen 1 'C'
    'C'
-}
applyGreen :: Int -> Char -> Char
applyGreen n c = case n of
    2 -> ' '
    otherwise -> c

{- | greenCheck
    Checks letter against corresponding letter in answer.
    If correct, return 2 (green) else return 0 (gray)

    Tests:
    >>> greenCheck 'a' 'a'
    2
    >>> greenCheck 'a' 'b'
    0
-}
greenCheck :: Char -> Char -> Int 
greenCheck x y = if x == y then 2 else 0

{- | runYellowCheck
    Runs a yellow check for each letter in guess against answer.
    If a yellow is found, that letter is removed from the answer string to prevent duplicates

    Tests:
    >>> runYellowCheck " NSWE" "GUESS" [2,0,0,0,2]
    [2,0,1,1,2]
    >>> runYellowCheck "WRONG" "ADIEU" [0,0,0,0,0]
    [0,0,0,0,0]
    >>> runYellowCheck "NIGHT" "THING" [0,0,0,0,0]
    [1,1,1,1,1]
-}
runYellowCheck :: String -> String -> [Int]-> [Int]
runYellowCheck _ [] [] = []
runYellowCheck ans (g:gs) (c:cs) = do
    let colorCode = yellowCheck ans g c 
    if colorCode == 1 then -- If found yellow letter
        colorCode : runYellowCheck (insertArr " " (findIndex g ans 0) ans) gs cs  -- Continue but with that letter removed from answer for further searches
    else
        colorCode : runYellowCheck ans gs cs -- Continue with same answer string
 
{- | yellowCheck
    Checks if letter exists within answer and if so and not already green, returns 1 (yellow)

    Tests:
    >>> yellowCheck "ANSWER" 'A' 0
    1
    >>> yellowCheck "ANSWER" 'B' 0
    0
    >>> yellowCheck "ANSWER" 'R' 2
    2
-}
yellowCheck :: String -> Char -> Int -> Int
yellowCheck str c n = if n == 2 then n else if c `elem` str then 1 else 0

{- | find
    Find chars index within a string going left to right.

    Tests:
    >>> findIndex 'a' "answer" 0 
    0
    >>> findIndex 'r' "answer" 0 
    5
    >>> findIndex 'g' "plug" 0 
    3
-}
findIndex :: Char -> String -> Int -> Int
findIndex c (x:xs) n = if c == x then n else findIndex c xs (n+1)

{- | insertArr
    Insert new letter into string at index n
-}
insertArr :: String -> Int -> String -> [Char]
insertArr letter n word = do
    let (x,y) = splitAt n word
    return (x ++ letter ++ (tail y))!!0