module Yoga.React.Native.MacOS.TableView
  ( nativeTableView
  , NativeTableViewAttributes
  , TableColumn
  ) where

import Prelude
import Effect (Effect)
import React.Basic (ReactComponent)
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
  , onSelectRow :: Int -> Effect Unit
  , onDoubleClickRow :: Int -> Effect Unit
  )
