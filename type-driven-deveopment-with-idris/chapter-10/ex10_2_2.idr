import Data.Vect
import Data.Vect.Views

total
mergeSort : Ord a => Vect n a -> Vect n a
mergeSort input with (splitRec input)
  mergeSort [] | SplitRecNil = []
  mergeSort [x] | SplitRecOne = [x]
  mergeSort (left ++ right) | (SplitRecPair lrec rrec) = 
    merge (mergeSort left | lrec) (mergeSort right | rrec)
