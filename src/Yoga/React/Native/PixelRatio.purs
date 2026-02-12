module Yoga.React.Native.PixelRatio
  ( get
  , getFontScale
  , getPixelSizeForLayoutSize
  , roundToNearestPixel
  ) where

foreign import get :: Number
foreign import getFontScale :: Number
foreign import getPixelSizeForLayoutSize :: Number -> Number
foreign import roundToNearestPixel :: Number -> Number
