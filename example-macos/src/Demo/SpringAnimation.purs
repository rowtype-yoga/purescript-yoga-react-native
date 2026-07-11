module Demo.SpringAnimation (springDemo) where

import Prelude

import Demo.Shared (DemoProps, card, desc, scrollWrap, sectionTitle)
import React.Basic (JSX)
import React.Basic.Hooks (useState', (/\))
import React.Basic.Hooks as React
import Yoga.React (component)
import Yoga.React.Native (text, tw, view)
import Yoga.React.Native.Animated (Damping(..), Mass(..), Milliseconds(..), Opacity(..), Points(..), Progress(..), Scale(..), SpringModel, Stiffness(..), animatedView, animatedView_, interpolate, physicalSpring, toAnimatedValue, useOpacitySpring, useProgressSpring, useScaleSpring, useTranslationSpring, withSpringDelay)
import React.Basic.Events (handler_)
import Yoga.React.Native.Pressable (pressable)
import Yoga.React.Native.MacOS.Button (nativeButton)
import Yoga.React.Native.MacOS.Types as T
import Yoga.React.Native.Style as Style

springDemo :: DemoProps -> JSX
springDemo = component "SpringDemo" \dp -> React.do
  pressed /\ setPressed <- useState' false
  toggled /\ setToggled <- useState' false
  fadeIn /\ setFadeIn <- useState' false
  showItems /\ setShowItems <- useState' false
  let scaleTarget = if pressed then Scale 0.92 else Scale 1.0
  scale <- useScaleSpring scaleTarget (physical 400.0 15.0)
  let toggleTarget = if toggled then Points 200.0 else Points 0.0
  translateX <- useTranslationSpring toggleTarget (physical 180.0 14.0)
  let fadeTarget = if fadeIn then Opacity 1.0 else Opacity 0.0
  opacity <- useOpacitySpring fadeTarget (physical 120.0 20.0)
  item0 <- useProgressSpring (progressTarget showItems) (physical 200.0 18.0)
  item1 <- useProgressSpring (progressTarget showItems) (withSpringDelay (Milliseconds 50) (physical 180.0 18.0))
  item2 <- useProgressSpring (progressTarget showItems) (withSpringDelay (Milliseconds 100) (physical 160.0 18.0))
  item3 <- useProgressSpring (progressTarget showItems) (withSpringDelay (Milliseconds 150) (physical 140.0 18.0))
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Spring Animations"
      , desc dp "Typed spring physics on React Native's native animation driver"

      , sectionTitle dp.fg "Scale on Press"
      , desc dp "Hold down the card — it springs to 0.92x, release to bounce back"
      , pressable
          { onPressIn: handler_ (setPressed true)
          , onPressOut: handler_ (setPressed false)
          }
          [ animatedView
              { style: Style.style { transform: [ { scale } ] } }
              [ card dp.cardBg
                  [ view { style: tw "items-center py-4" }
                      [ text { style: tw "text-sm font-semibold" <> Style.style { color: dp.fg } }
                          (if pressed then "Pressing..." else "Hold me!")
                      , text { style: tw "text-xs mt-1" <> Style.style { color: dp.dimFg } }
                          "useScaleSpring (Scale 0.92) (physicalSpring ...)"
                      ]
                  ]
              ]
          ]

      , sectionTitle dp.fg "Spring Toggle"
      , desc dp "Slides a box 200px to the right with a spring"
      , nativeButton
          { title: if toggled then "Spring Left" else "Spring Right"
          , bezelStyle: T.push
          , onPress: setToggled (not toggled)
          , style: Style.style { height: 24.0, width: 140.0, marginBottom: 8.0 }
          }
      , animatedView_
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
          , onPress: setFadeIn (not fadeIn)
          , style: Style.style { height: 24.0, width: 120.0, marginBottom: 8.0 }
          }
      , animatedView
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
          , onPress: setShowItems (not showItems)
          , style: Style.style { height: 24.0, width: 120.0, marginBottom: 8.0 }
          }
      , staggeredItem dp "PureScript" "#007AFF" item0
      , staggeredItem dp "React Native" "#34C759" item1
      , staggeredItem dp "macOS" "#FF9500" item2
      , staggeredItem dp "Spring Physics" "#AF52DE" item3
      ]
  where
  staggeredItem _ title color anim =
    animatedView
      { style: Style.style
          { opacity: anim
          , transform: [ { translateX: slideX } ]
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
    where
    slideX = interpolate (toAnimatedValue anim) { inputRange: [ 0.0, 1.0 ], outputRange: [ -30.0, 0.0 ], extrapolate: "clamp" }

  physical :: forall a. Number -> Number -> SpringModel a
  physical stiffness damping = physicalSpring
    { stiffness: Stiffness stiffness
    , damping: Damping damping
    , mass: Mass 1.0
    }

  progressTarget :: Boolean -> Progress
  progressTarget enabled = if enabled then Progress 1.0 else Progress 0.0
