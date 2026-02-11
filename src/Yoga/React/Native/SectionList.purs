module Yoga.React.Native.SectionList (sectionList, SectionListAttributes, SectionData) where

import Prelude

import Data.Function.Uncurried (Fn1, Fn2)
import Effect.Uncurried (EffectFn1)
import React.Basic (JSX, ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)
import Yoga.React.Native.Style (Style)

foreign import _sectionListImpl :: forall props. ReactComponent props

sectionList :: forall a. FFINativeComponent_ (SectionListAttributes a)
sectionList = createNativeElement_ _sectionListImpl

type SectionData a =
  { title :: String
  , data :: Array a
  }

type SectionListAttributes a = BaseAttributes
  ( sections :: Array (SectionData a)
  , renderItem :: Fn1 { item :: a, index :: Int, section :: SectionData a } JSX
  , renderSectionHeader :: Fn1 { section :: SectionData a } JSX
  , renderSectionFooter :: Fn1 { section :: SectionData a } JSX
  , keyExtractor :: Fn2 a Int String
  , contentContainerStyle :: Style
  , stickySectionHeadersEnabled :: Boolean
  , onEndReached :: EffectFn1 { distanceFromEnd :: Number } Unit
  , onEndReachedThreshold :: Number
  , refreshing :: Boolean
  , onRefresh :: EffectFn1 Unit Unit
  , initialNumToRender :: Int
  )
