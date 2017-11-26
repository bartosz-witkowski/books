%default total

record Score where
       constructor MkScore
       correct : Nat
       attempted : Nat

record GameState where
       constructor MkGameState
       score : Score
       difficulty : Int

Show GameState where
    show st = show (correct (score st)) ++ "/" ++
              show (attempted (score st)) ++ "\n" ++
              "Difficulty: " ++ show (difficulty st)

initState : GameState
initState = MkGameState (MkScore 0 0) 12

addWrong : GameState -> GameState
addWrong = record { score->attempted $= (+1) }

addCorrect : GameState -> GameState
addCorrect = record { score->correct $= (+1),
                      score->attempted $= (+1) }

setDifficulty : Int -> GameState -> GameState
setDifficulty newDiff state = record { difficulty = newDiff } state

data Command : Type -> Type where
     PutStr : String -> Command ()
     GetLine : Command String

     GetRandom : Command Int
     GetGameState : Command GameState
     PutGameState : GameState -> Command ()

     Pure : ty -> Command ty
     Bind : Command a -> (a -> Command b) -> Command b

Functor (Command) where
  map func x = Bind x (\val => Pure (func val))

Applicative (Command) where
  pure x = Pure x
  (<*>) x y = Bind x (\aToB =>
              Bind y (\a =>
              Pure (aToB a)))

Monad (Command) where
  (>>=) = Bind
