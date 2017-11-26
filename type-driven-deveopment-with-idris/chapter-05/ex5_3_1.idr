readToBlank : IO (List String)
readToBlank = do
  line <- getLine
  if (line == "") 
  then pure []
  else do
    rest <- readToBlank
    pure $ line :: rest
