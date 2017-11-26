import Data.Vect

vectTake : (n : Nat) -> Vect (n + m) elem -> Vect n elem
vectTake Z xs = []
vectTake (S k) (x :: xs) = x :: (vectTake k xs)
