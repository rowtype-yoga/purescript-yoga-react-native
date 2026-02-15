module Yoga.React.Native.MacOS.PopUp (nativePopUp, NativePopUpAttributes) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import popUpImpl :: forall props. ReactComponent props

nativePopUp :: FFINativeComponent_ NativePopUpAttributes
nativePopUp = createNativeElement_ popUpImpl

type NativePopUpAttributes = BaseAttributes
  ( items :: Array String
  , selectedIndex :: Int
  , onChange :: EventHandler
  )
