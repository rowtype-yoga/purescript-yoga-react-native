module Yoga.React.Native.IOS.CollectionView
  ( CollectionItem
  , CollectionItems
  , CollectionItemsError(..)
  , collectionItems
  , CollectionViewBehaviorOptions
  , CollectionViewOptions
  , defaultCollectionViewBehaviorOptions
  , collectionView
  ) where

import Prelude

import Data.Array as Array
import Data.Either (Either(..))
import Data.Foldable (foldl)
import Data.Function.Uncurried (Fn1, Fn3, mkFn1, runFn3)
import Data.Maybe (Maybe(..))
import Data.Nullable (Nullable, toNullable)
import Data.Set (Set)
import Data.Set as Set
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, mkEffectFn1, mkEffectFn2)
import React.Basic (JSX, ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (class CoerceReactProps, FFINativeComponent_, createNativeElement_)
import Yoga.React.Native.Types (ItemId(..), RefreshState(..), refreshStateToBoolean)

type CollectionItem a =
  { id :: ItemId
  , value :: a
  , title :: String
  }

newtype CollectionItems a = CollectionItems (Array (CollectionItem a))

data CollectionItemsError
  = EmptyItemId
  | DuplicateItemId ItemId

derive instance Eq CollectionItemsError
instance Show CollectionItemsError where
  show EmptyItemId = "EmptyItemId"
  show (DuplicateItemId itemId) = "(DuplicateItemId " <> show itemId <> ")"

collectionItems
  :: forall a
   . Array (CollectionItem a)
  -> Either CollectionItemsError (CollectionItems a)
collectionItems items = CollectionItems items <$ validateItems items
  where
  validateItems = map (const unit) <<< foldl validateItem (Right Set.empty)

  validateItem
    :: Either CollectionItemsError (Set ItemId)
    -> CollectionItem a
    -> Either CollectionItemsError (Set ItemId)
  validateItem result item = do
    seen <- result
    case item.id of
      ItemId "" -> Left EmptyItemId
      itemId
        | Set.member itemId seen -> Left (DuplicateItemId itemId)
        | otherwise -> Right (Set.insert itemId seen)

type CollectionViewBehaviorOptions =
  ( selected :: Maybe ItemId
  , refreshState :: RefreshState
  )

type CollectionViewOptions = BaseAttributes CollectionViewBehaviorOptions

defaultCollectionViewBehaviorOptions :: Record CollectionViewBehaviorOptions
defaultCollectionViewBehaviorOptions =
  { selected: Nothing
  , refreshState: RefreshIdle
  }

type NativeCollectionItem =
  { id :: String
  , title :: String
  }

type CollectionViewBridgeProps =
  { items :: Array NativeCollectionItem
  , selectedId :: Nullable String
  , refreshing :: Boolean
  , onSelectItem :: EffectFn2 String Int Unit
  , onRefresh :: EffectFn1 Unit Unit
  }

type CollectionViewBridgeAttributes = BaseAttributes
  ( items :: Array NativeCollectionItem
  , selectedId :: Nullable String
  , refreshing :: Boolean
  , onSelectItem :: EffectFn2 String Int Unit
  , onRefresh :: EffectFn1 Unit Unit
  )

foreign import completeCollectionViewPropsImpl
  :: forall given
   . Fn3
       (Record CollectionViewBehaviorOptions)
       { | given }
       (Fn1 (Record CollectionViewBehaviorOptions) CollectionViewBridgeProps)
       CollectionViewBridgeProps

foreign import collectionViewImpl :: forall props. ReactComponent props

collectionViewBridge :: FFINativeComponent_ CollectionViewBridgeAttributes
collectionViewBridge = createNativeElement_ collectionViewImpl
collectionView
  :: forall a given nonDataProps
   . CoerceReactProps { | given } { | nonDataProps } { | CollectionViewOptions }
  => CollectionItems a
  -> (a -> Effect Unit)
  -> Effect Unit
  -> { | given }
  -> JSX
collectionView (CollectionItems items) onSelect onRefresh options =
  collectionViewBridge
    ( runFn3 completeCollectionViewPropsImpl
        defaultCollectionViewBehaviorOptions
        options
        (mkFn1 encodeProps)
    )
  where
  handleSelection id index =
    case Array.index items index of
      Just item | item.id == ItemId id -> onSelect item.value
      _ -> pure unit

  encodeProps behaviorOptions =
    { items: map toNativeItem items
    , selectedId: toNullable (itemIdToString <$> behaviorOptions.selected)
    , refreshing: refreshStateToBoolean behaviorOptions.refreshState
    , onSelectItem: mkEffectFn2 handleSelection
    , onRefresh: mkEffectFn1 (const onRefresh)
    }

toNativeItem :: forall a. CollectionItem a -> NativeCollectionItem
toNativeItem item = case item.id of
  ItemId id -> { id, title: item.title }


itemIdToString :: ItemId -> String
itemIdToString (ItemId id) = id
