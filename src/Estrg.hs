module Estrg
  ( run
  ) where

import Estrg.Prelude
import qualified Data.IORef as IORef
import Control.Monad.IO.Class

loop :: MonadIO m => a -> (a -> m a) -> m ()
loop st game = do
  stRef <- liftIO $ IORef.newIORef st
  forever do
    fps <- liftIO (IORef.readIORef stRef)
      >>= withTiming . game
      >>= \(a, fps) -> liftIO (IORef.writeIORef stRef a) $> fps
    liftIO $ print $ pretty fps
    pure ()

newtype FPS = FPS { getFPS :: Int }
  deriving newtype (Show, Pretty)

withTiming :: MonadIO m => m a -> m (a, FPS)
withTiming inner = do
  !before <- liftIO getCurrentTime
  !result <- inner
  !after <- liftIO getCurrentTime
  pure (result, go before after)
  where
    go :: UTCTime -> UTCTime -> FPS
    go before after = FPS $ floor $ (1 /) $ realToFrac @_ @Double $ nominalDiffTimeToSeconds $ diffUTCTime after before

run :: IO ()
run = loop () (const $ pure ())
