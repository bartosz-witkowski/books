import Data.Vect

readVectFromHandle : (file : File) -> IO (n ** Vect n String)
readVectFromHandle file = do
  isEnd <- fEOF file
  case isEnd of
    True  => pure (_ ** [])
    False => do 
      either <- fGetLine file
      case either of
        Left error => pure (_ ** [])
        Right line => do
          (_ ** rest) <- readVectFromHandle file
          pure (_ ** line :: rest)

readVectFile : (fileName : String) -> IO (n ** Vect n String)
readVectFile fileName = do
  either <- openFile fileName Read
  case either of
    Left error => pure (_ ** [])
    Right file => readVectFromHandle file
