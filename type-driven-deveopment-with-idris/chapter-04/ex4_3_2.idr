module Main

import Data.Vect

data DataStore : Type where
     MkData : (size : Nat) -> (items : Vect size String) -> DataStore

size : DataStore -> Nat
size (MkData size' items') = size'

items : (store : DataStore) -> Vect (size store) String
items (MkData size' items') = items'

addToStore : DataStore -> String -> DataStore
addToStore (MkData size store) newitem = MkData _ (addToData store)
  where
    addToData : Vect oldsize String -> Vect (S oldsize) String
    addToData [] = [newitem]
    addToData (x :: xs) = x :: addToData xs

data Command = Add String
             | Get Integer
             | Search String
             | Size
             | Quit

parseCommand : String -> String -> Maybe Command
parseCommand "add" str = Just (Add str)
parseCommand "search" str = Just (Search str)
parseCommand "get" val = case all isDigit (unpack val) of
                              False => Nothing
                              True => Just (Get (cast val))
parseCommand "quit" "" = Just Quit
parseCommand "size" "" = Just Size
parseCommand _ _ = Nothing

parse : (input : String) -> Maybe Command
parse input = case span (/= ' ') input of
                   (cmd, args) => parseCommand cmd (ltrim args)

getEntry : (pos : Integer) -> (store : DataStore) ->
           Maybe (String, DataStore)
getEntry pos store
    = let store_items = items store in
          case integerToFin pos (size store) of
               Nothing => Just ("Out of range\n", store)
               Just id => Just (index id (items store) ++ "\n", store)

search : (item : String) -> (store : DataStore) ->  Maybe (String, DataStore)
search item store = 
  let store_items = items store 
      found = find item store_items in
  Just (show_list found, store)
  where 
    find : String -> Vect m String -> List String
    find x [] = []
    find x (y :: ys) = if isInfixOf x y then y :: (find x ys) else find x ys
                       

    show_list : List String -> String
    show_list [] = ""
    show_list (x :: xs) = show x ++ "\n" ++ show_list xs

processInput : DataStore -> String -> Maybe (String, DataStore)
processInput store input
    = case parse input of
           Nothing => Just ("Invalid command\n", store)
           Just (Add item) =>
              Just ("ID " ++ show (size store) ++ "\n", addToStore store item)
           Just (Search item) => search item store
           Just Size => Just (show (size store) ++ "\n", store)
           Just (Get pos) => getEntry pos store
           Just Quit => Nothing

main : IO ()
main = replWith (MkData _ []) "Command: " processInput
