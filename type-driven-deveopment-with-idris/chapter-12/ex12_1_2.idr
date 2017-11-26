import Control.Monad.State

data Tree a = Empty
            | Node (Tree a) a (Tree a)

testTree : Tree String
testTree = Node (Node (Node Empty "Jim" Empty) "Fred" 
                      (Node Empty "Sheila" Empty)) "Alice"
                (Node Empty "Bob" (Node Empty "Eve" Empty))


countEmpty : Tree a -> State Nat ()
countEmpty Empty = do i <- get
                      put (S i)
                      pure () 
countEmpty (Node left x right) = do countEmpty left
                                    countEmpty right
