module Main  

import ex2

showF : Show a => (String -> a) -> String -> String
showF f input = show (f input) ++ "\n"

main : IO ()
main = repl "Enter a string: " (showF palindrome)
