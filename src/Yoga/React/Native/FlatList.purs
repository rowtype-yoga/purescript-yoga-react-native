module Yoga.React.Native.FlatList (flatList, FlatListAttributes) where

import Prelude

import Data.Function.Uncurried (Fn1, Fn2)
import Effect.Uncurried (EffectFn1)
import React.Basic (JSX, ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)
import Yoga.React.Native.Style (Style)

foreign import _flatListImpl :: forall props. ReactComponent props

flatList :: forall a. FFINativeComponent_ (FlatListAttributes a)
flatList = createNativeElement_ _flatListImpl

type FlatListAttributes a = BaseAttributes
  ( data :: Array a
  , renderItem :: Fn1 { item :: a, index :: Int } JSX
  , keyExtractor :: Fn2 a Int String
  , contentContainerStyle :: Style
  , horizontal :: Boolean
  , numColumns :: Int
  , onEndReached :: EffectFn1 { distanceFromEnd :: Number } Unit
  , onEndReachedThreshold :: Number
  , refreshing :: Boolean
  , onRefresh :: EffectFn1 Unit Unit
  )
