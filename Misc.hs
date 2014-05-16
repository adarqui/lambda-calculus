module Misc (
 p,
 pHistory
) where

import Control.Monad.State
import Control.Monad

p s = putStrLn $ show s

pHistory h = do
 let history = runState h []
 mapM_ (\s -> putStrLn $ fst s ++ "\n\t= " ++ show (snd s) ++ "\n") (snd history)
 return ()
