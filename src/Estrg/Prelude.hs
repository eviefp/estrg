module Estrg.Prelude
  ( module P
  , head
  , tail
  ) where

import Prelude as P (IO, Maybe (..), putStrLn)

head :: forall a. [a] -> Maybe a
head = \case
  [] -> Nothing
  (x : _) -> Just x

tail :: forall a. [a] -> [a]
tail = \case
  [] -> []
  (_ : xs) -> xs
