module Yoga.React.Native.MacOS.RichTextLabel (nativeRichTextLabel, NativeRichTextLabelAttributes, EmojiMap, emojiMap) where

import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, createNativeElement)

foreign import data EmojiMap :: Type
foreign import richTextLabelImpl :: forall props. ReactComponent props
foreign import emojiMapImpl :: forall r. { | r } -> EmojiMap

emojiMap :: forall r. { | r } -> EmojiMap
emojiMap = emojiMapImpl

nativeRichTextLabel :: FFINativeComponent NativeRichTextLabelAttributes
nativeRichTextLabel = createNativeElement richTextLabelImpl

type NativeRichTextLabelAttributes = BaseAttributes
  ( emojiMap :: EmojiMap
  , textColor :: String
  , fontSize :: Number
  , emojiSize :: Number
  )
