module Docs.Pages.Display where

import Deku.Core (Nut)
import Deku.DOM as D
import Docs.Components.Layout as L
import Docs.Components.PropsTable (propsTable)

page :: Nut
page =
  D.div_
    [ L.section "Display" [ D.p_ [ D.text_ "Visual display components for images, video, progress, and more." ] ]
    , image
    , animatedImage
    , videoPlayer
    , levelIndicator
    , progress
    , separator
    , pathControl
    ]

image :: Nut
image = L.componentDoc "nativeImage" "Yoga.React.Native.MacOS.Image (nativeImage)"
  """nativeImage
  { source: "path/to/image.png"
  , contentMode: T.scaleAspectFit
  , cornerRadius: 8.0
  }"""
  [ propsTable
      [ { name: "source", type_: "String", description: "Image file path or URL" }
      , { name: "contentMode", type_: "ImageContentMode", description: "How the image fills its bounds" }
      , { name: "cornerRadius", type_: "Number", description: "Corner radius in points" }
      ]
  ]

animatedImage :: Nut
animatedImage = L.componentDoc "nativeAnimatedImage" "Yoga.React.Native.MacOS.AnimatedImage (nativeAnimatedImage)"
  """nativeAnimatedImage
  { source: "loading.gif"
  , animating: true
  , cornerRadius: 4.0
  }"""
  [ propsTable
      [ { name: "source", type_: "String", description: "Animated image file path" }
      , { name: "animating", type_: "Boolean", description: "Start/stop animation" }
      , { name: "cornerRadius", type_: "Number", description: "Corner radius in points" }
      ]
  ]

videoPlayer :: Nut
videoPlayer = L.componentDoc "nativeVideoPlayer" "Yoga.React.Native.MacOS.VideoPlayer (nativeVideoPlayer)"
  """nativeVideoPlayer
  { source: "https://example.com/video.mp4"
  , playing: true
  , looping: false
  , muted: false
  , controlsStyle: T.floating
  }"""
  [ propsTable
      [ { name: "source", type_: "String", description: "Video file path or URL" }
      , { name: "playing", type_: "Boolean", description: "Play/pause state" }
      , { name: "looping", type_: "Boolean", description: "Loop playback" }
      , { name: "muted", type_: "Boolean", description: "Mute audio" }
      , { name: "cornerRadius", type_: "Number", description: "Corner radius in points" }
      , { name: "controlsStyle", type_: "ControlsStyle", description: "Player controls style" }
      ]
  ]

levelIndicator :: Nut
levelIndicator = L.componentDoc "nativeLevelIndicator" "Yoga.React.Native.MacOS.LevelIndicator (nativeLevelIndicator)"
  """nativeLevelIndicator
  { value: 7.0
  , minValue: 0.0
  , maxValue: 10.0
  , warningValue: 7.0
  , criticalValue: 9.0
  }"""
  [ propsTable
      [ { name: "value", type_: "Number", description: "Current level" }
      , { name: "minValue", type_: "Number", description: "Minimum value" }
      , { name: "maxValue", type_: "Number", description: "Maximum value" }
      , { name: "warningValue", type_: "Number", description: "Warning threshold" }
      , { name: "criticalValue", type_: "Number", description: "Critical threshold" }
      ]
  ]

progress :: Nut
progress = L.componentDoc "nativeProgress" "Yoga.React.Native.MacOS.Progress (nativeProgress)"
  """nativeProgress
  { value: 0.65
  , indeterminate: false
  , spinning: false
  }"""
  [ propsTable
      [ { name: "value", type_: "Number", description: "Progress value 0.0\x20131.0" }
      , { name: "indeterminate", type_: "Boolean", description: "Indeterminate mode (ignores value)" }
      , { name: "spinning", type_: "Boolean", description: "Spinning indicator style" }
      ]
  ]

separator :: Nut
separator = L.componentDoc "nativeSeparator" "Yoga.React.Native.MacOS.Separator (nativeSeparator)"
  """nativeSeparator
  { vertical: false }"""
  [ propsTable
      [ { name: "vertical", type_: "Boolean", description: "Vertical or horizontal separator" }
      ]
  ]

pathControl :: Nut
pathControl = L.componentDoc "nativePathControl" "Yoga.React.Native.MacOS.PathControl (nativePathControl)"
  """nativePathControl
  { url: "/Users/you/Documents"
  , pathStyle: T.standard
  , onSelectPath: setPath
  }"""
  [ propsTable
      [ { name: "url", type_: "String", description: "File path URL to display" }
      , { name: "pathStyle", type_: "PathControlStyle", description: "Visual style of the path control" }
      , { name: "onSelectPath", type_: "String -> Effect Unit", description: "Path segment selection callback" }
      ]
  ]
