module Docs.App where

import Data.Tuple.Nested ((/\))
import Deku.Core (Nut)
import Deku.Hooks ((<#~>), useState)
import Deku.Do as Deku
import Docs.Components.Layout as L
import Docs.Components.Sidebar as Sidebar
import Docs.Pages.AiMl as AiMl
import Docs.Pages.DataViews as DataViews
import Docs.Pages.Display as Display
import Docs.Pages.FilesAndDragDrop as FilesAndDragDrop
import Docs.Pages.InputControls as InputControls
import Docs.Pages.LayoutPage as LayoutPage
import Docs.Pages.Overlays as Overlays
import Docs.Pages.Overview as Overview
import Docs.Pages.QuickStart as QuickStart
import Docs.Pages.RichMedia as RichMedia
import Docs.Pages.SystemServices as SystemServices
import Docs.Pages.TextEditing as TextEditing
import Docs.Pages.Types (Page(..))

app :: Nut
app = Deku.do
  setPage /\ currentPage <- useState Overview
  L.pageShell
    (Sidebar.sidebar setPage)
    (currentPage <#~> renderPage)

renderPage :: Page -> Nut
renderPage = case _ of
  Overview -> Overview.page
  QuickStart -> QuickStart.page
  InputControls -> InputControls.page
  TextEditing -> TextEditing.page
  Display -> Display.page
  LayoutPage -> LayoutPage.page
  Overlays -> Overlays.page
  DataViews -> DataViews.page
  FilesAndDragDrop -> FilesAndDragDrop.page
  RichMedia -> RichMedia.page
  SystemServices -> SystemServices.page
  AiMl -> AiMl.page
