module Yoga.React.Native.MacOS.Sheet
  ( nativeSheet
  , NativeSheetAttributes
  ) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, createNativeElement)

foreign import sheetImpl :: forall props. ReactComponent props

nativeSheet :: FFINativeComponent NativeSheetAttributes
nativeSheet = createNativeElement sheetImpl

type NativeSheetAttributes = BaseAttributes
  ( visible :: Boolean
  , onDismiss :: EventHandler
  )
