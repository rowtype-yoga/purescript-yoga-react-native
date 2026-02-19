module Yoga.React.Native.MacOS.GhosttyTerminal (ghosttyTerminal, GhosttyTerminalAttributes) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import _ghosttyTerminalImpl :: forall props. ReactComponent props

ghosttyTerminal :: FFINativeComponent_ GhosttyTerminalAttributes
ghosttyTerminal = createNativeElement_ _ghosttyTerminalImpl

type GhosttyTerminalAttributes = BaseAttributes
  ( cwd :: String
  , command :: String
  , fontSize :: Number
  , fontFamily :: String
  , onTitle :: EventHandler
  , onBell :: EventHandler
  , onExit :: EventHandler
  )
