module Colors where

-- All color functions recolors string to white at the end as to not color anything outside the scope of their strings

{-
    Colors a string green
-}
green :: String -> String
green str = "\ESC[32m"++str++"\ESC[37m"

{-
    Colors a string yellow
-}
yellow :: String -> String
yellow str = "\ESC[93m"++str++"\ESC[37m"

{-
    Colors a string gray
-}
gray :: String -> String
gray str = "\ESC[90m"++str++"\ESC[37m"
