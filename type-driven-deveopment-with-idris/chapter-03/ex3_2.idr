import Data.Vect

my_length : List a -> Nat
my_length [] = 0
my_length (x :: xs) = 1 + my_length xs

my_reverse : List a -> List a
my_reverse [] = []
my_reverse (x :: xs) = my_reverse xs ++ [x]
                       
list_map : (a -> b) -> List a -> List b
list_map f [] = []
list_map f (x :: xs) = (f x) :: list_map f xs

vect_map : (a -> b) -> Vect n a -> Vect n b
vect_map f [] = []
vect_map f (x :: xs) = (f x) :: vect_map f xs
