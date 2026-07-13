module Yoga.React.Native.IOS.SafeArea
  ( safeAreaView
  , safeAreaProvider
  , Edge(..)
  , Edges(..)
  , allEdges
  , noEdges
  , topOnly
  , bottomOnly
  , SafeAreaMode(..)
  ) where

import Prelude

import Data.Array as Array
import Data.Function.Uncurried (Fn2, runFn2)
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype)
import Data.Set (Set)
import Data.Set as Set
import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, createNativeElement)

data Edge
  = Top
  | Right
  | Bottom
  | Left

derive instance Eq Edge
derive instance Ord Edge
instance Show Edge where
  show Top = "Top"
  show Right = "Right"
  show Bottom = "Bottom"
  show Left = "Left"

newtype Edges = Edges (Set Edge)

derive instance Newtype Edges _
derive newtype instance Eq Edges
derive newtype instance Ord Edges
derive newtype instance Show Edges

allEdges :: Edges
allEdges = Edges (Set.fromFoldable edgeOrder)

noEdges :: Edges
noEdges = Edges Set.empty

topOnly :: Edges
topOnly = Edges (Set.singleton Top)

bottomOnly :: Edges
bottomOnly = Edges (Set.singleton Bottom)

data SafeAreaMode
  = Padding
  | Margin

derive instance Eq SafeAreaMode
derive instance Ord SafeAreaMode
instance Show SafeAreaMode where
  show Padding = "Padding"
  show Margin = "Margin"

edgeOrder :: Array Edge
edgeOrder = [ Top, Right, Bottom, Left ]

edgeToString :: Edge -> String
edgeToString = case _ of
  Top -> "top"
  Right -> "right"
  Bottom -> "bottom"
  Left -> "left"

edgesToStrings :: Edges -> Array String
edgesToStrings (Edges edges) = Array.mapMaybe encodePresent edgeOrder
  where
  encodePresent edge
    | Set.member edge edges = Just (edgeToString edge)
    | otherwise = Nothing

safeAreaModeToString :: SafeAreaMode -> String
safeAreaModeToString = case _ of
  Padding -> "padding"
  Margin -> "margin"

foreign import safeAreaProviderImpl :: forall props. ReactComponent props

safeAreaProvider :: FFINativeComponent ()
safeAreaProvider = createNativeElement safeAreaProviderImpl

foreign import safeAreaViewImpl
  :: forall props
   . Fn2
       (Edges -> Array String)
       (SafeAreaMode -> String)
       (ReactComponent props)

safeAreaView
  :: FFINativeComponent
       (BaseAttributes
          ( edges :: Edges
          , mode :: SafeAreaMode
          )
       )
safeAreaView = createNativeElement (runFn2 safeAreaViewImpl edgesToStrings safeAreaModeToString)
