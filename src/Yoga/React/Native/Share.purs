module Yoga.React.Native.Share
  ( share
  , ShareContent
  , ShareResult
  ) where

import Prelude

import Effect.Aff (Aff)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)

type ShareContent =
  { message :: String
  , title :: String
  , url :: String
  }

type ShareResult =
  { action :: String
  , activityType :: String
  }

foreign import shareImpl :: forall r. { | r } -> EffectFnAff ShareResult

share :: forall r. { | r } -> Aff ShareResult
share = fromEffectFnAff <<< shareImpl
