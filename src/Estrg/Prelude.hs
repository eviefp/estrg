module Estrg.Prelude
  ( module P
  , module Concurrent
  , module Functor
  , module Real
  , module Monad
  , module Pretty
  , module Time
  , head
  , tail
  , identity
  ) where

import Prelude as P ((/), Double, IO, Maybe (..), putStrLn, Monad(..), pure, ($), (.), print, Show(..), const, Int)

import Control.Concurrent as Concurrent (threadDelay)
import Control.Monad as Monad (forever)
import Data.Functor as Functor (($>), (<$))

import GHC.Real as Real (realToFrac, floor)

import Data.Time.Clock as Time (getCurrentTime, UTCTime, diffUTCTime, nominalDiffTimeToSeconds)
import Prettyprinter as Pretty (pretty, Pretty)

head :: forall a. [a] -> Maybe a
head = \case
  [] -> Nothing
  (x : _) -> Just x

tail :: forall a. [a] -> [a]
tail = \case
  [] -> []
  (_ : xs) -> xs

identity :: forall a. a -> a
identity x = x
