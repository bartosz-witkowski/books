%default total

data Command : Type -> Type where
     PutStr : String -> Command ()
     GetLine : Command String
     ReadFile : String -> Command (Either FileError String)
     WriteFile : String -> String -> Command (Either FileError ())
     Pure : ty -> Command ty
     Bind : Command a -> (a -> Command b) -> Command b

data ShellCommand = Cat String
                  | Copy String String
                  | Exit

data ConsoleIO : Type -> Type where
     Quit : a -> ConsoleIO a
     Do : Command a -> (a -> Inf (ConsoleIO b)) -> ConsoleIO b

data Fuel = Dry | More (Lazy Fuel)

namespace CommandDo
  (>>=) : Command a -> (a -> Command b) -> Command b
  (>>=) = Bind

namespace ConsoleDo
  (>>=) : Command a -> (a -> Inf (ConsoleIO b)) -> ConsoleIO b
  (>>=) = Do

runCommand : Command a -> IO a
runCommand (PutStr x) = putStr x
runCommand GetLine = getLine
runCommand (ReadFile fileName) = readFile fileName
runCommand (WriteFile filePath contents) = writeFile filePath contents
runCommand (Pure x)        = pure x
runCommand (Bind x f)      = do x' <- runCommand x
                                runCommand (f x')

run : Fuel -> ConsoleIO a -> IO (Maybe a)
run fuel (Quit val) = do pure (Just val)
run (More fuel) (Do c f) = do res <- runCommand c
                              run fuel (f res)
run Dry p = pure Nothing

tokens : String -> (String, String, String)
tokens x = let (first, rest) = tokenify x 
               (second, third) = tokenify (ltrim rest) in
           (first, (ltrim second), (trim third))
           where tokenify : String -> (String, String)
                 tokenify x = span (/= ' ') x

parseShellCommand : String -> String -> String -> Maybe ShellCommand
parseShellCommand "cat" fileName "" = Just $ Cat fileName
parseShellCommand "copy" source destination = Just $ Copy source destination
parseShellCommand "quit" "" "" = Just $ Exit
parseShellCommand _ _ _ = Nothing


parse : String -> Maybe ShellCommand
parse x = let (first, second, third) = tokens x in
          parseShellCommand first second third

runShellCommand : ShellCommand -> Maybe (Command ())
runShellCommand (Cat x) = 
  Just $ do 
         either <- (ReadFile x) 
         case either of
           (Left l) => do PutStr $ show l ++ "\n"
           (Right r) => do PutStr r
runShellCommand (Copy source destination) = 
  Just $ do
         either <- (ReadFile source) 
         case either of
           (Left error) => do PutStr $ show error ++ "\n"
           (Right content) => do 
                        retVal <- WriteFile destination content
                        case retVal of
                          (Left error) => do PutStr $ show error ++ "\n"
                          (Right ()) => Pure ()
runShellCommand Exit = Nothing

shell : ConsoleIO ()
shell = do PutStr $ "> "
           input <- GetLine
           case (parse input) of
             Nothing => do PutStr "Syntax error!\n"
                           shell
             (Just shellCmd) => case (runShellCommand shellCmd) of
                                 Nothing => Quit ()
                                 (Just cmd) => do cmd
                                                  shell
           

partial
forever : Fuel
forever = More forever

partial
main : IO ()
main = do
       run forever shell
       pure ()
