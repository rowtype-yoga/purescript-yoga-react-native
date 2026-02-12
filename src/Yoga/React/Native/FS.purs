module Yoga.React.Native.FS
  ( documentDirectoryPath
  , cachesDirectoryPath
  , temporaryDirectoryPath
  , downloadDirectoryPath
  , libraryDirectoryPath
  , readFile
  , writeFile
  , appendFile
  , exists
  , unlink
  , readDir
  , mkdir
  , stat
  , hash
  , copyFile
  , moveFile
  , DirItem
  , StatResult
  ) where

import Prelude

import Effect.Aff (Aff)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)

type DirItem =
  { name :: String
  , path :: String
  , size :: Number
  , isFile :: Boolean
  , isDirectory :: Boolean
  }

type StatResult =
  { name :: String
  , path :: String
  , size :: Number
  , mode :: Int
  , ctime :: Number
  , mtime :: Number
  , isFile :: Boolean
  , isDirectory :: Boolean
  }

foreign import documentDirectoryPath :: String
foreign import cachesDirectoryPath :: String
foreign import temporaryDirectoryPath :: String
foreign import downloadDirectoryPath :: String
foreign import libraryDirectoryPath :: String

foreign import readFileImpl :: String -> String -> EffectFnAff String

readFile :: String -> String -> Aff String
readFile path encoding = fromEffectFnAff (readFileImpl path encoding)

foreign import writeFileImpl :: String -> String -> String -> EffectFnAff Unit

writeFile :: String -> String -> String -> Aff Unit
writeFile path contents encoding = fromEffectFnAff (writeFileImpl path contents encoding)

foreign import appendFileImpl :: String -> String -> String -> EffectFnAff Unit

appendFile :: String -> String -> String -> Aff Unit
appendFile path contents encoding = fromEffectFnAff (appendFileImpl path contents encoding)

foreign import existsImpl :: String -> EffectFnAff Boolean

exists :: String -> Aff Boolean
exists path = fromEffectFnAff (existsImpl path)

foreign import unlinkImpl :: String -> EffectFnAff Unit

unlink :: String -> Aff Unit
unlink path = fromEffectFnAff (unlinkImpl path)

foreign import readDirImpl :: String -> EffectFnAff (Array DirItem)

readDir :: String -> Aff (Array DirItem)
readDir path = fromEffectFnAff (readDirImpl path)

foreign import mkdirImpl :: String -> EffectFnAff Unit

mkdir :: String -> Aff Unit
mkdir path = fromEffectFnAff (mkdirImpl path)

foreign import statImpl :: String -> EffectFnAff StatResult

stat :: String -> Aff StatResult
stat path = fromEffectFnAff (statImpl path)

foreign import hashImpl :: String -> String -> EffectFnAff String

hash :: String -> String -> Aff String
hash path algorithm = fromEffectFnAff (hashImpl path algorithm)

foreign import copyFileImpl :: String -> String -> EffectFnAff Unit

copyFile :: String -> String -> Aff Unit
copyFile src dest = fromEffectFnAff (copyFileImpl src dest)

foreign import moveFileImpl :: String -> String -> EffectFnAff Unit

moveFile :: String -> String -> Aff Unit
moveFile src dest = fromEffectFnAff (moveFileImpl src dest)
