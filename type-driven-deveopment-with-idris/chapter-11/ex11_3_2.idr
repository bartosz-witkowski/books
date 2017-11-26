data Command : Type -> Type where
     PutStr : String -> Command ()
     GetLine : Command String
     ReadFile : String -> Command $ Either FileError String
     WriteFile : String -> String -> Command $ Either FileError ()

runCommand : Command a -> IO a
runCommand (PutStr x) = putStr x
runCommand GetLine = getLine
runCommand (ReadFile fileName) = readFile fileName
runCommand (WriteFile filePath contents) = writeFile filePath contents
