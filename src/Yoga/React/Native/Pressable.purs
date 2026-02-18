module Yoga.React.Native.Pressable (pressable, pressable_, PressableAttributes) where

import Prelude
import Effect.Uncurried (EffectFn1)
import Foreign (Foreign)
import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, FFINativeComponent_, createNativeElement, createNativeElement_)

foreign import _pressableImpl :: forall props. ReactComponent props

pressable :: FFINativeComponent PressableAttributes
pressable = createNativeElement _pressableImpl

pressable_ :: FFINativeComponent_ PressableAttributes
pressable_ = createNativeElement_ _pressableImpl

type PressableAttributes = BaseAttributes
  ( onPress :: EventHandler
  , onPressIn :: EventHandler
  , onPressOut :: EventHandler
  , onLongPress :: EventHandler
  , onHoverIn :: EffectFn1 Foreign Unit
  , onHoverOut :: EffectFn1 Foreign Unit
  , disabled :: Boolean
  )
