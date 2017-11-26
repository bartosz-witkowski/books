import Data.Vect

addMatrix : Num a => Vect n (Vect m a) -> Vect n (Vect m a) -> Vect n (Vect m a)
addMatrix [] [] = []
addMatrix (x :: xs) (y :: ys) = let rest = addMatrix xs ys in
                                (zipWith (+) x y) :: rest
