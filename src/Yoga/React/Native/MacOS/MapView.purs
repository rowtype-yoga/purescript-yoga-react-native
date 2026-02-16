module Yoga.React.Native.MacOS.MapView
  ( nativeMapView
  , NativeMapViewAttributes
  , MapAnnotation
  , MapRegion
  ) where

import Prelude
import Effect (Effect)
import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)
import Yoga.React.Native.MacOS.Types (MapType)

foreign import mapViewImpl :: forall props. ReactComponent props

nativeMapView :: FFINativeComponent_ NativeMapViewAttributes
nativeMapView = createNativeElement_ mapViewImpl

type MapAnnotation =
  { latitude :: Number
  , longitude :: Number
  , title :: String
  , subtitle :: String
  }

type MapRegion =
  { latitude :: Number
  , longitude :: Number
  , latitudeDelta :: Number
  , longitudeDelta :: Number
  }

type NativeMapViewAttributes = BaseAttributes
  ( latitude :: Number
  , longitude :: Number
  , latitudeDelta :: Number
  , longitudeDelta :: Number
  , mapType :: MapType
  , showsUserLocation :: Boolean
  , annotations :: Array MapAnnotation
  , onRegionChange :: MapRegion -> Effect Unit
  , onSelectAnnotation :: String -> Effect Unit
  )
