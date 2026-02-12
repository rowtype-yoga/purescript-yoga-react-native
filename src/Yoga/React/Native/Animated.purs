module Yoga.React.Native.Animated
  ( AnimatedValue
  , AnimatedValueXY
  , CompositeAnimation
  , newValue
  , newValueXY
  , setValue
  , setValueXY
  , setOffset
  , flattenOffset
  , extractOffset
  , stopAnimation
  , resetAnimation
  , interpolate
  , timing
  , spring
  , decay
  , start
  , startWithCallback
  , stop
  , reset
  , parallel
  , sequence
  , stagger
  , delay
  , loop
  , add
  , subtract
  , multiply
  , divide
  , modulo
  , diffClamp
  , animatedView
  , animatedView_
  , animatedText
  , animatedText_
  , animatedImage
  , animatedScrollView
  , animatedScrollView_
  , useAnimatedValue
  , UseAnimatedValue
  , TimingConfig
  , SpringConfig
  , DecayConfig
  , InterpolationConfig
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, runEffectFn1, runEffectFn2)
import React.Basic (ReactComponent)
import React.Basic.Hooks (Hook, unsafeHook)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, FFINativeComponent_, createNativeElement, createNativeElement_)

foreign import data AnimatedValue :: Type
foreign import data AnimatedValueXY :: Type
foreign import data CompositeAnimation :: Type

foreign import newValueImpl :: EffectFn1 Number AnimatedValue

newValue :: Number -> Effect AnimatedValue
newValue = runEffectFn1 newValueImpl

foreign import newValueXYImpl :: EffectFn2 Number Number AnimatedValueXY

newValueXY :: Number -> Number -> Effect AnimatedValueXY
newValueXY = runEffectFn2 newValueXYImpl

foreign import setValueImpl :: EffectFn2 AnimatedValue Number Unit

setValue :: AnimatedValue -> Number -> Effect Unit
setValue = runEffectFn2 setValueImpl

foreign import setValueXYImpl :: EffectFn2 AnimatedValueXY { x :: Number, y :: Number } Unit

setValueXY :: AnimatedValueXY -> { x :: Number, y :: Number } -> Effect Unit
setValueXY = runEffectFn2 setValueXYImpl

foreign import setOffsetImpl :: EffectFn2 AnimatedValue Number Unit

setOffset :: AnimatedValue -> Number -> Effect Unit
setOffset = runEffectFn2 setOffsetImpl

foreign import flattenOffsetImpl :: EffectFn1 AnimatedValue Unit

flattenOffset :: AnimatedValue -> Effect Unit
flattenOffset = runEffectFn1 flattenOffsetImpl

foreign import extractOffsetImpl :: EffectFn1 AnimatedValue Unit

extractOffset :: AnimatedValue -> Effect Unit
extractOffset = runEffectFn1 extractOffsetImpl

foreign import stopAnimationImpl :: EffectFn1 AnimatedValue Unit

stopAnimation :: AnimatedValue -> Effect Unit
stopAnimation = runEffectFn1 stopAnimationImpl

foreign import resetAnimationImpl :: EffectFn1 AnimatedValue Unit

resetAnimation :: AnimatedValue -> Effect Unit
resetAnimation = runEffectFn1 resetAnimationImpl

type InterpolationConfig =
  { inputRange :: Array Number
  , outputRange :: Array Number
  , extrapolate :: String
  }

foreign import interpolateImpl :: AnimatedValue -> InterpolationConfig -> AnimatedValue

interpolate :: AnimatedValue -> InterpolationConfig -> AnimatedValue
interpolate = interpolateImpl

type TimingConfig =
  ( toValue :: Number
  , duration :: Int
  , delay :: Int
  , easing :: Number -> Number
  , useNativeDriver :: Boolean
  )

foreign import timingImpl :: forall r. AnimatedValue -> { | r } -> CompositeAnimation

timing :: forall r. AnimatedValue -> { | r } -> CompositeAnimation
timing = timingImpl

type SpringConfig =
  ( toValue :: Number
  , friction :: Number
  , tension :: Number
  , speed :: Number
  , bounciness :: Number
  , stiffness :: Number
  , damping :: Number
  , mass :: Number
  , overshootClamping :: Boolean
  , restDisplacementThreshold :: Number
  , restSpeedThreshold :: Number
  , delay :: Int
  , velocity :: Number
  , useNativeDriver :: Boolean
  )

foreign import springImpl :: forall r. AnimatedValue -> { | r } -> CompositeAnimation

spring :: forall r. AnimatedValue -> { | r } -> CompositeAnimation
spring = springImpl

type DecayConfig =
  ( velocity :: Number
  , deceleration :: Number
  , useNativeDriver :: Boolean
  )

foreign import decayImpl :: forall r. AnimatedValue -> { | r } -> CompositeAnimation

decay :: forall r. AnimatedValue -> { | r } -> CompositeAnimation
decay = decayImpl

foreign import startImpl :: EffectFn1 CompositeAnimation Unit

start :: CompositeAnimation -> Effect Unit
start = runEffectFn1 startImpl

foreign import startWithCallbackImpl :: EffectFn2 CompositeAnimation (EffectFn1 { finished :: Boolean } Unit) Unit

startWithCallback :: CompositeAnimation -> (EffectFn1 { finished :: Boolean } Unit) -> Effect Unit
startWithCallback = runEffectFn2 startWithCallbackImpl

foreign import stopImpl :: EffectFn1 CompositeAnimation Unit

stop :: CompositeAnimation -> Effect Unit
stop = runEffectFn1 stopImpl

foreign import resetImpl :: EffectFn1 CompositeAnimation Unit

reset :: CompositeAnimation -> Effect Unit
reset = runEffectFn1 resetImpl

foreign import parallelImpl :: Array CompositeAnimation -> CompositeAnimation

parallel :: Array CompositeAnimation -> CompositeAnimation
parallel = parallelImpl

foreign import sequenceImpl :: Array CompositeAnimation -> CompositeAnimation

sequence :: Array CompositeAnimation -> CompositeAnimation
sequence = sequenceImpl

foreign import staggerImpl :: Int -> Array CompositeAnimation -> CompositeAnimation

stagger :: Int -> Array CompositeAnimation -> CompositeAnimation
stagger = staggerImpl

foreign import delayImpl :: Int -> CompositeAnimation

delay :: Int -> CompositeAnimation
delay = delayImpl

foreign import loopImpl :: forall r. CompositeAnimation -> { | r } -> CompositeAnimation

loop :: forall r. CompositeAnimation -> { | r } -> CompositeAnimation
loop = loopImpl

foreign import addImpl :: AnimatedValue -> AnimatedValue -> AnimatedValue

add :: AnimatedValue -> AnimatedValue -> AnimatedValue
add = addImpl

foreign import subtractImpl :: AnimatedValue -> AnimatedValue -> AnimatedValue

subtract :: AnimatedValue -> AnimatedValue -> AnimatedValue
subtract = subtractImpl

foreign import multiplyImpl :: AnimatedValue -> AnimatedValue -> AnimatedValue

multiply :: AnimatedValue -> AnimatedValue -> AnimatedValue
multiply = multiplyImpl

foreign import divideImpl :: AnimatedValue -> AnimatedValue -> AnimatedValue

divide :: AnimatedValue -> AnimatedValue -> AnimatedValue
divide = divideImpl

foreign import moduloImpl :: AnimatedValue -> Number -> AnimatedValue

modulo :: AnimatedValue -> Number -> AnimatedValue
modulo = moduloImpl

foreign import diffClampImpl :: AnimatedValue -> Number -> Number -> AnimatedValue

diffClamp :: AnimatedValue -> Number -> Number -> AnimatedValue
diffClamp = diffClampImpl

foreign import _animatedViewImpl :: forall props. ReactComponent props
foreign import _animatedTextImpl :: forall props. ReactComponent props
foreign import _animatedImageImpl :: forall props. ReactComponent props
foreign import _animatedScrollViewImpl :: forall props. ReactComponent props

type AnimatedAttributes r = BaseAttributes
  ( opacity :: AnimatedValue
  | r
  )

animatedView :: FFINativeComponent (AnimatedAttributes ())
animatedView = createNativeElement _animatedViewImpl

animatedView_ :: FFINativeComponent_ (AnimatedAttributes ())
animatedView_ = createNativeElement_ _animatedViewImpl

animatedText :: FFINativeComponent (AnimatedAttributes ())
animatedText = createNativeElement _animatedTextImpl

animatedText_ :: FFINativeComponent_ (AnimatedAttributes ())
animatedText_ = createNativeElement_ _animatedTextImpl

animatedImage :: FFINativeComponent_ (AnimatedAttributes ())
animatedImage = createNativeElement_ _animatedImageImpl

animatedScrollView :: FFINativeComponent (AnimatedAttributes ())
animatedScrollView = createNativeElement _animatedScrollViewImpl

animatedScrollView_ :: FFINativeComponent_ (AnimatedAttributes ())
animatedScrollView_ = createNativeElement_ _animatedScrollViewImpl

foreign import useAnimatedValueImpl :: Number -> Effect AnimatedValue

foreign import data UseAnimatedValue :: Type -> Type

useAnimatedValue :: Number -> Hook UseAnimatedValue AnimatedValue
useAnimatedValue n = unsafeHook (useAnimatedValueImpl n)
