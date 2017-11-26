module ex4_1_5

export
maxMaybe : Ord a => Maybe a -> Maybe a -> Maybe a
maxMaybe Nothing Nothing = Nothing
maxMaybe Nothing x = x
maxMaybe (Just x) Nothing = Just x
maxMaybe (Just x) (Just y) = if x > y then Just x else Just y
