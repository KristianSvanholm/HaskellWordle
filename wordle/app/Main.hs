module Main where
import System.IO(hSetBuffering, BufferMode(NoBuffering), stdout)

import Lib
import Generate

main :: IO ()
main = do
    hSetBuffering stdout NoBuffering
    (possible, answer) <- generateGame
    print answer