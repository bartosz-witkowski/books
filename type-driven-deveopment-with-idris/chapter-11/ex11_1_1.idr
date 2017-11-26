total
every_other : Stream a -> Stream a
every_other (x1 :: x2 :: xs) = x2 :: every_other xs
