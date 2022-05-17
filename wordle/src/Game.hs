{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Game where
import System.IO(hSetBuffering, BufferMode(NoBuffering), stdout)
import Data.Char
import WordParser (parse)
import Colors (gray, green, yellow)

{-
    Const for num of guesses in a game
-}
gameLength :: Int
gameLength = 6

{-
    Finds a word within list of not correct words
    Retruns True if it finds the word, False if not.
-}
find :: String -> [String] -> Bool
find _ [] = False
find n (x:xs)
    | x == n = True
    | otherwise = find n xs

{-
    Checks the 'correctness' of a guess against the answer and returns its value.
    Three 'correctness'-values:
    0 -> Correct answer, player has won
    1 -> Word exists in list, but is not correct
    2 -> Word does not exist
-}
checkWord :: String -> String -> [String] -> Int
checkWord a g w
    | a == map toLower g = 0 -- Win condition
    | find (map toLower g) w = 1 -- Word exists, but is not correct word.
    | otherwise = 2 -- Word does not exist

{-
    Main game function running recursively until player wins or loses.
    - Reads a guess from IO
    - Runs guess through checkWord
    - 'Correctness'-value determines what path the function will go
        - Win condition
            - Displays the complete game board and informs player of their victory
        - Continue condition
            - Runs itself again with the current gamestate with the new parsed word added onto it.
        - Not a word condition
            - Runs itself again without changing the current gamestate.
    If attempt is equal to gameLength, End the game
-}
game :: (String, [String]) -> [[(Char,Int)]]-> IO ()
game (a,w) gameState = do
    hSetBuffering stdout NoBuffering

    display gameState

    if length gameState /= gameLength then do
        putStr "New attempt: "
        input <- getLine
        let cond = checkWord a input w -- Get correctness value of word

        clear -- Clear terminal
        case cond of
            0 -> do -- Correct guess, Win condition
                display (gameState++[parse (map toLower input) a]) -- Display the complete game board
                putStrLn "You win!"
            1 -> do -- Not correct, but word exists, continue game
                game (a,w) (gameState++[parse (map toLower input) a]) -- Runs itself with the new word added onto the gamestate.
            2 -> do -- Not a word condition
                putStrLn "Not a word!"
                game (a,w) gameState  -- Runs itself with the same gamestate
    else do -- Lose condition
        putStrLn "Out of attempts!"
        putStr "The word was: "
        putStrLn (green (map toUpper a)) -- Display correct word all green

{-
    Display gamestate to terminal
-}
display :: [[(Char,Int)]] -> IO()
display gameState = do
    putStrLn "---- Wordle ----"
    putStr (drawBoard (generateBoard gameState))

{-
    Compiles list of strings into one string with breaklines in between the elements.
-}
drawBoard :: [String] -> String
drawBoard [] = []
drawBoard (x:xs) = x ++ "\n" ++ drawBoard xs

{-
    Generates a list of colored strings.
    If list shorter than gamelength, fill in with strings of empty squares
-}
generateBoard :: [[(Char,Int)]] -> [String]
generateBoard [] = emptyLines gameLength -- If list is empty, create gamelength empty lines
generateBoard list = line ++ emptyLines n -- formated list ++ emptylines of n length where n is (gameLength - length list)
    where
        line = map format list -- Formatted string created from list
        n = gameLength - length list -- Number of guesses left in the game

{-
    Given an int n, creates list of n gray strings of 'empty' lines
-}
emptyLines :: Int -> [String]
emptyLines 0 = []
emptyLines n = gray "□ □ □ □ □" : emptyLines (n-1)


{-
    Formats data structure which contains a words letters and color code into string with color applied to them.
-}
format :: [(Char,Int)] -> String
format [] = []
format ((x,i):xs) 
    | i == 0 = gray (toUpper x : " ") ++ format xs -- Gray letter
    | i == 1 = yellow (toUpper x : " ") ++ format xs -- Yellow letter
    | i == 2 = green (toUpper x : " ") ++ format xs -- Green letter

{-
    Clears terminal screen
-}
clear :: IO ()
clear = putStrLn "\ESC[2J"