import Data.Vect

%default total

data StackCmd : Type -> Nat -> Nat -> Type where
     Push : Integer -> StackCmd () height (S height)
     Pop : StackCmd Integer (S height) height
     Top : StackCmd Integer (S height) (S height)

     GetStr : StackCmd String height height
     PutStr : String -> StackCmd () height height

     Pure : ty -> StackCmd ty height height
     (>>=) : StackCmd a height1 height2 ->
             (a -> StackCmd b height2 height3) ->
             StackCmd b height1 height3

runStack : (stk : Vect inHeight Integer) ->
           StackCmd ty inHeight outHeight -> IO (ty, Vect outHeight Integer)
runStack stk (Push val) = pure ((), val :: stk)
runStack (val :: stk) Pop = pure (val, stk)
runStack (val :: stk) Top = pure (val, val :: stk)
runStack stk GetStr = do x <- getLine
                         pure (x, stk)
runStack stk (PutStr x) = do putStr x
                             pure ((), stk)
runStack stk (Pure x) = pure (x, stk)
runStack stk (x >>= f) = do (x', newStk) <- runStack stk x
                            runStack newStk (f x')

data StackIO : Nat -> Type where
     Do : StackCmd a height1 height2 -> 
          (a -> Inf (StackIO height2)) -> StackIO height1

namespace StackDo
     (>>=) : StackCmd a height1 height2 -> 
             (a -> Inf (StackIO height2)) -> StackIO height1
     (>>=) = Do

data Fuel = Dry | More (Lazy Fuel)

partial
forever : Fuel
forever = More forever

run : Fuel -> Vect height Integer -> StackIO height -> IO ()
run (More fuel) stk (Do c f) 
     = do (res, newStk) <- runStack stk c
          run fuel newStk (f res)
run Dry stk p = pure ()

doOp2 : (Integer -> Integer -> Integer) -> StackCmd () (S (S height)) (S height)
doOp2 f = do val1 <- Pop
             val2 <- Pop
             Push (f val2 val1)

doOp1 : (Integer -> Integer) -> StackCmd () (S height) (S height)
doOp1 f = do val1 <- Pop
             Push (f val1)

mutual
  tryOp1 : (Integer -> Integer) -> StackIO height
  tryOp1 f {height = (S h)} = do (doOp1 f)
                                 result <- Top
                                 PutStr (show result ++ "\n")
                                 stackCalc
  tryOp1 f = do PutStr "Fewer than one item on the stack\n"
                stackCalc

  tryOp2 : (Integer -> Integer -> Integer) -> StackIO height
  tryOp2 f {height = (S (S h))} = do (doOp2 f)
                                     result <- Top
                                     PutStr (show result ++ "\n")
                                     stackCalc
  tryOp2 f = do PutStr "Fewer than two items on the stack\n"
                stackCalc

  data StkInput = Number Integer
                | Add
                | Sub
                | Mul
                | Neg

  strToInput : String -> Maybe StkInput
  strToInput "" = Nothing 
  strToInput "add" = Just Add
  strToInput "subtract" = Just Sub
  strToInput "multiply" = Just Mul
  strToInput "negate" = Just Neg
  strToInput x = if all isDigit (unpack x) 
                    then Just (Number (cast x))
                    else Nothing

  stackCalc : StackIO height
  stackCalc = do PutStr "> "
                 input <- GetStr
                 case strToInput input of
                      Nothing => do PutStr "Invalid input\n"
                                    stackCalc
                      Just (Number x) => do Push x
                                            stackCalc
                      Just Add => tryOp2 (+)
                      Just Mul => tryOp2 (*)
                      Just Sub => tryOp2 (-)
                      Just Neg => tryOp1 negate

partial
main : IO ()
main = run forever [] stackCalc

