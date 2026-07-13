module Yoga.React.Native.IOS.SearchBar
  ( SearchText(..)
  , CancelButtonVisibility(..)
  , SearchBarBehaviorOptions
  , SearchBarOptions
  , defaultSearchBarBehaviorOptions
  , searchBar
  ) where

import Prelude

import Data.Function.Uncurried (Fn3, runFn3)
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype)
import Data.Nullable (Nullable, toNullable)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, mkEffectFn1)
import React.Basic (JSX, ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (class CoerceReactProps, FFINativeComponent_, createNativeElement_)
import Yoga.React.Native.Types (ControlState(..), controlStateToBoolean)

newtype SearchText = SearchText String

derive instance Newtype SearchText _
derive newtype instance Eq SearchText
derive newtype instance Ord SearchText
derive newtype instance Show SearchText

data CancelButtonVisibility
  = HideCancelButton
  | ShowCancelButton

derive instance Eq CancelButtonVisibility
derive instance Ord CancelButtonVisibility
instance Show CancelButtonVisibility where
  show HideCancelButton = "HideCancelButton"
  show ShowCancelButton = "ShowCancelButton"

cancelButtonVisibilityToBoolean :: CancelButtonVisibility -> Boolean
cancelButtonVisibilityToBoolean = case _ of
  HideCancelButton -> false
  ShowCancelButton -> true

type SearchBarBehaviorOptions =
  ( placeholder :: Maybe String
  , cancelButton :: CancelButtonVisibility
  , state :: ControlState
  , onSubmit :: Maybe (SearchText -> Effect Unit)
  , onCancel :: Maybe (Effect Unit)
  )

type SearchBarOptions = BaseAttributes SearchBarBehaviorOptions

defaultSearchBarBehaviorOptions :: Record SearchBarBehaviorOptions
defaultSearchBarBehaviorOptions =
  { placeholder: Nothing
  , cancelButton: HideCancelButton
  , state: Enabled
  , onSubmit: Nothing
  , onCancel: Nothing
  }

type SearchBarBridgeBehaviorOptions =
  { placeholder :: Nullable String
  , showsCancelButton :: Boolean
  , enabled :: Boolean
  , onSubmit :: Nullable (EffectFn1 String Unit)
  , onCancel :: Nullable (EffectFn1 Unit Unit)
  }

foreign import data SearchBarNativeOptions :: Type

foreign import completeSearchBarOptionsImpl
  :: forall given
   . Fn3
       (Record SearchBarBehaviorOptions)
       { | given }
       (Record SearchBarBehaviorOptions -> SearchBarBridgeBehaviorOptions)
       SearchBarNativeOptions

type SearchBarBridgeProps =
  ( text :: String
  , onChangeText :: EffectFn1 String Unit
  , options :: SearchBarNativeOptions
  )

foreign import searchBarImpl :: forall props. ReactComponent props

searchBarBridge :: FFINativeComponent_ SearchBarBridgeProps
searchBarBridge = createNativeElement_ searchBarImpl

searchBar
  :: forall given nonDataProps
   . CoerceReactProps { | given } { | nonDataProps } { | SearchBarOptions }
  => SearchText
  -> (SearchText -> Effect Unit)
  -> { | given }
  -> JSX
searchBar (SearchText text) onChangeText given =
  searchBarBridge
    { text
    , onChangeText: mkEffectFn1 (onChangeText <<< SearchText)
    , options: runFn3 completeSearchBarOptionsImpl
        defaultSearchBarBehaviorOptions
        given
        encodeSearchBarBehaviorOptions
    }

encodeSearchBarBehaviorOptions
  :: Record SearchBarBehaviorOptions
  -> SearchBarBridgeBehaviorOptions
encodeSearchBarBehaviorOptions options =
  { placeholder: toNullable options.placeholder
  , showsCancelButton: cancelButtonVisibilityToBoolean options.cancelButton
  , enabled: controlStateToBoolean options.state
  , onSubmit: toNullable (map (mkEffectFn1 <<< mapSearchTextCallback) options.onSubmit)
  , onCancel: toNullable (map (mkEffectFn1 <<< mapCancelCallback) options.onCancel)
  }
  where
  mapSearchTextCallback callback text = callback (SearchText text)
  mapCancelCallback callback _ = callback
