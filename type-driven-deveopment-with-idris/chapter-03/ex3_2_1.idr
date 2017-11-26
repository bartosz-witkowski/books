module ex3_2_1

import Data.Vect

createEmpties : Vect n (Vect 0 elem)
createEmpties = replicate _ []

export
transposeMat : Vect m (Vect n elem) -> Vect n (Vect m elem)
transposeMat [] = createEmpties
transposeMat (x :: xs) = let xsTrans = transposeMat xs in
                         zipWith (::) x xsTrans
