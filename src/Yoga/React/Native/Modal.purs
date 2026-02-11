module Yoga.React.Native.Modal (modal, modal_, ModalAttributes) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, FFINativeComponent_, createNativeElement, createNativeElement_)

foreign import _modalImpl :: forall props. ReactComponent props

modal :: FFINativeComponent ModalAttributes
modal = createNativeElement _modalImpl

modal_ :: FFINativeComponent_ ModalAttributes
modal_ = createNativeElement_ _modalImpl

type ModalAttributes = BaseAttributes
  ( visible :: Boolean
  , animationType :: String
  , transparent :: Boolean
  , onRequestClose :: EventHandler
  , onShow :: EventHandler
  , onDismiss :: EventHandler
  , presentationStyle :: String
  , supportedOrientations :: Array String
  , hardwareAccelerated :: Boolean
  , statusBarTranslucent :: Boolean
  )
