module Yoga.React.Native.MacOS.Events
  ( onNumber
  , onInt
  , onString
  , onBool
  , onStrings
  , getField
  , getFieldInt
  , getFieldStr
  , getFieldBool
  , getFieldArray
  ) where

import Prelude

import Effect (Effect)
import React.Basic.Events (EventHandler, handler, unsafeEventFn)
import Yoga.React.Native.Events (nativeEvent)

foreign import getField :: forall r. String -> r -> Number
foreign import getFieldInt :: forall r. String -> r -> Int
foreign import getFieldStr :: forall r. String -> r -> String
foreign import getFieldBool :: forall r. String -> r -> Boolean
foreign import getFieldArray :: forall r. String -> r -> Array String

onNumber :: String -> (Number -> Effect Unit) -> EventHandler
onNumber key cb = handler (nativeEvent >>> unsafeEventFn (getField key)) cb

onInt :: String -> (Int -> Effect Unit) -> EventHandler
onInt key cb = handler (nativeEvent >>> unsafeEventFn (getFieldInt key)) cb

onString :: String -> (String -> Effect Unit) -> EventHandler
onString key cb = handler (nativeEvent >>> unsafeEventFn (getFieldStr key)) cb

onBool :: String -> (Boolean -> Effect Unit) -> EventHandler
onBool key cb = handler (nativeEvent >>> unsafeEventFn (getFieldBool key)) cb

onStrings :: String -> (Array String -> Effect Unit) -> EventHandler
onStrings key cb = handler (nativeEvent >>> unsafeEventFn (getFieldArray key)) cb
