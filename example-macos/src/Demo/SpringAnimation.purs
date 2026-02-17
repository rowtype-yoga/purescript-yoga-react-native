module Demo.SpringAnimation (springDemo) where

import Prelude

import Demo.Shared (DemoProps, card, desc, scrollWrap, sectionTitle)
import React.Basic (JSX)
import React.Basic.Events (handler_)
import React.Basic.Hooks ((/\), useState')
import React.Basic.Hooks as React
import Yoga.React (component)
import Yoga.React.Native (text, tw, view)
import Yoga.React.Native.MacOS.Button (nativeButton)
import Yoga.React.Native.MacOS.Types as T
import Yoga.React.Native.Pressable (pressable)
import Yoga.React.Native.Reanimated as R
import Yoga.React.Native.Style as Style

springDemo :: DemoProps -> JSX
springDemo = component "SpringDemo" \dp -> React.do
  pressed /\ setPressed <- useState' false
  toggled /\ setToggled <- useState' false
  fadeIn /\ setFadeIn <- useState' false
  showItems /\ setShowItems <- useState' false
  scale <- R.useSharedValue 1.0
  translateX <- R.useSharedValue 0.0
  opacity <- R.useSharedValue 0.0
  item0 <- R.useSharedValue 0.0
  item1 <- R.useSharedValue 0.0
  item2 <- R.useSharedValue 0.0
  item3 <- R.useSharedValue 0.0
  pure do
    let
      springScale target = R.springTo scale target { stiffness: 400.0, damping: 15.0 }
      springToggle on = R.springTo translateX (if on then 200.0 else 0.0) { stiffness: 180.0, damping: 14.0 }
      springFade on = R.springTo opacity (if on then 1.0 else 0.0) { stiffness: 120.0, damping: 20.0 }
      springItems on = do
        R.springTo item0 (if on then 1.0 else 0.0) { stiffness: 200.0, damping: 18.0 }
        R.springTo item1 (if on then 1.0 else 0.0) { stiffness: 180.0, damping: 18.0 }
        R.springTo item2 (if on then 1.0 else 0.0) { stiffness: 160.0, damping: 18.0 }
        R.springTo item3 (if on then 1.0 else 0.0) { stiffness: 140.0, damping: 18.0 }
    scrollWrap dp
      [ sectionTitle dp.fg "Spring Animations"
      , desc dp "Reanimated 4 — springs run on the UI thread"

      , sectionTitle dp.fg "Scale on Press"
      , desc dp "Hold down the card — it springs to 0.92x, release to bounce back"
      , pressable
          { onPressIn: handler_ (setPressed true *> springScale 0.92)
          , onPressOut: handler_ (setPressed false *> springScale 1.0)
          }
          [ R.reanimatedView
              { style: Style.style { transform: [ { scale } ] } }
              [ card dp.cardBg
                  [ view { style: tw "items-center py-4" }
                      [ text { style: tw "text-sm font-semibold" <> Style.style { color: dp.fg } }
                          (if pressed then "Pressing..." else "Hold me!")
                      , text { style: tw "text-xs mt-1" <> Style.style { color: dp.dimFg } }
                          "Reanimated withSpring on UI thread"
                      ]
                  ]
              ]
          ]

      , sectionTitle dp.fg "Spring Toggle"
      , desc dp "Slides a box 200px to the right with a spring"
      , nativeButton
          { title: if toggled then "Spring Left" else "Spring Right"
          , bezelStyle: T.push
          , onPress: do
              let next = not toggled
              setToggled next
              springToggle next
          , style: Style.style { height: 24.0, width: 140.0, marginBottom: 8.0 }
          }
      , R.reanimatedView_
          { style: tw "rounded-lg"
              <> Style.style
                { width: 60.0
                , height: 60.0
                , backgroundColor: "#007AFF"
                , transform: [ { translateX } ]
                }
          }

      , sectionTitle dp.fg "Fade In"
      , desc dp "Springs opacity from 0 to 1"
      , nativeButton
          { title: if fadeIn then "Fade Out" else "Fade In"
          , bezelStyle: T.push
          , onPress: do
              let next = not fadeIn
              setFadeIn next
              springFade next
          , style: Style.style { height: 24.0, width: 120.0, marginBottom: 8.0 }
          }
      , R.reanimatedView
          { style: Style.style { opacity } }
          [ card dp.cardBg
              [ view { style: tw "items-center py-3" }
                  [ text { style: tw "text-sm" <> Style.style { color: dp.fg } } "I fade with a spring curve"
                  ]
              ]
          ]

      , sectionTitle dp.fg "Staggered Items"
      , desc dp "Each item springs in with increasing delay"
      , nativeButton
          { title: if showItems then "Hide Items" else "Show Items"
          , bezelStyle: T.push
          , onPress: do
              let next = not showItems
              setShowItems next
              springItems next
          , style: Style.style { height: 24.0, width: 120.0, marginBottom: 8.0 }
          }
      , staggeredItem "PureScript" "#007AFF" item0
      , staggeredItem "React Native" "#34C759" item1
      , staggeredItem "macOS" "#FF9500" item2
      , staggeredItem "Spring Physics" "#AF52DE" item3
      ]
  where
  staggeredItem title color sv =
    R.reanimatedView
      { style: Style.style
          { opacity: sv
          , marginBottom: 4.0
          }
      }
      [ view
          { style: tw "rounded-lg px-4 py-2 flex-row items-center"
              <> Style.style { backgroundColor: color }
          }
          [ text { style: tw "text-sm font-semibold" <> Style.style { color: "#FFFFFF" } } title
          ]
      ]
