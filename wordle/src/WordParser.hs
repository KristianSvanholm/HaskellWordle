module WordParser where
import Data.List

parse :: String -> Int -> String -> [(Char,Int)]
parse [] _ _ = []
parse (l:gs) n a = checkLetter l n a : parse gs (n+1) a

-- TODO: IMPLEMENT DOUBLE YELLOW CHECK SOMEHOW
checkLetter :: Char -> Int -> String -> (Char,Int)
checkLetter l n a
    | l `elem` a = if l == a!!n then (l,2) else (l,1)
    | otherwise = (l,0)