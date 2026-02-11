module Yoga.React.Native.Dimensions
  ( get
  , useWindowDimensions
  , UseWindowDimensions
  , ScaledSize
  ) where

import Effect (Effect)
import React.Basic.Hooks (Hook, unsafeHook)

type ScaledSize =
  { width :: Number
  , height :: Number
  , scale :: Number
  , fontScale :: Number
  }

foreign import getImpl :: String -> Effect ScaledSize

get :: String -> Effect ScaledSize
get = getImpl

foreign import useWindowDimensionsImpl :: Effect ScaledSize

foreign import data UseWindowDimensions :: Type -> Type

useWindowDimensions :: Hook UseWindowDimensions ScaledSize
useWindowDimensions = unsafeHook useWindowDimensionsImpl
