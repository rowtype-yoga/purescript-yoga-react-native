module Yoga.React.Native.Platform
  ( os
  , version
  , isTV
  , select
  ) where

import Foreign (Foreign)

foreign import os :: String

foreign import version :: Foreign

foreign import isTV :: Boolean

foreign import selectImpl :: forall r. { | r } -> Foreign

select :: forall r. { | r } -> Foreign
select = selectImpl
