module Yoga.React.Native.MacOS.PDFView
  ( nativePDFView
  , NativePDFViewAttributes
  ) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
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
  , onPageChange :: EventHandler
  )
