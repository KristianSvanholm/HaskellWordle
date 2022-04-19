{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Game where
import System.IO(hSetBuffering, BufferMode(NoBuffering), stdout)


find:: String -> [String] -> Bool
find _ [] = False
find n (x:xs)
    | x == n = True
    | otherwise = find n xs

checkWord:: String -> String -> [String] -> Int
checkWord a g w
    | a == g = 0 -- Win condition
    | find g w = 1 -- Word exists, but is not correct word.
    | otherwise = 2 -- Word does not exist

game:: (String, [String]) -> [String]-> IO ()
game (a,w) gameState = do
    hSetBuffering stdout NoBuffering

    display gameState

    if att /= 6 then do

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
    putStr "Attempts: "
    putStr $ show att
    putStrLn "/6"
    putStrLn "New attempt:"
    where 
        att = length gameState

drawBoard:: [String] -> IO ()
drawBoard [] = return ()
drawBoard (x:xs) = do
    putStrLn x
    drawBoard xs

generateBoard:: [String] -> [String]
generateBoard [] = emptyLines 6
generateBoard list = list ++ emptyLines n
    where
        n = 6 - length list

emptyLines:: Int -> [String]
emptyLines 0 = []
emptyLines n = "□ □ □ □ □" : emptyLines (n-1)

clear :: IO ()
clear = putStrLn "\ESC[2J"