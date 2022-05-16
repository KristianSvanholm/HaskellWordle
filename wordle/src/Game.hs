{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Game where
import System.IO(hSetBuffering, BufferMode(NoBuffering), stdout)
import Data.Char
import WordParser (parse)
import Colors (gray, green, yellow)

gameLength :: Int
gameLength = 6

find :: String -> [String] -> Bool
find _ [] = False
find n (x:xs)
    | x == n = True
    | otherwise = find n xs

checkWord :: String -> String -> [String] -> Int
checkWord a g w
    | a == map toLower g = 0 -- Win condition
    | find (map toLower g) w = 1 -- Word exists, but is not correct word.
    | otherwise = 2 -- Word does not exist

game :: (String, [String]) -> [[(Char,Int)]]-> IO ()
game (a,w) gameState = do
    hSetBuffering stdout NoBuffering

    display gameState

    if att /= gameLength then do
        putStr "New attempt: "
        input <- getLine
        let cond = checkWord a input w

        clear
        case cond of
            0 -> do
                display (gameState++[parse (map toLower input) a])
                putStrLn "You win!"
            1 -> do
                game (a,w) (gameState++[parse (map toLower input) a])
            2 -> do
                putStrLn "Not a word!"
                game (a,w) gameState

    else do
        putStrLn "Out of attempts!"
        putStr "The word was: "
        putStrLn (green (map toUpper a))

    where
        att = length gameState

display :: [[(Char,Int)]] -> IO()
display gameState = do
    putStrLn "---- Wordle ----"
    putStr (drawBoard (generateBoard gameState))

drawBoard :: [String] -> String
drawBoard [] = []
drawBoard (x:xs) = x ++ "\n" ++ drawBoard xs

generateBoard :: [[(Char,Int)]] -> [String]
generateBoard [] = emptyLines gameLength
generateBoard list = line ++ emptyLines n
    where
        line = map format list
        n = gameLength - length list

emptyLines :: Int -> [String]
emptyLines 0 = []
emptyLines n = gray "□ □ □ □ □" : emptyLines (n-1)

format :: [(Char,Int)] -> String
format [] = []
format ((x,i):xs) 
    | i == 0 = gray (toUpper x : " ") ++ format xs
    | i == 1 = yellow (toUpper x : " ") ++ format xs
    | i == 2 = green (toUpper x : " ") ++ format xs

clear :: IO ()
clear = putStrLn "\ESC[2J"