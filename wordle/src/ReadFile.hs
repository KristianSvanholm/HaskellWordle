module ReadFile(fileRead) where

{-
     Read a files content from path into string
-}
fileRead:: String -> IO String
fileRead path = do
     readFile path
