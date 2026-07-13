module Yoga.React.Native.Animated
  ( AnimatedValue
  , AnimatedValueXY
  , CompositeAnimation
  , Animated
  , toAnimatedValue
  , Opacity(..)
  , Scale(..)
  , Points(..)
  , Degrees(..)
  , Progress(..)
  , Stiffness(..)
  , Damping(..)
  , Mass(..)
  , Tension(..)
  , Friction(..)
  , Bounciness(..)
  , SpringSpeed(..)
  , Milliseconds(..)
  , Velocity(..)
  , SpringModel
  , SpringModelImpl
  , springModelImpl
  , physicalSpring
  , tensionSpring
  , bouncySpring
  , withSpringDelay
  , withSpringVelocity
  , useOpacitySpring
  , useScaleSpring
  , useTranslationSpring
  , useProgressSpring
  , UseTypedSpring
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
  , interpolateRotation
  , RotationInterpolationConfig
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
  , useSpring
  , UseSpring
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
import Yoga.React.Native.Internal (class IsJSX, FFINativeComponent, FFINativeComponent_, createNativeElement, createNativeElement_)

foreign import data AnimatedValue :: Type
foreign import data AnimatedValueXY :: Type
foreign import data CompositeAnimation :: Type

newtype Animated :: Type -> Type
newtype Animated a = Animated AnimatedValue

toAnimatedValue :: forall a. Animated a -> AnimatedValue
toAnimatedValue (Animated value) = value

newtype Opacity = Opacity Number
newtype Scale = Scale Number
newtype Points = Points Number
newtype Degrees = Degrees Number
newtype Progress = Progress Number

newtype Stiffness = Stiffness Number
newtype Damping = Damping Number
newtype Mass = Mass Number
newtype Tension = Tension Number
newtype Friction = Friction Number
newtype Bounciness = Bounciness Number
newtype SpringSpeed = SpringSpeed Number
newtype Milliseconds = Milliseconds Int
newtype Velocity :: Type -> Type
newtype Velocity a = Velocity Number

data SpringFamily
  = Physical Stiffness Damping Mass
  | TensionFriction Tension Friction
  | Bouncy SpringSpeed Bounciness

newtype SpringModel :: Type -> Type
newtype SpringModel a = SpringModel
  { family :: SpringFamily
  , delay :: Int
  , velocity :: Number
  }

physicalSpring :: forall a. { stiffness :: Stiffness, damping :: Damping, mass :: Mass } -> SpringModel a
physicalSpring { stiffness, damping, mass } =
  SpringModel { family: Physical stiffness damping mass, delay: 0, velocity: 0.0 }

tensionSpring :: forall a. { tension :: Tension, friction :: Friction } -> SpringModel a
tensionSpring { tension, friction } =
  SpringModel { family: TensionFriction tension friction, delay: 0, velocity: 0.0 }

bouncySpring :: forall a. { speed :: SpringSpeed, bounciness :: Bounciness } -> SpringModel a
bouncySpring { speed, bounciness } =
  SpringModel { family: Bouncy speed bounciness, delay: 0, velocity: 0.0 }

withSpringDelay :: forall a. Milliseconds -> SpringModel a -> SpringModel a
withSpringDelay (Milliseconds milliseconds) (SpringModel model) = SpringModel (model { delay = milliseconds })

withSpringVelocity :: forall a. Velocity a -> SpringModel a -> SpringModel a
withSpringVelocity (Velocity velocity) (SpringModel model) = SpringModel (model { velocity = velocity })

type SpringModelImpl =
  { family :: String
  , stiffness :: Number
  , damping :: Number
  , mass :: Number
  , tension :: Number
  , friction :: Number
  , speed :: Number
  , bounciness :: Number
  , delay :: Int
  , velocity :: Number
  }

springModelImpl :: forall a. SpringModel a -> SpringModelImpl
springModelImpl (SpringModel model) = case model.family of
  Physical (Stiffness stiffness) (Damping damping) (Mass mass) ->
    { family: "physical", stiffness, damping, mass
    , tension: 0.0, friction: 0.0, speed: 0.0, bounciness: 0.0
    , delay: model.delay, velocity: model.velocity
    }
  TensionFriction (Tension tension) (Friction friction) ->
    { family: "tension", stiffness: 0.0, damping: 0.0, mass: 0.0
    , tension, friction, speed: 0.0, bounciness: 0.0
    , delay: model.delay, velocity: model.velocity
    }
  Bouncy (SpringSpeed speed) (Bounciness bounciness) ->
    { family: "bouncy", stiffness: 0.0, damping: 0.0, mass: 0.0
    , tension: 0.0, friction: 0.0, speed, bounciness
    , delay: model.delay, velocity: model.velocity
    }

instance IsJSX AnimatedValue

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

type RotationInterpolationConfig =
  { inputRange :: Array Points
  , outputRange :: Array Degrees
  , extrapolate :: String
  }

foreign import interpolateRotationImpl
  :: AnimatedValue
  -> { inputRange :: Array Number, outputRange :: Array Number, extrapolate :: String }
  -> AnimatedValue

interpolateRotation :: Animated Points -> RotationInterpolationConfig -> AnimatedValue
interpolateRotation (Animated value) config =
  interpolateRotationImpl value
    { inputRange: map (\(Points point) -> point) config.inputRange
    , outputRange: map (\(Degrees degrees) -> degrees) config.outputRange
    , extrapolate: config.extrapolate
    }

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

foreign import useSpringImpl :: forall r. Number -> { | r } -> Effect AnimatedValue

foreign import data UseSpring :: Type -> Type

useSpring :: forall r. Number -> { | r } -> Hook UseSpring AnimatedValue
useSpring target config = unsafeHook (useSpringImpl target config)

foreign import useTypedSpringImpl :: Number -> SpringModelImpl -> Boolean -> Effect AnimatedValue

foreign import data UseTypedSpring :: Type -> Type

useOpacitySpring :: Opacity -> SpringModel Opacity -> Hook UseTypedSpring (Animated Opacity)
useOpacitySpring (Opacity target) model = typedSpring target model

useScaleSpring :: Scale -> SpringModel Scale -> Hook UseTypedSpring (Animated Scale)
useScaleSpring (Scale target) model = typedSpring target model

useTranslationSpring :: Points -> SpringModel Points -> Hook UseTypedSpring (Animated Points)
useTranslationSpring (Points target) model = typedSpring target model

useProgressSpring :: Progress -> SpringModel Progress -> Hook UseTypedSpring (Animated Progress)
useProgressSpring (Progress target) model = typedSpring target model

typedSpring :: forall a. Number -> SpringModel a -> Hook UseTypedSpring (Animated a)
typedSpring target model = unsafeHook (Animated <$> useTypedSpringImpl target (springModelImpl model) true)
