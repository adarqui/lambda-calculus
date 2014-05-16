module Lambda (
 id',
 t',
 f',
 fst',
 snd',
 k',
 apply',
 twice',
 thrice',
 comp',
-- self'
-- y'
) where

newtype Rec a = In { out :: Rec a -> a }

id' = \x -> x
t' = \x y -> x
f' = \x y -> y
fst' = \x -> (\y -> x)
snd' = \x -> (\y -> y)
k' = fst'
apply' = \f -> (\x -> f x)
twice' = \f -> (\x -> f (f x))
thrice' = \f -> (\x -> f (f (f x)))
comp' = \g -> (\f -> (\x -> g (f x)))
--self' = \x -> x x
--self' = \x -> ((out x x) (In (\x -> (out x x))))
--self' f = seq f
y' = \t -> (\x -> t (x x)) (\x -> t (x x))
-- need to figure this out: Occurs check: cannot construct the infinite type: t0 ~ t0 -> t
