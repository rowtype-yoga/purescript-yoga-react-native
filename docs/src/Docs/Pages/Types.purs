module Docs.Pages.Types where

import Prelude

data Page
  = Overview
  | QuickStart
  | InputControls
  | TextEditing
  | Display
  | LayoutPage
  | Overlays
  | DataViews
  | FilesAndDragDrop
  | RichMedia
  | SystemServices
  | AiMl

derive instance Eq Page
