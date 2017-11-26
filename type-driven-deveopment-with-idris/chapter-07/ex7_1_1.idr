data Shape = Triangle Double Double
| Rectangle Double Double
| Circle Double

Eq Shape where
  (==) (Triangle x z) (Triangle x' z') = x == x' && z == z'
  (==) (Rectangle x z) (Rectangle x' z') = x == x' && z == z'
  (==) (Circle x) (Circle x') =  x == x'
  (==) _ _ = False
