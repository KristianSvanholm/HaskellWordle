module Main where

import Lib
import Generate
import Game

main :: IO ()
main = do
    clear
    (possible, answer) <- generateGame
    print answer
    game answer possible []