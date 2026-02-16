module Yoga.React.Native.MacOS.Sheet
  ( nativeSheet
  , NativeSheetAttributes
  ) where

import Prelude
import Effect (Effect)
import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, createNativeElement)

foreign import sheetImpl :: forall props. ReactComponent props

nativeSheet :: FFINativeComponent NativeSheetAttributes
nativeSheet = createNativeElement sheetImpl

type NativeSheetAttributes = BaseAttributes
  ( visible :: Boolean
  , onDismiss :: Effect Unit
  )
