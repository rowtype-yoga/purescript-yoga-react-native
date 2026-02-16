module Demo.Display
  ( imageDemo
  , animatedImageDemo
  , videoPlayerDemo
  , levelIndicatorDemo
  , progressDemo
  , separatorDemo
  , pathControlDemo
  ) where

import Prelude

import Demo.Shared (DemoProps, card, desc, scrollWrap, sectionTitle)
import React.Basic (JSX)
import React.Basic.Hooks (useState', (/\))
import React.Basic.Hooks as React
import Yoga.React (component)
import Yoga.React.Native (text, tw, view)
import Yoga.React.Native.MacOS.AnimatedImage (nativeAnimatedImage)
import Yoga.React.Native.MacOS.Events as E
import Yoga.React.Native.MacOS.Image (nativeImage)
import Yoga.React.Native.MacOS.LevelIndicator (nativeLevelIndicator)
import Yoga.React.Native.MacOS.PathControl (nativePathControl)
import Yoga.React.Native.MacOS.Progress (nativeProgress)
import Yoga.React.Native.MacOS.Separator (nativeSeparator)
import Yoga.React.Native.MacOS.Slider (nativeSlider)
import Yoga.React.Native.MacOS.Types as T
import Yoga.React.Native.MacOS.VideoPlayer (nativeVideoPlayer)
import Yoga.React.Native.Style as Style

imageDemo :: DemoProps -> JSX
imageDemo = component "ImageDemo" \dp -> pure do
  scrollWrap dp
    [ sectionTitle dp.fg "Image"
    , desc dp "Native NSImageView with URL loading and corner radius"
    , nativeImage
        { source: "https://placedog.net/640/400"
        , contentMode: T.scaleProportionally
        , cornerRadius: 12.0
        , style: Style.style { height: 200.0 } <> tw "mb-2"
        }
    ]

animatedImageDemo :: DemoProps -> JSX
animatedImageDemo = component "AnimatedImageDemo" \dp -> pure do
  scrollWrap dp
    [ sectionTitle dp.fg "Animated Image"
    , desc dp "Native NSImageView with animated GIF support"
    , nativeAnimatedImage
        { source: "https://media.giphy.com/media/JIX9t2j0ZTN9S/giphy.gif"
        , animating: true
        , style: Style.style { height: 200.0 } <> tw "rounded-lg overflow-hidden mb-2"
        }
    , nativeAnimatedImage
        { source: "https://media.giphy.com/media/13CoXDiaCcCoyk/giphy.gif"
        , animating: true
        , style: Style.style { height: 200.0 } <> tw "rounded-lg overflow-hidden mb-2"
        }
    ]

videoPlayerDemo :: DemoProps -> JSX
videoPlayerDemo = component "VideoPlayerDemo" \_ -> pure do
  view { style: tw "flex-1" }
    [ nativeVideoPlayer
        { source: "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4"
        , playing: true
        , looping: true
        , muted: false
        , controlsStyle: T.floatingControls
        , style: tw "flex-1"
        }
    ]

levelIndicatorDemo :: DemoProps -> JSX
levelIndicatorDemo = component "LevelIndicatorDemo" \dp -> React.do
  value /\ setValue <- useState' 50.0
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Level Indicator"
      , card dp.cardBg
          [ nativeSlider
              { value
              , minValue: 0.0
              , maxValue: 100.0
              , numberOfTickMarks: 11
              , onChange: E.onNumber "value" setValue
              , style: Style.style { height: 24.0 }
              }
          , nativeLevelIndicator
              { value
              , minValue: 0.0
              , maxValue: 100.0
              , warningValue: 70.0
              , criticalValue: 90.0
              , style: Style.style { height: 18.0, marginTop: 8.0 }
              }
          ]
      ]

progressDemo :: DemoProps -> JSX
progressDemo = component "ProgressDemo" \dp -> React.do
  value /\ setValue <- useState' 50.0
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Progress"
      , card dp.cardBg
          [ nativeSlider
              { value
              , minValue: 0.0
              , maxValue: 100.0
              , numberOfTickMarks: 11
              , onChange: E.onNumber "value" setValue
              , style: Style.style { height: 24.0 }
              }
          , nativeProgress
              { value
              , style: Style.style { height: 18.0, marginTop: 8.0 }
              }
          ]
      ]

separatorDemo :: DemoProps -> JSX
separatorDemo = component "SeparatorDemo" \dp -> pure do
  scrollWrap dp
    [ sectionTitle dp.fg "Separator"
    , desc dp "Horizontal and vertical separators"
    , nativeSeparator
        { vertical: false
        , style: Style.style { height: 2.0 } <> tw "my-2"
        }
    , text { style: tw "text-xs mb-2" <> Style.style { color: dp.dimFg } } "Content between separators"
    , nativeSeparator
        { vertical: false
        , style: Style.style { height: 2.0 } <> tw "my-2"
        }
    ]

pathControlDemo :: DemoProps -> JSX
pathControlDemo = component "PathControlDemo" \dp -> pure do
  scrollWrap dp
    [ sectionTitle dp.fg "Path Control"
    , nativePathControl
        { url: "/Users"
        , pathStyle: T.standardPath
        , onSelectPath: E.onString "url" \_ -> pure unit
        , style: Style.style { height: 24.0 } <> tw "mb-2"
        }
    ]
