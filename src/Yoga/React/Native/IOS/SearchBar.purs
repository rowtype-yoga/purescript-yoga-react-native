module Yoga.React.Native.IOS.SearchBar
  ( searchBar
  , SearchBarAttributes
  ) where

import Prelude

import Effect (Effect)
import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

type SearchBarAttributes = BaseAttributes
  ( text :: String
  , placeholder :: String
  , showsCancelButton :: Boolean
  , enabled :: Boolean
  , onChangeText :: String -> Effect Unit
  , onSubmit :: String -> Effect Unit
  , onCancel :: Effect Unit
  )

foreign import searchBarImpl :: forall props. ReactComponent props

searchBar :: FFINativeComponent_ SearchBarAttributes
searchBar = createNativeElement_ searchBarImpl
