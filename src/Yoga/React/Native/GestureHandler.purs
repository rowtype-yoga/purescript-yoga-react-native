module Yoga.React.Native.GestureHandler
  ( PanSample
  , NativeSnapPan
  , UseNativeSnapPan
  , selectSnapPoint
  , useNativeSnapPan
  , gestureHandlerRootView
  , panGestureView
  , position
  , SwipeDirection(..)
  , SwipeConfig
  , NativeSwipe
  , UseNativeSwipe
  , useNativeSwipe
  , swipeGestureView
  , swipePosition
  , swipeProgress
  ) where

import Prelude

import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NEA
import Data.Function.Uncurried (Fn2, runFn2)
import Data.Number (abs)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn3, mkEffectFn1, runEffectFn3)
import React.Basic (JSX)
import React.Basic.Hooks (Hook, unsafeHook)
import Unsafe.Coerce (unsafeCoerce)
import Yoga.React.Native.Animated (Animated, AnimatedValue, Points(..), Progress, SpringModel, SpringModelImpl, Velocity(..), springModelImpl)

type PanSample =
  { position :: Points
  , velocity :: Velocity Points
  }

foreign import data NativeSnapPan :: Type
foreign import data UseNativeSnapPan :: Type -> Type

data SwipeDirection
  = SwipeLeft
  | SwipeRight

derive instance Eq SwipeDirection
derive instance Ord SwipeDirection

instance Show SwipeDirection where
  show SwipeLeft = "SwipeLeft"
  show SwipeRight = "SwipeRight"

type SwipeConfig =
  { dismissalDistance :: Points
  , dismissalVelocity :: Velocity Points
  , returnSpring :: SpringModel Points
  , dismissalSpring :: SpringModel Points
  }

foreign import data NativeSwipe :: Type
foreign import data UseNativeSwipe :: Type -> Type

type SwipeConfigImpl =
  { dismissalDistance :: Number
  , dismissalVelocity :: Number
  , returnSpring :: SpringModelImpl
  , dismissalSpring :: SpringModelImpl
  }

foreign import useNativeSwipeImpl
  :: EffectFn3 SwipeConfigImpl (EffectFn1 Unit Unit) (EffectFn1 Unit Unit) NativeSwipe

foreign import swipePositionImpl :: NativeSwipe -> AnimatedValue
foreign import swipeProgressImpl :: NativeSwipe -> AnimatedValue
foreign import swipeGestureViewImpl :: Fn2 NativeSwipe JSX JSX

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

useNativeSwipe
  :: SwipeConfig
  -> (SwipeDirection -> Effect Unit)
  -> Hook UseNativeSwipe NativeSwipe
useNativeSwipe config onDismiss =
  unsafeHook $ runEffectFn3 useNativeSwipeImpl configImpl onLeft onRight
  where
  configImpl =
    { dismissalDistance: unwrapPoints config.dismissalDistance
    , dismissalVelocity: unwrapVelocity config.dismissalVelocity
    , returnSpring: springModelImpl config.returnSpring
    , dismissalSpring: springModelImpl config.dismissalSpring
    }

  onLeft = mkEffectFn1 \_ -> onDismiss SwipeLeft
  onRight = mkEffectFn1 \_ -> onDismiss SwipeRight

  unwrapPoints (Points value) = value
  unwrapVelocity (Velocity value) = value

swipeGestureView :: NativeSwipe -> JSX -> JSX
swipeGestureView = runFn2 swipeGestureViewImpl

swipePosition :: NativeSwipe -> Animated Points
swipePosition = unsafeCoerce <<< swipePositionImpl

swipeProgress :: NativeSwipe -> Animated Progress
swipeProgress = unsafeCoerce <<< swipeProgressImpl
