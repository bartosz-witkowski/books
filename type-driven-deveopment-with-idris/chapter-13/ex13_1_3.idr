data Matter = Solid | Liquid | Gas

data MatterCmd : Type         -> Matter -> Matter -> Type where
     Melt      : MatterCmd ()    Solid     Liquid
     Boil      : MatterCmd ()    Liquid    Gas
     Condense  : MatterCmd ()    Gas       Liquid
     Freeze    : MatterCmd ()    Liquid    Solid

     (>>=) : MatterCmd a s1 s2 -> (a -> MatterCmd b s2 s3) -> MatterCmd b s1 s3

iceSteam : MatterCmd () Solid Gas
iceSteam = do Melt
              Boil

steamIce : MatterCmd () Gas Solid
steamIce = do Condense
              Freeze

{- shouldn't type check 
overMelt : MatterCmd () Solid Gas
overMelt = do Melt
              Melt
-}
