{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Game where
import System.IO(hSetBuffering, BufferMode(NoBuffering), stdout)
import Data.Char


find:: String -> [String] -> Bool
find _ [] = False
find n (x:xs)
    | x == n = True
    | otherwise = find n xs

checkWord:: String -> String -> [String] -> Int
checkWord a g w
    | a == map toLower g = 0 -- Win condition
    | find (map toLower g) w = 1 -- Word exists, but is not correct word.
    | otherwise = 2 -- Word does not exist

game:: (String, [String]) -> [String]-> IO ()
game (a,w) gameState = do
    hSetBuffering stdout NoBuffering

    display gameState

    if att /= 6 then do
        putStr "New attempt: "
        input <- getLine
        let cond = checkWord a input w

        case cond of
            0 -> do
                clear
                display gameState
                putStrLn "You win!"
            1 -> do
                clear
                game (a,w) (gameState++[input])
            2 -> do
                clear
                putStrLn "Not a word!"
                game (a,w) gameState

    else do
        putStrLn "Out of attempts!"

    where
        att = length gameState

display:: [String] -> IO()
display gameState = do
    putStrLn "---- Wordle ----"
    drawBoard (generateBoard gameState)
    where
        att = length gameState

drawBoard:: [String] -> IO ()
drawBoard [] = return ()
drawBoard (x:xs) = do
    putStrLn x
    drawBoard xs

generateBoard:: [String] -> [String]
generateBoard [] = emptyLines 6
generateBoard list = formatWords list ++ emptyLines n
    where
        n = 6 - length list

emptyLines:: Int -> [String]
emptyLines 0 = []
emptyLines n = "□ □ □ □ □" : emptyLines (n-1)

formatWords :: [String] -> [String]
formatWords = map format

format:: String -> String
format [] = []
format (x:xs) = toUpper x : " " ++ format xs

clear :: IO ()
clear = putStrLn "\ESC[2J"