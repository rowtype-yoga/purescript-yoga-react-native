module Docs.Main where

import Prelude

import Deku.SPA (runInBody)
import Docs.App (app)
import Effect (Effect)

main :: Effect Unit
main = void $ runInBody app
