module ex2

export
palindrome : String -> Bool
palindrome string = (reverse string) == string
