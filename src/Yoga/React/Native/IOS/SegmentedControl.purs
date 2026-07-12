module Yoga.React.Native.IOS.SegmentedControl
  ( segmentedControl
  , SegmentedControlAttributes
  , SegmentedControlItem
  , SegmentedControlSelection
  ) where

import Prelude

import Effect (Effect)
import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

type SegmentedControlItem =
  { id :: String
  , title :: String
  }

type SegmentedControlSelection =
  { id :: String
  , index :: Int
  }

type SegmentedControlAttributes = BaseAttributes
  ( items :: Array SegmentedControlItem
  , selectedId :: String
  , enabled :: Boolean
  , onSelect :: SegmentedControlSelection -> Effect Unit
  )

foreign import segmentedControlImpl :: forall props. ReactComponent props

segmentedControl :: FFINativeComponent_ SegmentedControlAttributes
segmentedControl = createNativeElement_ segmentedControlImpl
