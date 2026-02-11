module Yoga.React.Native.Appearance
  ( getColorScheme
  , setColorScheme
  , useColorScheme
  , UseColorScheme
  ) where

import Prelude

import Effect (Effect)
import Data.Nullable (Nullable)
import React.Basic.Hooks (Hook, unsafeHook)

foreign import getColorScheme :: Effect (Nullable String)

foreign import setColorScheme :: Nullable String -> Effect Unit

foreign import useColorSchemeImpl :: Effect (Nullable String)

foreign import data UseColorScheme :: Type -> Type

useColorScheme :: Hook UseColorScheme (Nullable String)
useColorScheme = unsafeHook useColorSchemeImpl
