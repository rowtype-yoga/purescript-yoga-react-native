module Demo.SpringAnimation (springDemo) where

import Prelude

import Demo.Shared (DemoProps, scrollWrap, sectionTitle, desc)
import React.Basic (JSX)
import Yoga.React (component)
import Yoga.React.Native (text, tw)
import Yoga.React.Native.Style as Style

springDemo :: DemoProps -> JSX
springDemo = component "SpringDemo" \dp -> React.do
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Spring Animations"
      , desc dp "Testing without Reanimated"
      , text { style: tw "text-sm" <> Style.style { color: dp.fg } } "If you see this, the app works without Reanimated"
      ]
