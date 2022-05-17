module Main where

import Lib
import Generate(generateGame)
import Game(game,clear)
import Control.Monad

main :: IO ()
main = startGame

{- | startGame
    Generates a new game and runs it.
    When game is finished, Recursively runs itself again if player wants to
-}
startGame:: IO()
startGame = do
    clear
    newGame <- generateGame
    game newGame []
    putStrLn "Play again? Y/N"
    input <- getLine
    when(input == "Y"||input == "y") startGame 