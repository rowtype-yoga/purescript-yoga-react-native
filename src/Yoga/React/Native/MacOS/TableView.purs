module Yoga.React.Native.MacOS.TableView
  ( nativeTableView
  , NativeTableViewAttributes
  , TableColumn
  ) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import tableViewImpl :: forall props. ReactComponent props

nativeTableView :: FFINativeComponent_ NativeTableViewAttributes
nativeTableView = createNativeElement_ tableViewImpl

type TableColumn =
  { id :: String
  , title :: String
  , width :: Number
  }

type NativeTableViewAttributes = BaseAttributes
  ( columns :: Array TableColumn
  , rows :: Array (Array String)
  , headerVisible :: Boolean
  , alternatingRows :: Boolean
  , onSelectRow :: EventHandler
  , onDoubleClickRow :: EventHandler
  )
