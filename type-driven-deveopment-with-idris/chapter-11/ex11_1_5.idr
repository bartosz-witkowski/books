total
square_root_approx : (number : Double) -> (approx : Double) -> Stream Double
square_root_approx number approx = 
  let next = (approx + (number / approx)) / 2 in
  approx :: square_root_approx number next

total
square_root_bound : 
  (max : Nat) -> 
  (number : Double) -> 
  (bound : Double) ->
  (approxs : Stream Double) -> Double
square_root_bound Z number bound (value :: xs) = value
square_root_bound (S k) number bound (val :: xs) = 
  let guess = val * val 
      diff  = abs $ guess - number in
  if diff < bound 
  then val
  else square_root_bound k number bound xs

square_root : (number : Double) -> Double
square_root number = square_root_bound 100 number 0.00000000001 (square_root_approx number number)
