import Control.Monad.State

data Tree a = Empty
            | Node (Tree a) a (Tree a)

testTree : Tree String
testTree = Node (Node (Node Empty "Jim" Empty) "Fred" 
                      (Node Empty "Sheila" Empty)) "Alice"
                (Node Empty "Bob" (Node Empty "Eve" Empty))

countEmptyNode : Tree a -> State (Nat, Nat) ()
countEmptyNode Empty = do (nEmpty, nNode) <- get
                          put (nEmpty + 1, nNode)
countEmptyNode (Node left value right) = do 
  countEmptyNode left
  countEmptyNode right
  (nEmpty, nNode) <- get
  put (nEmpty, nNode + 1)
