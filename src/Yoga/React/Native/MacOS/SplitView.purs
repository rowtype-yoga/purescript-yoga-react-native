module Yoga.React.Native.MacOS.SplitView
  ( splitView
  ) where

import Prelude

import Data.Tuple.Nested ((/\))
import Effect.Uncurried (mkEffectFn2)
import Effect.Unsafe (unsafePerformEffect)
import React.Basic (JSX)
import React.Basic.Events (EventHandler, handler, handler_, unsafeEventFn)
import React.Basic.Hooks as React
import Unsafe.Coerce (unsafeCoerce)
import Yoga.React (component)
import Yoga.React.Native (view, tw)
import Yoga.React.Native.PanResponder as Pan
import Yoga.React.Native.Style as Style

type SplitViewProps =
  { initialPosition :: Number
  , minLeftWidth :: Number
  , minRightWidth :: Number
  , left :: JSX
  , right :: JSX
  }

splitView :: SplitViewProps -> JSX
splitView = component "SplitView" \props -> React.do
  sidebarWidth /\ setSidebarWidth <- React.useState' props.initialPosition
  hovered /\ setHovered <- React.useState' false
  widthRef <- React.useRef props.initialPosition
  startWidthRef <- React.useRef 0.0
  containerWidthRef <- React.useRef 1000.0

  React.useEffect sidebarWidth do
    React.writeRef widthRef sidebarWidth
    pure (pure unit)

  let dividerWidth = 5.0
  let clampWidth w = do
        cw <- React.readRef containerWidthRef
        let maxW = cw - props.minRightWidth - dividerWidth
        pure (clamp props.minLeftWidth maxW w)

  pr <- React.useMemo unit \_ -> unsafePerformEffect $ Pan.create
    { onStartShouldSetPanResponder: mkEffectFn2 \_ _ -> pure true
    , onMoveShouldSetPanResponder: mkEffectFn2 \_ _ -> pure true
    , onPanResponderGrant: mkEffectFn2 \_ _ -> do
        w <- React.readRef widthRef
        React.writeRef startWidthRef w
    , onPanResponderMove: mkEffectFn2 \_ (gs :: Pan.GestureState) -> do
        sw <- React.readRef startWidthRef
        newWidth <- clampWidth (sw + gs.dx)
        setSidebarWidth newWidth
    }

  let handlers = toResponderHandlers (Pan.panHandlers pr)
  let dColor = if hovered then "rgba(128,128,128,0.6)" else "rgba(128,128,128,0.3)"

  let onLayout = handler (unsafeEventFn layoutWidth) \w ->
        React.writeRef containerWidthRef w

  pure do
    view { style: tw "flex-1 flex-row", onLayout }
      [ view
          { style: Style.style { width: sidebarWidth, overflow: "hidden" }
          , allowsVibrancy: true
          }
          [ props.left ]
      , view
          { style: Style.style { width: 5.0, cursor: "col-resize", alignItems: "center", justifyContent: "center" }
          , onStartShouldSetResponder: handlers.onStartShouldSetResponder
          , onMoveShouldSetResponder: handlers.onMoveShouldSetResponder
          , onResponderGrant: handlers.onResponderGrant
          , onResponderMove: handlers.onResponderMove
          , onResponderRelease: handlers.onResponderRelease
          , onResponderTerminate: handlers.onResponderTerminate
          , onResponderTerminationRequest: handlers.onResponderTerminationRequest
          , onMouseEnter: handler_ (setHovered true)
          , onMouseLeave: handler_ (setHovered false)
          }
          [ view
              { style: Style.style { width: 1.0, height: "100%", backgroundColor: dColor }
              , pointerEvents: "none"
              }
              (mempty :: Array JSX)
          ]
      , view
          { style: tw "flex-1" <> Style.style { overflow: "hidden" } }
          [ props.right ]
      ]

-- PanResponder.panHandlers returns responder-named event handlers
-- but the PureScript type uses pan-prefixed names, so we coerce
layoutWidth :: forall a. a -> Number
layoutWidth e = (unsafeCoerce e).nativeEvent.layout.width

toResponderHandlers :: Pan.PanResponderHandlers -> ResponderHandlers
toResponderHandlers = unsafeCoerce

type ResponderHandlers =
  { onStartShouldSetResponder :: EventHandler
  , onMoveShouldSetResponder :: EventHandler
  , onResponderGrant :: EventHandler
  , onResponderMove :: EventHandler
  , onResponderRelease :: EventHandler
  , onResponderTerminate :: EventHandler
  , onResponderTerminationRequest :: EventHandler
  }
