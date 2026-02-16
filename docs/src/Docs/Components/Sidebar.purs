module Docs.Components.Sidebar where

import Prelude

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Attributes as DA
import Deku.DOM.Listeners as DL
import Docs.Pages.Types (Page(..))
import Effect (Effect)

sidebar :: (Page -> Effect Unit) -> Nut
sidebar setPage =
  D.nav [ DA.klass_ "flex flex-col py-4" ]
    [ navSection "Getting Started"
        [ navItem Overview "Overview"
        , navItem QuickStart "Quick Start"
        ]
    , navSection "macOS Components"
        [ navItem InputControls "Input Controls"
        , navItem TextEditing "Text"
        , navItem Display "Display"
        , navItem LayoutPage "Layout"
        , navItem Overlays "Overlays"
        , navItem DataViews "Data Views"
        , navItem FilesAndDragDrop "Files & Drag/Drop"
        , navItem RichMedia "Rich Media"
        ]
    , navSection "APIs"
        [ navItem SystemServices "System Services"
        , navItem AiMl "AI & ML"
        ]
    ]
  where
  navSection title items =
    D.div [ DA.klass_ "mb-2" ]
      ( [ D.h4 [ DA.klass_ "text-[11px] font-semibold uppercase tracking-wide text-gray-500 px-5 py-1" ]
            [ D.text_ title ]
        ] <> items
      )

  navItem pg label =
    D.a
      [ DA.klass_ "block px-5 pl-7 py-1.5 text-sm text-gray-300 cursor-pointer hover:bg-gray-800 hover:text-brand transition-colors"
      , DL.click_ \_ -> setPage pg
      ]
      [ D.text_ label ]
