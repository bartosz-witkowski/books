palindrome : String -> Bool
palindrome string = (reverse $ toLower string) == toLower string
