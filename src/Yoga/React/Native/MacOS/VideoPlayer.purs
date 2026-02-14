module Yoga.React.Native.MacOS.VideoPlayer (nativeVideoPlayer, NativeVideoPlayerAttributes) where

import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import _videoPlayerImpl :: forall props. ReactComponent props

nativeVideoPlayer :: FFINativeComponent_ NativeVideoPlayerAttributes
nativeVideoPlayer = createNativeElement_ _videoPlayerImpl

type NativeVideoPlayerAttributes = BaseAttributes
  ( source :: String
  , playing :: Boolean
  , looping :: Boolean
  , muted :: Boolean
  , cornerRadius :: Number
  )
