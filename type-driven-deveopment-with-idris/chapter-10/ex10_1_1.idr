data TakeN : List a -> Type where
  Fewer : TakeN xs
  Exact : (n_xs : List a) -> TakeN (n_xs ++ rest)

takeN : (n : Nat) -> (xs : List a) -> TakeN xs
takeN n xs = helper n [] xs
  where helper : (n : Nat) -> (front : List a) -> (xs : List a) -> TakeN xs
        helper Z front xs = Exact []
        helper (S k) front [] = Fewer
        helper (S k) front (y :: ys) = case helper k (y :: front) ys of
          Fewer => Fewer
          (Exact n_xs) => Exact (y :: n_xs)

groupByN : (n : Nat) -> (xs : List a) -> List (List a)
groupByN n xs with (takeN n xs)
  groupByN n xs | Fewer = [xs]
  groupByN n (n_xs ++ rest) | (Exact n_xs) = n_xs :: groupByN n rest
