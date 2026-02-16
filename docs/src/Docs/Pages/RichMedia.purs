module Docs.Pages.RichMedia where

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Attributes as DA
import Docs.Components.Layout as L
import Docs.Components.PropsTable (propsTable)

page :: Nut
page =
  D.div_
    [ L.section "Rich Media" [ D.p_ [ D.text_ "Maps, documents, web content, camera, and animations." ] ]
    , mapView
    , pdfView
    , webView
    , cameraView
    , riveView
    ]

mapView :: Nut
mapView = L.componentDoc "nativeMapView" "Yoga.React.Native.MacOS.MapView (nativeMapView)"
  """mapType /\ setMapType <- useState' 0
let mt = case mapType of
      1 -> T.satelliteMap
      2 -> T.hybridMap
      _ -> T.standardMap

nativeMapView
  { latitude: 37.7749
  , longitude: -122.4194
  , latitudeDelta: 0.05
  , longitudeDelta: 0.05
  , mapType: mt
  , showsUserLocation: false
  , annotations:
      [ { latitude: 37.7749, longitude: -122.4194
        , title: "San Francisco", subtitle: "California"
        }
      , { latitude: 37.8199, longitude: -122.4783
        , title: "Golden Gate Bridge", subtitle: ""
        }
      ]
  }"""
  [ propsTable
      [ { name: "latitude", type_: "Number", description: "Center latitude" }
      , { name: "longitude", type_: "Number", description: "Center longitude" }
      , { name: "latitudeDelta", type_: "Number", description: "Latitude span" }
      , { name: "longitudeDelta", type_: "Number", description: "Longitude span" }
      , { name: "mapType", type_: "MapType", description: "Map display type" }
      , { name: "showsUserLocation", type_: "Boolean", description: "Show user location dot" }
      , { name: "annotations", type_: "Array MapAnnotation", description: "Map pins ({ latitude, longitude, title, subtitle })" }
      , { name: "onRegionChange", type_: "MapRegion -> Effect Unit", description: "Region change callback ({ latitude, longitude, latitudeDelta, longitudeDelta })" }
      , { name: "onSelectAnnotation", type_: "String -> Effect Unit", description: "Annotation tap callback" }
      ]
  ]

pdfView :: Nut
pdfView = L.componentDoc "nativePDFView" "Yoga.React.Native.MacOS.PDFView (nativePDFView)"
  """nativePDFView
  { source: "https://example.com/document.pdf"
  , autoScales: true
  , displayMode: T.singlePageContinuous
  , onPageChange: setPage
  }"""
  [ propsTable
      [ { name: "source", type_: "String", description: "PDF file path or URL" }
      , { name: "autoScales", type_: "Boolean", description: "Auto-fit to view" }
      , { name: "displayMode", type_: "PDFDisplayMode", description: "PDF display mode" }
      , { name: "onPageChange", type_: "Int -> Effect Unit", description: "Page change callback" }
      ]
  ]

webView :: Nut
webView = L.componentDoc "nativeWebView" "Yoga.React.Native.MacOS.WebView (nativeWebView)"
  """url /\ setUrl <- useState' "https://pursuit.purescript.org"
urlBar /\ setUrlBar <- useState' "https://pursuit.purescript.org"

nativeTextField
  { text: urlBar
  , onChangeText: setUrlBar
  , onSubmit: setUrl
  }
nativeWebView
  { url
  , onFinishLoad: setUrlBar
  }"""
  [ propsTable
      [ { name: "url", type_: "String", description: "URL to load" }
      , { name: "onNavigate", type_: "String -> Effect Unit", description: "Navigation callback" }
      , { name: "onFinishLoad", type_: "String -> Effect Unit", description: "Page load complete callback" }
      ]
  ]

cameraView :: Nut
cameraView = L.componentDoc "nativeCameraView" "Yoga.React.Native.MacOS.CameraView (nativeCameraView)"
  """nativeCameraView
  { active: true }"""
  [ propsTable
      [ { name: "active", type_: "Boolean", description: "Activate/deactivate camera capture" }
      ]
  ]

riveView :: Nut
riveView = L.componentDoc "nativeRiveView / nativeRiveView_" "Yoga.React.Native.MacOS.Rive (nativeRiveView, nativeRiveView_)"
  """-- nativeRiveView_ (no children)
nativeRiveView_
  { resourceName: "animation"
  , stateMachineName: "State Machine 1"
  , fit: T.contain
  , autoplay: true
  }

-- nativeRiveView (with children, FFINativeComponent)
nativeRiveView
  { url: "https://example.com/animation.riv"
  , autoplay: true
  }
  [ overlayContent ]"""
  [ propsTable
      [ { name: "resourceName", type_: "String", description: "Bundled .riv resource name" }
      , { name: "url", type_: "String", description: "Remote .riv file URL" }
      , { name: "artboardName", type_: "String", description: "Artboard name" }
      , { name: "stateMachineName", type_: "String", description: "State machine name" }
      , { name: "fit", type_: "RiveFit", description: "How the animation fits its bounds" }
      , { name: "autoplay", type_: "Boolean", description: "Start playing automatically" }
      ]
  , D.p [ DA.klass_ "text-sm text-gray-400 mt-2" ]
      [ D.text_ "nativeRiveView takes children as second arg; nativeRiveView_ takes props only." ]
  ]
