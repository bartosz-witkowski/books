import System

readNat : IO (Maybe Nat)
readNat = do
  input <- getLine
  if all isDigit (unpack input)
    then pure (Just (cast input))
    else pure Nothing

guess : (target : Nat) -> IO ()
guess target = do
  putStr "guess? "
  nat <- readNat
  case nat of 
    Nothing  => do 
      putStrLn("Illegal guess!")
      guess target
    Just nat => 
      if nat == target
      then putStrLn "Correct!"
      else do 
        if nat < target then putStrLn "Too low" else putStrLn "Too high"
        guess target

int2nat : Integer -> Nat
int2nat i = if (i <= 0) then 0 else 1 + int2nat(i - 1)

random100 : IO Integer
random100 = do 
  t <- time 
  pure $ (t `mod` 15485863) `mod` 100

main : IO ()
main = do
  int <- random100
  let nat = int2nat int
  guess nat
