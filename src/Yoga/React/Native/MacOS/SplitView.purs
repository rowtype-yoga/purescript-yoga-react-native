module Yoga.React.Native.MacOS.SplitView
  ( nativeSplitView
  , NativeSplitViewAttributes
  , DividerPosition
  ) where

import Prelude (Unit)
import Effect (Effect)
import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, createNativeElement)

foreign import splitViewImpl :: forall props. ReactComponent props

nativeSplitView :: FFINativeComponent NativeSplitViewAttributes
nativeSplitView = createNativeElement splitViewImpl

type DividerPosition = { position :: Number }

type NativeSplitViewAttributes = BaseAttributes
  ( initialPosition :: Number
  , minPaneWidth :: Number
  , dividerThickness :: Number
  , dividerColor :: String
  , dividerHoverColor :: String
  , onDividerPosition :: DividerPosition -> Effect Unit
  )
