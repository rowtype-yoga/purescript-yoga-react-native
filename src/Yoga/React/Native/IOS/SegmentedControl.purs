module Yoga.React.Native.IOS.SegmentedControl
  ( Segment
  , SegmentedControlBehaviorOptions
  , SegmentedControlOptions
  , defaultSegmentedControlBehaviorOptions
  , segmentedControl
  ) where

import Prelude

import Data.Array as Array
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmptyArray
import Data.Function.Uncurried (Fn1, Fn3, mkFn1, runFn3)
import Data.Maybe (Maybe(..))
import Data.Nullable (Nullable, toNullable)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, mkEffectFn1)
import React.Basic (JSX, ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (class CoerceReactProps, FFINativeComponent_, createNativeElement_)
import Yoga.React.Native.Types (ControlState(..), controlStateToBoolean)

type Segment a =
  { value :: a
  , label :: String
  }

type SegmentedControlBehaviorOptions =
  ( state :: ControlState
  )

type SegmentedControlOptions = BaseAttributes SegmentedControlBehaviorOptions

defaultSegmentedControlBehaviorOptions :: Record SegmentedControlBehaviorOptions
defaultSegmentedControlBehaviorOptions =
  { state: Enabled
  }

type SegmentedControlBridgeItem =
  { id :: String
  , title :: String
  }

type SegmentedControlBridgeProps =
  { items :: Array SegmentedControlBridgeItem
  , selectedId :: Nullable String
  , enabled :: Boolean
  , onSelect :: EffectFn1 Int Unit
  }

type SegmentedControlBridgeAttributes =
  ( items :: Array SegmentedControlBridgeItem
  , selectedId :: Nullable String
  , enabled :: Boolean
  , onSelect :: EffectFn1 Int Unit
  )

foreign import completeSegmentedControlPropsImpl
  :: forall given
   . Fn3
       (Record SegmentedControlBehaviorOptions)
       { | given }
       (Fn1 (Record SegmentedControlBehaviorOptions) SegmentedControlBridgeProps)
       SegmentedControlBridgeProps

foreign import segmentedControlImpl :: forall props. ReactComponent props

segmentedControlBridge :: FFINativeComponent_ SegmentedControlBridgeAttributes
segmentedControlBridge = createNativeElement_ segmentedControlImpl

segmentedControl
  :: forall a given nonDataProps
   . Eq a
  => CoerceReactProps { | given } { | nonDataProps } { | SegmentedControlOptions }
  => NonEmptyArray (Segment a)
  -> a
  -> (a -> Effect Unit)
  -> { | given }
  -> JSX
segmentedControl segments selected onSelect given =
  segmentedControlBridge
    ( runFn3 completeSegmentedControlPropsImpl
        defaultSegmentedControlBehaviorOptions
        given
        (mkFn1 encodeProps)
    )
  where
  values = NonEmptyArray.toArray segments

  selectedIndex :: Maybe Int
  selectedIndex = Array.findIndex (\segment -> segment.value == selected) values

  encodeProps :: Record SegmentedControlBehaviorOptions -> SegmentedControlBridgeProps
  encodeProps options =
    { items: Array.mapWithIndex
        (\index segment -> { id: show index, title: segment.label })
        values
    , selectedId: toNullable (show <$> selectedIndex)
    , enabled: controlStateToBoolean options.state
    , onSelect: mkEffectFn1 (\index -> case Array.index values index of
        Just segment -> onSelect segment.value
        Nothing -> pure unit
      )
    }
