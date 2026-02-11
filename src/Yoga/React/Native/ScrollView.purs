module Yoga.React.Native.ScrollView (scrollView, scrollView_, ScrollViewAttributes) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, FFINativeComponent_, createNativeElement, createNativeElement_)
import Yoga.React.Native.Style (Style)

foreign import _scrollViewImpl :: forall props. ReactComponent props

scrollView :: FFINativeComponent ScrollViewAttributes
scrollView = createNativeElement _scrollViewImpl

scrollView_ :: FFINativeComponent_ ScrollViewAttributes
scrollView_ = createNativeElement_ _scrollViewImpl

type ScrollViewAttributes = BaseAttributes
  ( contentContainerStyle :: Style
  , horizontal :: Boolean
  , showsVerticalScrollIndicator :: Boolean
  , showsHorizontalScrollIndicator :: Boolean
  , scrollEnabled :: Boolean
  , pagingEnabled :: Boolean
  , bounces :: Boolean
  , onScroll :: EventHandler
  )
