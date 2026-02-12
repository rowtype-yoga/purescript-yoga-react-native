module Yoga.React.Native.PanResponder
  ( PanResponder
  , PanResponderHandlers
  , GestureState
  , create
  , panHandlers
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)
import React.Basic.Events (EventHandler)

type GestureState =
  { stateID :: Number
  , moveX :: Number
  , moveY :: Number
  , x0 :: Number
  , y0 :: Number
  , dx :: Number
  , dy :: Number
  , vx :: Number
  , vy :: Number
  , numberActiveTouches :: Int
  }

foreign import data PanResponder :: Type

type PanResponderHandlers =
  { onStartShouldSetPanResponder :: EventHandler
  , onMoveShouldSetPanResponder :: EventHandler
  , onPanResponderGrant :: EventHandler
  , onPanResponderMove :: EventHandler
  , onPanResponderRelease :: EventHandler
  , onPanResponderTerminate :: EventHandler
  , onPanResponderTerminationRequest :: EventHandler
  }

foreign import createImpl :: forall r. EffectFn1 { | r } PanResponder

create :: forall r. { | r } -> Effect PanResponder
create = runEffectFn1 createImpl

foreign import panHandlers :: PanResponder -> PanResponderHandlers
