module Game where

find:: String -> [String] -> Bool
find _ [] = False
find n (x:xs)
    | x == n = True
    | otherwise = find n xs