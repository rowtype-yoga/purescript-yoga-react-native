module Yoga.React.Native.Android.DrawerLayout
  ( drawerLayout
  , DrawerLayoutAttributes
  , DrawerPosition
  , left
  , right
  ) where

import Prelude

import Effect (Effect)
import React.Basic (JSX, ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, createNativeElement)
import Yoga.React.Native.Style (Style)

foreign import data DrawerPosition :: Type

foreign import left :: DrawerPosition
foreign import right :: DrawerPosition

foreign import drawerLayoutImpl :: forall props. ReactComponent props

drawerLayout :: FFINativeComponent DrawerLayoutAttributes
drawerLayout = createNativeElement drawerLayoutImpl

type DrawerLayoutAttributes = BaseAttributes
  ( drawerWidth :: Number
  , drawerPosition :: DrawerPosition
  , drawerBackgroundColor :: String
  , drawerLockMode :: String
  , keyboardDismissMode :: String
  , onDrawerClose :: Effect Unit
  , onDrawerOpen :: Effect Unit
  , onDrawerSlide :: Number -> Effect Unit
  , onDrawerStateChanged :: String -> Effect Unit
  , renderNavigationView :: Unit -> JSX
  , statusBarBackgroundColor :: String
  , drawerStyle :: Style
  )
