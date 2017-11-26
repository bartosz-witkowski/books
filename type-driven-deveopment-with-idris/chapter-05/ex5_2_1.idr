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
