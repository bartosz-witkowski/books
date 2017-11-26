total
square_root_approx : (number : Double) -> (approx : Double) -> Stream Double
square_root_approx number approx = 
  let next = (approx + (number / approx)) / 2 in
  approx :: square_root_approx number next
