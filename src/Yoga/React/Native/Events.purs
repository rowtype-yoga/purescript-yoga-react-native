module Yoga.React.Native.Events
  ( nativeEvent
  ) where

import React.Basic.Events (EventFn, SyntheticEvent, unsafeEventFn)
import Unsafe.Coerce (unsafeCoerce)

nativeEvent :: forall a. EventFn SyntheticEvent a
nativeEvent = unsafeEventFn \e -> (unsafeCoerce e).nativeEvent
