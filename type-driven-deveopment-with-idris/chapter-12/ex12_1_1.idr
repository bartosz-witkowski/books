import Control.Monad.State

update : (stateType -> stateType) -> State stateType ()
update f = do x <- get
              put $ f x

increase : Nat -> State Nat ()
increase x = update (+x)
