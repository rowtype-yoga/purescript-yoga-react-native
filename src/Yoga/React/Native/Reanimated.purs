module Yoga.React.Native.Reanimated
  ( SharedValue
  , UseSharedValue
  , UseAnimatedStyle
  , AnimationValue
  , EasingFunction
  , ExtrapolationType
  , useSharedValue
  , useAnimatedStyle
  , readSharedValue
  , writeSharedValue
  , springTo
  , timingTo
  , cancelAnimation
  , withSpring
  , withTiming
  , withDecay
  , withDelay
  , withSequence
  , withRepeat
  , withClamp
  , interpolate
  , reanimatedView
  , reanimatedView_
  , reanimatedText
  , reanimatedText_
  , reanimatedImage
  , reanimatedScrollView
  , reanimatedScrollView_
  , animate
  , extrapolationClamp
  , extrapolationExtend
  , extrapolationIdentity
  , easingLinear
  , easingEase
  , easingQuad
  , easingCubic
  , easingSin
  , easingCircle
  , easingExp
  , easingBounce
  , easingIn
  , easingOut
  , easingInOut
  , easingBezier
  , LayoutAnimation
  , EnteringAnimation
  , ExitingAnimation
  , linearTransition
  , linearTransitionDuration
  , fadeIn
  , fadeOut
  , fadeInDown
  , fadeOutUp
  , fadeInDuration
  , fadeOutDuration
  , readValue
  ) where

import Prelude

import Effect (Effect)
import React.Basic (ReactComponent)
import React.Basic.Hooks (Hook, unsafeHook)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, FFINativeComponent_, createNativeElement, createNativeElement_)
import Yoga.React.Native.Style (Style)

-- | A shared value that lives on both the JS and UI threads.
foreign import data SharedValue :: Type -> Type

-- | An opaque animation value used to compose animations (withSpring, withTiming, etc.)
foreign import data AnimationValue :: Type

-- | Easing function for timing animations
foreign import data EasingFunction :: Type

-- | Extrapolation type for interpolation
foreign import data ExtrapolationType :: Type

-- | Layout animation config (e.g. LinearTransition)
foreign import data LayoutAnimation :: Type

-- | Entering animation config (e.g. FadeIn)
foreign import data EnteringAnimation :: Type

-- | Exiting animation config (e.g. FadeOut)
foreign import data ExitingAnimation :: Type

-- Hook phantom types
foreign import data UseSharedValue :: Type -> Type -> Type
foreign import data UseAnimatedStyle :: Type -> Type

-- Hooks

foreign import useSharedValueImpl :: forall a. a -> Effect (SharedValue a)

useSharedValue :: forall a. a -> Hook (UseSharedValue a) (SharedValue a)
useSharedValue initial = unsafeHook (useSharedValueImpl initial)

foreign import useAnimatedStyleImpl :: (Unit -> Style) -> Effect Style

useAnimatedStyle :: (Unit -> Style) -> Hook UseAnimatedStyle Style
useAnimatedStyle updater = unsafeHook (useAnimatedStyleImpl updater)

-- Shared value operations

foreign import readSharedValue :: forall a. SharedValue a -> Effect a
foreign import writeSharedValue :: forall a. SharedValue a -> a -> Effect Unit

-- | Pure read of a shared value's .value — for use inside useAnimatedStyle worklets
foreign import readValue :: forall a. SharedValue a -> a

-- | Animate a shared value to a target with spring physics
foreign import writeSharedValueWithSpring :: forall r. SharedValue Number -> Number -> { | r } -> Effect Unit

springTo :: forall r. SharedValue Number -> Number -> { | r } -> Effect Unit
springTo = writeSharedValueWithSpring

-- | Animate a shared value to a target with timing
foreign import writeSharedValueWithTiming :: forall r. SharedValue Number -> Number -> { | r } -> Effect Unit

timingTo :: forall r. SharedValue Number -> Number -> { | r } -> Effect Unit
timingTo = writeSharedValueWithTiming

-- | Write a composed animation value to a shared value
foreign import animateImpl :: forall a. SharedValue a -> AnimationValue -> Effect Unit

animate :: forall a. SharedValue a -> AnimationValue -> Effect Unit
animate = animateImpl

-- | Cancel any running animation on a shared value
foreign import cancelAnimationImpl :: forall a. SharedValue a -> Effect Unit

cancelAnimation :: forall a. SharedValue a -> Effect Unit
cancelAnimation = cancelAnimationImpl

-- Animation builders (for composing into sequences, repeats, etc.)

foreign import withSpringImpl :: forall r. Number -> { | r } -> AnimationValue
foreign import withTimingImpl :: forall r. Number -> { | r } -> AnimationValue
foreign import withDecayImpl :: forall r. { | r } -> AnimationValue
foreign import withDelayImpl :: Int -> AnimationValue -> AnimationValue
foreign import withSequenceImpl :: Array AnimationValue -> AnimationValue
foreign import withRepeatImpl :: AnimationValue -> Int -> Boolean -> AnimationValue

withSpring :: forall r. Number -> { | r } -> AnimationValue
withSpring = withSpringImpl

withTiming :: forall r. Number -> { | r } -> AnimationValue
withTiming = withTimingImpl

withDecay :: forall r. { | r } -> AnimationValue
withDecay = withDecayImpl

withDelay :: Int -> AnimationValue -> AnimationValue
withDelay = withDelayImpl

withSequence :: Array AnimationValue -> AnimationValue
withSequence = withSequenceImpl

withRepeat :: AnimationValue -> Int -> Boolean -> AnimationValue
withRepeat = withRepeatImpl

foreign import withClampImpl :: forall r. { | r } -> AnimationValue -> AnimationValue

withClamp :: forall r. { | r } -> AnimationValue -> AnimationValue
withClamp = withClampImpl

-- Interpolation

foreign import interpolateImpl :: Number -> Array Number -> Array Number -> ExtrapolationType -> Number

interpolate :: Number -> Array Number -> Array Number -> ExtrapolationType -> Number
interpolate = interpolateImpl

foreign import extrapolationClamp :: ExtrapolationType
foreign import extrapolationExtend :: ExtrapolationType
foreign import extrapolationIdentity :: ExtrapolationType

-- Easing

foreign import easingLinear :: EasingFunction
foreign import easingEase :: EasingFunction
foreign import easingQuad :: EasingFunction
foreign import easingCubic :: EasingFunction
foreign import easingSin :: EasingFunction
foreign import easingCircle :: EasingFunction
foreign import easingExp :: EasingFunction
foreign import easingBounce :: EasingFunction
foreign import easingIn :: EasingFunction -> EasingFunction
foreign import easingOut :: EasingFunction -> EasingFunction
foreign import easingInOut :: EasingFunction -> EasingFunction
foreign import easingBezier :: Number -> Number -> Number -> Number -> EasingFunction

-- Layout animation imports

foreign import linearTransition :: LayoutAnimation
foreign import linearTransitionDuration :: Int -> LayoutAnimation
foreign import fadeIn :: EnteringAnimation
foreign import fadeOut :: ExitingAnimation
foreign import fadeInDown :: EnteringAnimation
foreign import fadeOutUp :: ExitingAnimation
foreign import fadeInDuration :: Int -> EnteringAnimation
foreign import fadeOutDuration :: Int -> ExitingAnimation

-- Animated components

type ReanimatedAttributes r = BaseAttributes
  ( opacity :: SharedValue Number
  , layout :: LayoutAnimation
  , entering :: EnteringAnimation
  , exiting :: ExitingAnimation
  | r
  )

foreign import _reanimatedViewImpl :: forall props. ReactComponent props
foreign import _reanimatedTextImpl :: forall props. ReactComponent props
foreign import _reanimatedImageImpl :: forall props. ReactComponent props
foreign import _reanimatedScrollViewImpl :: forall props. ReactComponent props

reanimatedView :: FFINativeComponent (ReanimatedAttributes ())
reanimatedView = createNativeElement _reanimatedViewImpl

reanimatedView_ :: FFINativeComponent_ (ReanimatedAttributes ())
reanimatedView_ = createNativeElement_ _reanimatedViewImpl

reanimatedText :: FFINativeComponent (ReanimatedAttributes ())
reanimatedText = createNativeElement _reanimatedTextImpl

reanimatedText_ :: FFINativeComponent_ (ReanimatedAttributes ())
reanimatedText_ = createNativeElement_ _reanimatedTextImpl

reanimatedImage :: FFINativeComponent_ (ReanimatedAttributes ())
reanimatedImage = createNativeElement_ _reanimatedImageImpl

reanimatedScrollView :: FFINativeComponent (ReanimatedAttributes ())
reanimatedScrollView = createNativeElement _reanimatedScrollViewImpl

reanimatedScrollView_ :: FFINativeComponent_ (ReanimatedAttributes ())
reanimatedScrollView_ = createNativeElement_ _reanimatedScrollViewImpl
