module Stack (
 StackEl(..),
 Stack(..),
 pop,
 push,
 (^),
 v,
 enqueue,
 dequeue,
 (^^),
 vv
) where


import Control.Monad
import Control.Monad.State
import Prelude hiding ((^), (^^))


type StackEl = (String, Int) 
type Stack = [StackEl]


pop :: State Stack StackEl
pop = do
 x:xs <- get
 put xs
 return x


dequeue :: State Stack StackEl
dequeue = do
 xl <- get
 put $ init xl
 return $ last xl


push :: StackEl -> State Stack ()  
push a = do
 xs <- get
 put (a:xs)
 return ()


enqueue :: StackEl -> State Stack ()
enqueue a = do
 xl <- get
 put (xl ++ [a])
 return ()


(^) :: StackEl -> State Stack ()
(^) = push


v :: State Stack StackEl
v = pop


(^^) :: StackEl -> State Stack ()
(^^) = enqueue


vv :: State Stack StackEl
vv = dequeue
