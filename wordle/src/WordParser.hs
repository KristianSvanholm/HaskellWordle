module WordParser where
import Data.List ()

parse :: String -> Int -> String -> [(Char,Int)]
parse [] _ _ = []
parse (l:gs) n a = checkLetter l n a : parse gs (n+1) a

parse2 :: String -> Int -> String -> [(Char,Int)]
parse2 [] _ _ = []
parse2 (l:gs) n a = do
    checkLetter l n a : parse gs (n+1) a

-- TODO: IMPLEMENT DOUBLE YELLOW CHECK SOMEHOW
checkLetter :: Char -> Int -> String -> (Char,Int)
checkLetter l n a
    | l `elem` a = if l == a!!n then (l,2) else (l,1)
    | otherwise = (l,0)

tupleToList :: [(Char,Int)] -> [Char]
tupleToList [] = []
tupleToList ((c,_):xs) = c : tupleToList xs 

generateDoubles :: [Char] -> [Char] -> [(Char,Int)]
generateDoubles [] _ = []
generateDoubles (c:xs) a = (c, count c a) : generateDoubles xs a

count :: Char -> [Char] -> Int
count elem [] = 0
count elem (x:xs)
 | elem == x = 1 + count elem xs 
 | otherwise = count elem xs