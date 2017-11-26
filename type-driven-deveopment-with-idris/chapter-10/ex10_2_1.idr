import Data.List.Views

total
equalSuffix : Eq a => List a -> List a -> List a
equalSuffix xs ys with (snocList xs)
  equalSuffix [] ys | Empty = []
  equalSuffix (xsFront ++ [x]) ys | (Snoc xsRec) with (snocList ys)
    equalSuffix (xsFront ++ [x]) [] | (Snoc xsRec) | Empty = []
    equalSuffix (xsFront ++ [x]) (ysFront ++ [y]) | (Snoc xsRec) | (Snoc ysRec) 
      = if x == y then (equalSuffix xsFront ysFront | xsRec | ysRec) ++ [x]
      else []
