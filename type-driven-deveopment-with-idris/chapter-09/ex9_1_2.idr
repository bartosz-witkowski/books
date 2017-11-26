data Last : List a -> a -> Type where
  LastOne : Last [value] value
  LastCons : (prf : Last xs value) -> Last (x :: xs) value

notInNil : Last [] value -> Void
notInNil LastOne impossible
notInNil (LastCons _) impossible

notLast : DecEq a => (lastNeqValue : (x = value) -> Void) -> (xs : List a) -> Last [x] value -> Void
notLast lastNeqValue xs LastOne = lastNeqValue Refl
notLast _ _ (LastCons LastOne) impossible
notLast _ _ (LastCons (LastCons _)) impossible

notInTail : DecEq a => (contra : Last (y :: ys) value -> Void) -> (xs : List a) -> Last (x :: (y :: ys)) value -> Void
notInTail contra xs (LastCons prf) = contra prf

isLast : DecEq a => (xs : List a) -> (value : a) -> Dec (Last xs value)
isLast [] value = No notInNil
isLast (x :: xs) value = case xs of 
  [] => case decEq x value of
    Yes Refl         => Yes LastOne
    No  lastNeqValue => No (notLast lastNeqValue xs)
  (y :: ys) => case isLast (y :: ys) value of
    (Yes prf) => Yes (LastCons prf)
    (No contra) => No ((notInTail contra xs))
