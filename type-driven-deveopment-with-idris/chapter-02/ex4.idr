palindrome : String -> Bool
palindrome string = if (length string > 10) then
                      (reverse $ toLower string) == toLower string
                    else
                      False
