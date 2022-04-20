module Colors where


green :: String -> String
green str = "\ESC[32m"++str++"\ESC[37m"

yellow :: String -> String
yellow str = "\ESC[93m"++str++"\ESC[37m"

gray :: String -> String
gray str = "\ESC[90m"++str++"\ESC[37m"
