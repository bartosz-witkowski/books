data Vect : Nat -> Type -> Type where
  Nil : Vect Z a
  (::) : (x : a) -> (xs : Vect k a) -> Vect (S k) a

Eq a => Eq (Vect n a) where
  (==) [] [] = True
  (==) (x :: xs) (y :: ys) = x == y && (xs == ys)
  (/=) x y = not (x == y)

Foldable (Vect n) where
  foldr func init [] = init
  foldr func init (x :: xs) = let right = foldr func init xs in
                                  func x right
