import DataStore

getValues : DataStore (SString .+. val_schema) -> List (SchemaType val_schema)
getValues store with (storeView store)
  getValues store | SNil = []
  getValues (addToStore entry rest) | (SAdd rec) = 
    (snd entry) :: (getValues rest | rec)

testStore : DataStore (SString .+. SInt)
testStore = addToStore ("First", 1) $ addToStore ("Second", 2) $ empty
