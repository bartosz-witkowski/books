import Data.Vect

reverseProof_nil : (acc : Vect n1 a) -> Vect (plus n1 0) a
reverseProof_nil {n1} acc = rewrite plusZeroRightNeutral n1 in
                            acc


helper : (n : Nat) -> (m : Nat) -> plus n (S m) = ((S n) + m)
helper n m = sym $ plusSuccRightSucc n m

reverseProof_xs : Vect ((S n) + m) a -> Vect (plus n (S m)) a
reverseProof_xs {m} {n} xs = rewrite helper n m in xs

myReverse : Vect n a -> Vect n a
myReverse xs = reverse' [] xs
  where reverse' : Vect n a -> Vect m a -> Vect (n + m) a
        reverse' acc [] = reverseProof_nil acc
        reverse' acc (x :: xs) = reverseProof_xs (reverse' (x :: acc) xs)
