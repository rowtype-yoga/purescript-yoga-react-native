module Yoga.React.Native.GestureHandler
  ( PanSample
  , NativeSnapPan
  , UseNativeSnapPan
  , selectSnapPoint
  , useNativeSnapPan
  , gestureHandlerRootView
  , panGestureView
  , position
  ) where

import Prelude

import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NEA
import Data.Number (abs)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, mkEffectFn1)
import React.Basic (JSX)
import React.Basic.Hooks (Hook, unsafeHook)
import Unsafe.Coerce (unsafeCoerce)
import Yoga.React.Native.Animated (Animated, AnimatedValue, Points(..), SpringModel, SpringModelImpl, Velocity(..), springModelImpl)

type PanSample =
  { position :: Points
  , velocity :: Velocity Points
  }

foreign import data NativeSnapPan :: Type
foreign import data UseNativeSnapPan :: Type -> Type

foreign import useNativeSnapPanImpl
  :: Number
  -> Array Number
  -> EffectFn1 { position :: Number, velocity :: Number } Number
  -> SpringModelImpl
  -> Effect NativeSnapPan

foreign import positionImpl :: NativeSnapPan -> AnimatedValue
foreign import gestureHandlerRootView :: JSX -> JSX
foreign import panGestureView :: NativeSnapPan -> JSX -> JSX

position :: NativeSnapPan -> Animated Points
position = unsafeCoerce <<< positionImpl


useNativeSnapPan
  :: Points
  -> NonEmptyArray Points
  -> Number
  -> SpringModel Points
  -> Hook UseNativeSnapPan NativeSnapPan
useNativeSnapPan (Points initial) snapPoints projectionSeconds model =
  unsafeHook $ useNativeSnapPanImpl initial numericSnapPoints chooseTarget (springModelImpl model)
  where
  numericSnapPoints = map (\(Points point) -> point) (NEA.toArray snapPoints)
  chooseTarget = mkEffectFn1 \sample -> do
    let Points target = selectSnapPoint snapPoints projectionSeconds
          { position: Points sample.position
          , velocity: Velocity sample.velocity
          }
    pure target

selectSnapPoint :: NonEmptyArray Points -> Number -> PanSample -> Points
selectSnapPoint snapPoints projectionSeconds { position: Points current, velocity: Velocity velocity } =
  NEA.foldl1 chooseNearest snapPoints
  where
  projected = current + velocity * projectionSeconds
  chooseNearest best@(Points bestValue) candidate@(Points candidateValue)
    | abs (candidateValue - projected) < abs (bestValue - projected) = candidate
    | otherwise = best
