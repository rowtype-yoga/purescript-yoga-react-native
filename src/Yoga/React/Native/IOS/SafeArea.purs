module Yoga.React.Native.IOS.SafeArea
  ( safeAreaView
  , SafeAreaViewAttributes
  , Edges
  , allEdges
  , noEdges
  , topOnly
  , bottomOnly
  ) where

import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, createNativeElement)

foreign import data Edges :: Type

foreign import allEdges :: Edges
foreign import noEdges :: Edges
foreign import topOnly :: Edges
foreign import bottomOnly :: Edges

foreign import safeAreaViewImpl :: forall props. ReactComponent props

safeAreaView :: FFINativeComponent SafeAreaViewAttributes
safeAreaView = createNativeElement safeAreaViewImpl

type SafeAreaViewAttributes = BaseAttributes
  ( edges :: Edges
  , mode :: String
  )
