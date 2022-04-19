{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Game where

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

game:: String -> [String] -> [String]-> IO ()
game a w gameState = do
    if att /= 6 then do
        putStrLn "New attempt:"

        input <- getLine
        let cond = checkWord a input w

        case cond of
            0 -> putStrLn "You win!"
            1 -> game a w (gameState++[input])
            2 -> do 
                putStrLn "Not a word!"
                game a w gameState
    else do
        putStrLn "Out of attempts!"

    where
        att = length gameState

display:: [String] -> Int -> IO()
display gameState att = do
    putStrLn "---- Wordle ----"
    drawBoard gameState att
    putStr "Attempts: "
    putStr $ show att
    putStrLn "/6"

drawBoard:: [String] -> Int -> IO ()
drawBoard [] n = drawEmptyLines (6-n)
drawBoard (x:xs) n = do
    putStrLn x
    drawBoard xs n

drawEmptyLines:: Int -> IO()
drawEmptyLines 0 = return ()
drawEmptyLines 1 = putStrLn "□ □ □ □ □"
drawEmptyLines n = do
    putStrLn "□ □ □ □ □"
    drawEmptyLines (n-1)