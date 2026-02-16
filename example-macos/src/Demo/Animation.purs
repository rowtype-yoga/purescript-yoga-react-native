module Demo.Animation (riveDemo) where

import Prelude

import Demo.Shared (DemoProps, sectionTitle)
import React.Basic (JSX)
import Yoga.React (component)
import Yoga.React.Native (text, tw, view)
import Yoga.React.Native.MacOS.Rive (nativeRiveView_)
import Yoga.React.Native.MacOS.ScrollView (nativeScrollView)
import Yoga.React.Native.MacOS.Types as T
import Yoga.React.Native.Style as Style

riveDemo :: DemoProps -> JSX
riveDemo = component "RiveDemo" \dp -> pure do
  nativeScrollView { style: tw "flex-1" <> Style.style { backgroundColor: "transparent" } }
    ( view { style: tw "px-4 pb-4" }
        [ sectionTitle dp.fg "Mouse Tracking"
        , text { style: tw "text-xs mb-2" <> Style.style { color: dp.fg } }
            "Move your cursor over the cat — it follows your mouse!"
        , nativeRiveView_
            { resourceName: "cat_following_mouse"
            , stateMachineName: "State Machine 1"
            , fit: T.contain
            , autoplay: true
            , style: Style.style { height: 300.0 }
            }
        , sectionTitle dp.fg "Cursor Tracking"
        , text { style: tw "text-xs mb-2" <> Style.style { color: dp.fg } }
            "Shapes follow your cursor via Pointer Move listeners"
        , nativeRiveView_
            { resourceName: "cursor_tracking"
            , stateMachineName: "State Machine 1"
            , fit: T.contain
            , autoplay: true
            , style: Style.style { height: 300.0 }
            }
        , sectionTitle dp.fg "Interactive Rive Animations"
        , text { style: tw "text-xs mb-2" <> Style.style { color: dp.fg } }
            "Click the stars to rate! State machine handles interaction."
        , nativeRiveView_
            { resourceName: "rating_animation"
            , stateMachineName: "State Machine 1"
            , fit: T.contain
            , autoplay: true
            , style: Style.style { height: 200.0 }
            }
        , sectionTitle dp.fg "Light Switch"
        , text { style: tw "text-xs mb-2" <> Style.style { color: dp.fg } }
            "Click to toggle"
        , nativeRiveView_
            { resourceName: "switch_event_example"
            , stateMachineName: "State Machine 1"
            , fit: T.contain
            , autoplay: true
            , style: Style.style { height: 200.0 }
            }
        , sectionTitle dp.fg "Windy Tree"
        , nativeRiveView_
            { resourceName: "windy_tree"
            , fit: T.cover
            , autoplay: true
            , style: tw "flex-1" <> Style.style { minHeight: 300.0, backgroundColor: dp.bg }
            }
        ]
    )
