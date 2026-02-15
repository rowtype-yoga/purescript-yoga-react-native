module Yoga.React.Native.MacOS.MapView (nativeMapView, NativeMapViewAttributes) where

import Foreign (Foreign)
import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import _mapViewImpl :: forall props. ReactComponent props

nativeMapView :: FFINativeComponent_ NativeMapViewAttributes
nativeMapView = createNativeElement_ _mapViewImpl

type NativeMapViewAttributes = BaseAttributes
  ( latitude :: Number
  , longitude :: Number
  , latitudeDelta :: Number
  , longitudeDelta :: Number
  , mapType :: String
  , showsUserLocation :: Boolean
  , annotations :: Foreign
  , onRegionChange :: EventHandler
  , onSelectAnnotation :: EventHandler
  )
