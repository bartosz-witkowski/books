counts : String -> (Nat, Nat)
counts string = let nWords = length $ words string
                    size   = length $ string in
                (nWords, size)
