module Yoga.React.Native.IOS.CollectionView
  ( collectionView
  , CollectionViewAttributes
  , CollectionViewItem
  , CollectionViewSelection
  ) where

import Prelude

import Effect (Effect)
import React.Basic (ReactComponent)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)
import Yoga.React.Native.Style (Style)

type CollectionViewItem =
  { id :: String
  , title :: String
  }

type CollectionViewSelection =
  { id :: String
  , index :: Int
  }

type CollectionViewAttributes =
  ( items :: Array CollectionViewItem
  , selectedId :: String
  , refreshing :: Boolean
  , onSelectItem :: CollectionViewSelection -> Effect Unit
  , onRefresh :: Effect Unit
  , style :: Style
  , accessibilityLabel :: String
  )

foreign import collectionViewImpl :: forall props. ReactComponent props

collectionView :: FFINativeComponent_ CollectionViewAttributes
collectionView = createNativeElement_ collectionViewImpl
