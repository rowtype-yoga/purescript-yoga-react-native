module Demo.MapsDocs (mapViewDemo, pdfViewDemo) where

import Prelude

import Demo.Shared (DemoProps)
import React.Basic (JSX)
import React.Basic.Hooks (useState', (/\))
import React.Basic.Hooks as React
import Yoga.React (component)
import Yoga.React.Native (text, tw, view)
import Yoga.React.Native.MacOS.MapView (nativeMapView)
import Yoga.React.Native.MacOS.PDFView (nativePDFView)
import Yoga.React.Native.MacOS.Segmented (nativeSegmented)
import Yoga.React.Native.MacOS.Types as T
import Yoga.React.Native.Style as Style

mapViewDemo :: DemoProps -> JSX
mapViewDemo = component "MapViewDemo" \dp -> React.do
  mapType /\ setMapType <- useState' 0
  let
    mt = case mapType of
      1 -> T.satelliteMap
      2 -> T.hybridMap
      _ -> T.standardMap
  pure do
    view { style: tw "flex-1" }
      [ view { style: tw "flex-row items-center px-3 py-2" <> Style.style { backgroundColor: "transparent" } }
          [ text { style: tw "text-sm font-semibold mr-3" <> Style.style { color: dp.fg } } "Map View"
          , nativeSegmented
              { labels: [ "Standard", "Satellite", "Hybrid" ]
              , selectedIndex: mapType
              , onChange: setMapType
              , style: Style.style { width: 240.0, height: 24.0 }
              }
          ]
      , nativeMapView
          { latitude: 37.7749
          , longitude: -122.4194
          , latitudeDelta: 0.05
          , longitudeDelta: 0.05
          , mapType: mt
          , showsUserLocation: false
          , annotations:
              [ { latitude: 37.7749, longitude: -122.4194, title: "San Francisco", subtitle: "California" }
              , { latitude: 37.8199, longitude: -122.4783, title: "Golden Gate Bridge", subtitle: "" }
              ]
          , style: tw "flex-1"
          }
      ]

pdfViewDemo :: DemoProps -> JSX
pdfViewDemo = component "PDFViewDemo" \dp -> pure do
  view { style: tw "flex-1" }
    [ view { style: tw "flex-row items-center px-3 py-2" <> Style.style { backgroundColor: "transparent" } }
        [ text { style: tw "text-sm font-semibold" <> Style.style { color: dp.fg } } "PDF Viewer" ]
    , nativePDFView
        { source: "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"
        , autoScales: true
        , displayMode: T.singlePageContinuous
        , style: tw "flex-1"
        }
    ]
