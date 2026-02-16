module Yoga.React.Native.MacOS.PDFView
  ( nativePDFView
  , NativePDFViewAttributes
  ) where

import Prelude
import Effect (Effect)
import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)
import Yoga.React.Native.MacOS.Types (PDFDisplayMode)

foreign import pdfViewImpl :: forall props. ReactComponent props

nativePDFView :: FFINativeComponent_ NativePDFViewAttributes
nativePDFView = createNativeElement_ pdfViewImpl

type NativePDFViewAttributes = BaseAttributes
  ( source :: String
  , autoScales :: Boolean
  , displayMode :: PDFDisplayMode
  , onPageChange :: Int -> Effect Unit
  )
