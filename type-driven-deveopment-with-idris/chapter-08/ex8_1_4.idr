data ThreeEq : a -> b -> c -> Type where
  Same : ThreeEq a a a

allSameS : (x, y, z : Nat) -> (ThreeEq x y z) -> ThreeEq (S x) (S y) (S z)
allSameS z z z Same = Same
