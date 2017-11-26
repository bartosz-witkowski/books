import Data.Primitives.Views

data Face = Heads | Tails

randoms : Int -> Stream Int
randoms seed = let seed' = 1664525 * seed + 1013904223 in
                   (seed' `shiftR` 2) :: randoms seed'

total
getFace : Int -> Face
getFace int with (divides int 2)
  getFace ((2 * div) + rem) | (DivBy prf) = if (rem == 0) then Heads else Tails

total
coinFlips : (count : Nat) -> Stream Int -> List Face
coinFlips count xs = take count $ map getFace xs
