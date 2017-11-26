my_repl : (prompt : String) -> (run : String -> String) -> IO ()
my_repl prompt run = do
  putStr prompt
  line <- getLine
  putStr $ run line
  my_repl prompt run

my_replWith : (state : a) -> (prompt : String) -> (run : a -> String -> Maybe (String, a)) -> IO ()
my_replWith state prompt run = do
  putStr prompt
  line <- getLine
  case run state line of
     Just (output, newstate) => do
       putStr output
       my_replWith newstate prompt run
     Nothing => pure ()
