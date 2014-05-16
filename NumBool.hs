module NumBool (
 nTrue,
 nFalse,
 nCmp,
 nCmp3
) where

nTrue = 1
nFalse = 0

nCmp :: (Eq a) => a -> a -> Int
nCmp = \x y -> if x == y then nTrue else nFalse

nCmp3 :: (Eq a) => a -> a -> a -> Int
nCmp3 = \x y z -> if x == y && y == z then nTrue else nFalse
