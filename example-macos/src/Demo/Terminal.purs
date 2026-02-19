module Demo.Terminal (terminalDemo) where

import Prelude

import Demo.Shared (DemoProps, sectionTitle)
import React.Basic (JSX)
import Yoga.React (component)
import Yoga.React.Native (tw, view)
import Yoga.React.Native.MacOS.GhosttyTerminal (ghosttyTerminal)
import Yoga.React.Native.Style as Style

terminalDemo :: DemoProps -> JSX
terminalDemo = component "TerminalDemo" \dp -> pure do
  view { style: tw "flex-1 px-4" }
    [ sectionTitle dp.fg "Ghostty Terminal"
    , ghosttyTerminal
        { style: tw "flex-1" <> Style.style { minHeight: 400.0 }
        }
    ]
