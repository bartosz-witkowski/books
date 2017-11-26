data Expr = Simply Int | Add Expr Expr | Sub Expr Expr | Mul Expr Expr

evaluate : Expr -> Int
evaluate (Simply x) = x
evaluate (Add x y) = (evaluate x) + (evaluate y)
evaluate (Sub x y) = (evaluate x) - (evaluate y)
evaluate (Mul x y) = (evaluate x) * (evaluate y)

{-
evaluate (Mul (Simply 10) (Add (Simply 6) (Simply 3)))
-}
