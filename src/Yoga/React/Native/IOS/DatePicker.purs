module Yoga.React.Native.IOS.DatePicker
  ( DatePickerMode(..)
  , DatePickerBounds
  , DatePickerConfigurationError(..)
  , unboundedDatePicker
  , datePickerBounds
  , DatePickerBehaviorOptions
  , DatePickerOptions
  , defaultDatePickerBehaviorOptions
  , datePicker
  ) where

import Prelude

import Data.DateTime.Instant (Instant)
import Data.Either (Either(..))
import Data.Function.Uncurried (Fn3, runFn3)
import Data.Maybe (Maybe(..))
import Data.Nullable (Nullable, toNullable)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, mkEffectFn1)
import React.Basic (JSX, ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (class CoerceReactProps, FFINativeComponent_, createNativeElement_)
import Yoga.React.Native.Types (ControlState(..), controlStateToBoolean)

data DatePickerMode
  = Date
  | Time
  | DateAndTime

derive instance Eq DatePickerMode
derive instance Ord DatePickerMode

instance Show DatePickerMode where
  show Date = "Date"
  show Time = "Time"
  show DateAndTime = "DateAndTime"

newtype DatePickerBounds = DatePickerBounds
  { minimum :: Maybe Instant
  , maximum :: Maybe Instant
  }

derive newtype instance Eq DatePickerBounds
derive newtype instance Ord DatePickerBounds
derive newtype instance Show DatePickerBounds

data DatePickerConfigurationError = MinimumAfterMaximum

derive instance Eq DatePickerConfigurationError
derive instance Ord DatePickerConfigurationError

instance Show DatePickerConfigurationError where
  show MinimumAfterMaximum = "MinimumAfterMaximum"

unboundedDatePicker :: DatePickerBounds
unboundedDatePicker = DatePickerBounds
  { minimum: Nothing
  , maximum: Nothing
  }

datePickerBounds
  :: Maybe Instant
  -> Maybe Instant
  -> Either DatePickerConfigurationError DatePickerBounds
datePickerBounds minimum maximum =
  case minimum, maximum of
    Just lower, Just upper | lower > upper -> Left MinimumAfterMaximum
    _, _ -> Right (DatePickerBounds { minimum, maximum })

type DatePickerBehaviorOptions =
  ( bounds :: DatePickerBounds
  , state :: ControlState
  )

type DatePickerOptions = BaseAttributes DatePickerBehaviorOptions

defaultDatePickerBehaviorOptions :: Record DatePickerBehaviorOptions
defaultDatePickerBehaviorOptions =
  { bounds: unboundedDatePicker
  , state: Enabled
  }

type DatePickerBridgeBehaviorOptions =
  { minimum :: Nullable Instant
  , maximum :: Nullable Instant
  , enabled :: Boolean
  }

foreign import data CompletedDatePickerOptions :: Type

foreign import completeDatePickerOptionsImpl
  :: forall given
   . Fn3
       (Record DatePickerBehaviorOptions)
       { | given }
       (Record DatePickerBehaviorOptions -> DatePickerBridgeBehaviorOptions)
       CompletedDatePickerOptions

type DatePickerBridgeAttributes =
  ( value :: Instant
  , mode :: String
  , onChange :: EffectFn1 Instant Unit
  , options :: CompletedDatePickerOptions
  )

foreign import datePickerImpl :: forall props. ReactComponent props

datePickerBridge :: FFINativeComponent_ DatePickerBridgeAttributes
datePickerBridge = createNativeElement_ datePickerImpl

datePicker
  :: forall given nonDataProps
   . CoerceReactProps { | given } { | nonDataProps } { | DatePickerOptions }
  => Instant
  -> DatePickerMode
  -> (Instant -> Effect Unit)
  -> { | given }
  -> JSX
datePicker value mode onChange given =
  datePickerBridge
    { value
    , mode: datePickerModeToString mode
    , onChange: mkEffectFn1 onChange
    , options: runFn3 completeDatePickerOptionsImpl
        defaultDatePickerBehaviorOptions
        given
        encodeDatePickerBehaviorOptions
    }

datePickerModeToString :: DatePickerMode -> String
datePickerModeToString = case _ of
  Date -> "date"
  Time -> "time"
  DateAndTime -> "datetime"

encodeDatePickerBehaviorOptions
  :: Record DatePickerBehaviorOptions
  -> DatePickerBridgeBehaviorOptions
encodeDatePickerBehaviorOptions
  { bounds: DatePickerBounds { minimum, maximum }, state } =
  { minimum: toNullable minimum
  , maximum: toNullable maximum
  , enabled: controlStateToBoolean state
  }
