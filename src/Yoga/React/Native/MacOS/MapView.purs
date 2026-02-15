module Yoga.React.Native.MacOS.MapView
  ( nativeMapView
  , NativeMapViewAttributes
  , MapAnnotation
  ) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)
import Yoga.React.Native.MacOS.Types (MapType)

foreign import _mapViewImpl :: forall props. ReactComponent props

nativeMapView :: FFINativeComponent_ NativeMapViewAttributes
nativeMapView = createNativeElement_ _mapViewImpl

type MapAnnotation =
  { latitude :: Number
  , longitude :: Number
  , title :: String
  , subtitle :: String
  }

type NativeMapViewAttributes = BaseAttributes
  ( latitude :: Number
  , longitude :: Number
  , latitudeDelta :: Number
  , longitudeDelta :: Number
  , mapType :: MapType
  , showsUserLocation :: Boolean
  , annotations :: Array MapAnnotation
  , onRegionChange :: EventHandler
  , onSelectAnnotation :: EventHandler
  )
