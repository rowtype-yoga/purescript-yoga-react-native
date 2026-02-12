module Yoga.React.Native.Easing
  ( EasingFunction
  , step0, step1, linear, ease, quad, cubic, poly
  , sin, circle, exp, elastic, back, bounce, bezier
  , easeIn, easeOut, easeInOut
  ) where

type EasingFunction = Number -> Number

foreign import step0 :: EasingFunction
foreign import step1 :: EasingFunction
foreign import linear :: EasingFunction
foreign import ease :: EasingFunction
foreign import quad :: EasingFunction
foreign import cubic :: EasingFunction
foreign import poly :: Number -> EasingFunction
foreign import sin :: EasingFunction
foreign import circle :: EasingFunction
foreign import exp :: EasingFunction
foreign import elastic :: Number -> EasingFunction
foreign import back :: Number -> EasingFunction
foreign import bounce :: EasingFunction
foreign import bezier :: Number -> Number -> Number -> Number -> EasingFunction
foreign import easeIn :: EasingFunction -> EasingFunction
foreign import easeOut :: EasingFunction -> EasingFunction
foreign import easeInOut :: EasingFunction -> EasingFunction
