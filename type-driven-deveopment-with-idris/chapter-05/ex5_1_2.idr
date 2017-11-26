module Main

main : IO ()
main = getLine >>= \line1 => getLine >>= \line2 =>
         let l1 = length line1
             l2 = length line2
             len = if l1 > l2 then l1 else l2 in
          putStrLn (show len)
