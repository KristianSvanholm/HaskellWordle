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