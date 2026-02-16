module Yoga.React.Native.MacOS.PopUp (nativePopUp, NativePopUpAttributes) where

import Prelude
import Effect (Effect)
import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import popUpImpl :: forall props. ReactComponent props

nativePopUp :: FFINativeComponent_ NativePopUpAttributes
nativePopUp = createNativeElement_ popUpImpl

type NativePopUpAttributes = BaseAttributes
  ( items :: Array String
  , selectedIndex :: Int
  , onChange :: Int -> Effect Unit
  )
