module Yoga.React.Native.IOS.ActionSheet
  ( ActionStyle(..)
  , Action
  , Actions
  , ActionSheetConfigurationError(..)
  , actions
  , ActionSheetResult(..)
  , ActionSheetError(..)
  , PopoverAnchor(..)
  , ActionSheetOptions
  , defaultActionSheetOptions
  , showActionSheet
  , ActivityType(..)
  , ShareResult(..)
  , ShareError(..)
  , ShareOptions
  , defaultShareOptions
  , showShareActionSheet
  , dismissActionSheet
  ) where

import Prelude

import Data.Array as Array
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmptyArray
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype)
import Data.Nullable (Nullable, toMaybe, toNullable)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn3, mkEffectFn1, mkEffectFn2, runEffectFn2, runEffectFn3)
import Prim.Row (class Union)
import Yoga.React.Native.PlatformColor (ColorValue)
import Yoga.React.Native.Types (ControlState(..), URL(..), UserInterfaceStyle(..), userInterfaceStyleToString)

data ActionStyle
  = DefaultAction
  | CancelAction
  | DestructiveAction

derive instance Eq ActionStyle
derive instance Ord ActionStyle
instance Show ActionStyle where
  show DefaultAction = "DefaultAction"
  show CancelAction = "CancelAction"
  show DestructiveAction = "DestructiveAction"

type Action a =
  { value :: a
  , label :: String
  , style :: ActionStyle
  , state :: ControlState
  }

newtype Actions a = Actions (NonEmptyArray (Action a))

data ActionSheetConfigurationError = MultipleCancelActions

derive instance Eq ActionSheetConfigurationError
derive instance Ord ActionSheetConfigurationError
instance Show ActionSheetConfigurationError where
  show MultipleCancelActions = "MultipleCancelActions"

actions
  :: forall a
   . NonEmptyArray (Action a)
  -> Either ActionSheetConfigurationError (Actions a)
actions values
  | Array.length (Array.filter (\action -> action.style == CancelAction) (NonEmptyArray.toArray values)) > 1 =
      Left MultipleCancelActions
  | otherwise = Right (Actions values)

data ActionSheetResult a
  = SelectedAction a
  | DismissedActionSheet

derive instance Eq a => Eq (ActionSheetResult a)
derive instance Ord a => Ord (ActionSheetResult a)
instance Show a => Show (ActionSheetResult a) where
  show (SelectedAction value) = "(SelectedAction " <> show value <> ")"
  show DismissedActionSheet = "DismissedActionSheet"

data ActionSheetError
  = ActionSheetUnavailable
  | InvalidNativeActionResponse

derive instance Eq ActionSheetError
derive instance Ord ActionSheetError
instance Show ActionSheetError where
  show ActionSheetUnavailable = "ActionSheetUnavailable"
  show InvalidNativeActionResponse = "InvalidNativeActionResponse"

newtype PopoverAnchor = PopoverAnchor Int

derive instance Newtype PopoverAnchor _
derive newtype instance Eq PopoverAnchor
derive newtype instance Ord PopoverAnchor
derive newtype instance Show PopoverAnchor

type ActionSheetOptions =
  ( title :: Maybe String
  , message :: Maybe String
  , anchor :: Maybe PopoverAnchor
  , userInterfaceStyle :: UserInterfaceStyle
  )

defaultActionSheetOptions :: Record ActionSheetOptions
defaultActionSheetOptions =
  { title: Nothing
  , message: Nothing
  , anchor: Nothing
  , userInterfaceStyle: Automatic
  }

type ActionSheetBridgeOptions =
  { options :: Array String
  , cancelButtonIndex :: Nullable Int
  , destructiveButtonIndices :: Array Int
  , disabledButtonIndices :: Array Int
  , title :: Nullable String
  , message :: Nullable String
  , anchor :: Nullable Int
  , userInterfaceStyle :: String
  }

type ActionSheetNativeResult =
  { status :: Int
  , index :: Int
  }

foreign import completeActionSheetOptionsImpl
  :: forall given
   . EffectFn3
       (Record ActionSheetOptions)
       { | given }
       (EffectFn1 (Record ActionSheetOptions) ActionSheetBridgeOptions)
       ActionSheetBridgeOptions

foreign import showActionSheetImpl
  :: EffectFn2 ActionSheetBridgeOptions (EffectFn1 ActionSheetNativeResult Unit) Unit

showActionSheet
  :: forall a given missing
   . Union given missing ActionSheetOptions
  => Actions a
  -> { | given }
  -> (Either ActionSheetError (ActionSheetResult a) -> Effect Unit)
  -> Effect Unit
showActionSheet (Actions values) given callback = do
  let actionArray = NonEmptyArray.toArray values
  bridgeOptions <- runEffectFn3 completeActionSheetOptionsImpl
    defaultActionSheetOptions
    given
    (mkEffectFn1 (pure <<< encodeActionSheetOptions actionArray))
  runEffectFn2 showActionSheetImpl bridgeOptions (mkEffectFn1 (callback <<< decodeResult actionArray))

encodeActionSheetOptions
  :: forall a
   . Array (Action a)
  -> Record ActionSheetOptions
  -> ActionSheetBridgeOptions
encodeActionSheetOptions actionArray options =
  { options: map _.label actionArray
  , cancelButtonIndex: toNullable (Array.findIndex (\action -> action.style == CancelAction) actionArray)
  , destructiveButtonIndices: indicesWithStyle DestructiveAction actionArray
  , disabledButtonIndices: Array.mapMaybe identity
      (Array.mapWithIndex (\index action -> if action.state == Disabled then Just index else Nothing) actionArray)
  , title: toNullable options.title
  , message: toNullable options.message
  , anchor: toNullable (map (\(PopoverAnchor anchor) -> anchor) options.anchor)
  , userInterfaceStyle: userInterfaceStyleToString options.userInterfaceStyle
  }

indicesWithStyle :: forall a. ActionStyle -> Array (Action a) -> Array Int
indicesWithStyle style =
  Array.mapMaybe identity
    <<< Array.mapWithIndex (\index action -> if action.style == style then Just index else Nothing)

decodeResult
  :: forall a
   . Array (Action a)
  -> ActionSheetNativeResult
  -> Either ActionSheetError (ActionSheetResult a)
decodeResult actionArray result = case result.status of
  0 -> case Array.index actionArray result.index of
    Just action -> Right (SelectedAction action.value)
    Nothing -> Left InvalidNativeActionResponse
  1 -> Right DismissedActionSheet
  2 -> Left ActionSheetUnavailable
  _ -> Left InvalidNativeActionResponse

newtype ActivityType = ActivityType String

derive instance Newtype ActivityType _
derive newtype instance Eq ActivityType
derive newtype instance Ord ActivityType
derive newtype instance Show ActivityType

data ShareResult
  = Shared (Maybe ActivityType)
  | DismissedShare

derive instance Eq ShareResult
derive instance Ord ShareResult
instance Show ShareResult where
  show (Shared activityType) = "(Shared " <> show activityType <> ")"
  show DismissedShare = "DismissedShare"

data ShareError
  = ShareUnavailable
  | ShareFailed String

derive instance Eq ShareError
derive instance Ord ShareError
instance Show ShareError where
  show ShareUnavailable = "ShareUnavailable"
  show (ShareFailed message) = "(ShareFailed " <> show message <> ")"

type ShareOptions =
  ( message :: Maybe String
  , url :: Maybe URL
  , subject :: Maybe String
  , excludedActivityTypes :: Array ActivityType
  , tintColor :: Maybe ColorValue
  , anchor :: Maybe PopoverAnchor
  , userInterfaceStyle :: UserInterfaceStyle
  )

defaultShareOptions :: Record ShareOptions
defaultShareOptions =
  { message: Nothing
  , url: Nothing
  , subject: Nothing
  , excludedActivityTypes: []
  , tintColor: Nothing
  , anchor: Nothing
  , userInterfaceStyle: Automatic
  }

type ShareBridgeOptions =
  { message :: Nullable String
  , url :: Nullable String
  , subject :: Nullable String
  , excludedActivityTypes :: Array String
  , tintColor :: Nullable ColorValue
  , anchor :: Nullable Int
  , userInterfaceStyle :: String
  }

type ShareNativeError =
  { unavailable :: Boolean
  , message :: String
  }

foreign import completeShareOptionsImpl
  :: forall given
   . EffectFn3
       (Record ShareOptions)
       { | given }
       (EffectFn1 (Record ShareOptions) ShareBridgeOptions)
       ShareBridgeOptions

foreign import showShareActionSheetImpl
  :: EffectFn3
       ShareBridgeOptions
       (EffectFn1 ShareNativeError Unit)
       (EffectFn2 Boolean (Nullable String) Unit)
       Unit

showShareActionSheet
  :: forall given missing
   . Union given missing ShareOptions
  => { | given }
  -> (Either ShareError ShareResult -> Effect Unit)
  -> Effect Unit
showShareActionSheet given callback = do
  bridgeOptions <- runEffectFn3 completeShareOptionsImpl
    defaultShareOptions
    given
    (mkEffectFn1 (pure <<< encodeShareOptions))
  runEffectFn3 showShareActionSheetImpl
    bridgeOptions
    (mkEffectFn1 (callback <<< decodeShareError))
    (mkEffectFn2 (\completed activityType -> callback (decodeShareResult completed activityType)))

encodeShareOptions :: Record ShareOptions -> ShareBridgeOptions
encodeShareOptions options =
  { message: toNullable options.message
  , url: toNullable (map (\(URL url) -> url) options.url)
  , subject: toNullable options.subject
  , excludedActivityTypes: map (\(ActivityType activityType) -> activityType) options.excludedActivityTypes
  , tintColor: toNullable options.tintColor
  , anchor: toNullable (map (\(PopoverAnchor anchor) -> anchor) options.anchor)
  , userInterfaceStyle: userInterfaceStyleToString options.userInterfaceStyle
  }

decodeShareError :: ShareNativeError -> Either ShareError ShareResult
decodeShareError error
  | error.unavailable = Left ShareUnavailable
  | otherwise = Left (ShareFailed error.message)

decodeShareResult :: Boolean -> Nullable String -> Either ShareError ShareResult
decodeShareResult completed activityType
  | completed = Right (Shared (ActivityType <$> toMaybe activityType))
  | otherwise = Right DismissedShare

foreign import dismissActionSheet :: Effect Unit
