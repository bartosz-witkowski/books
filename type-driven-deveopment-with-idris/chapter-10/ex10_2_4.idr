import Data.List.Views

total
palindrome : Eq a => List a -> Bool
palindrome input with (vList input)
  palindrome [] | VNil = True
  palindrome [x] | VOne = True
  palindrome (x :: (xs ++ [y])) | (VCons rec) = 
    if (x == y) then (palindrome xs | rec)
                else False
