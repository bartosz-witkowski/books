module ex3_2_3

import Data.Vect
import ex3_2_1


doOne : Num num => Vect n num -> Vect n num -> num
doOne [] [] = 0
doOne (x :: xs) (y :: ys) = x * y + doOne xs ys

multCols : Num num => Vect m num -> Vect p (Vect m num) -> Vect p num
multCols row mat = map (\col => doOne row col) mat

                     -- n x m              m x p                n x p
multMatrix : Num num => Vect n (Vect m num) -> Vect m (Vect p num) -> Vect n (Vect p num)
multMatrix a b = let bTrans = transposeMat b in
                 map (\aRow => multCols aRow bTrans) a
