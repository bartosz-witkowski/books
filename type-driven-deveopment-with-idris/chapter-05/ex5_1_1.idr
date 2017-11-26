module Main

main : IO ()
main = do line1 <- getLine
          line2 <- getLine
          let l1 = length line1
          let l2 = length line2
          let len = if l1 > l2 then l1 else l2
          putStrLn (show len)
