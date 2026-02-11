module Yoga.React.Native.Events
  ( nativeEvent
  ) where

import React.Basic.Events (EventFn, unsafeEventFn)

nativeEvent :: forall a. EventFn { nativeEvent :: a } a
nativeEvent = unsafeEventFn _.nativeEvent
