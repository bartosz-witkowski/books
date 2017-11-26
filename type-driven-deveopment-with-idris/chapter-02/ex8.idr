over_length : Nat -> List String -> Nat
over_length len xs = let lengths = map length xs
                         over = filter (> len) lengths in
                     length over
