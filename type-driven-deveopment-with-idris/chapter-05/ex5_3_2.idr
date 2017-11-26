readToBlank : IO (List String)
readToBlank = do
  line <- getLine
  if (line == "") 
  then pure []
  else do
    rest <- readToBlank
    pure $ line :: rest


listToString : (list : List String) -> String
listToString [] = ""
listToString (x :: xs) = x ++ "\n" ++ listToString xs

writeListToFile : (fileName : String) -> (list : List String) -> IO ()
writeListToFile fileName list = do
  let content = listToString list
  either <- writeFile fileName content 
  case either of
    Left fileError => putStrLn $ "Couldn't open file: " ++ show fileError
    Right ()       => pure ()

readAndSave : IO ()
readAndSave = do
  putStrLn "Enter a list of strings (blank line terminates)."
  list <- readToBlank
  putStrLn "Enter a file name"
  fileName <- getLine
  writeListToFile fileName list
