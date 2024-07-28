module Estrg.Prelude
  ( module P
  , head
  , tail
  ) where

import Prelude as P (IO, putStrLn, Maybe(..))

head :: forall a. [a] -> Maybe a
head = \case
  [] -> Nothing
  (x : _) -> Just x

tail :: forall a. [a] -> [a]
tail = \case
  [] -> []
  (_:xs) -> xs
