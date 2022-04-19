module ReadFile
(fileRead)
where


fileRead:: String -> IO String
fileRead path = do
     readFile path
