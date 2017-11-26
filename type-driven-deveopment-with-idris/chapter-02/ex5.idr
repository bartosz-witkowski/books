palindrome : Nat -> String -> Bool
palindrome size string = if (length string > size) then
                      (reverse $ toLower string) == toLower string
                    else
                      False
