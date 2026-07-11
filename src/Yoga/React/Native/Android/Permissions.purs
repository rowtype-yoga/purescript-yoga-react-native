module Yoga.React.Native.Android.Permissions
  ( request
  , requestMultiple
  , check
  , Permission
  , PermissionStatus
  , readCalendar
  , writeCalendar
  , camera
  , readContacts
  , writeContacts
  , getAccounts
  , accessFineLocation
  , accessCoarseLocation
  , accessBackgroundLocation
  , recordAudio
  , readPhoneState
  , callPhone
  , readCallLog
  , writeCallLog
  , bodySensors
  , sendSms
  , receiveSms
  , readSms
  , receiveWapPush
  , receiveMms
  , readExternalStorage
  , writeExternalStorage
  , bluetoothConnect
  , bluetoothScan
  , bluetoothAdvertise
  , nearbyWifiDevices
  , postNotifications
  , readMediaImages
  , readMediaVideo
  , readMediaAudio
  , activityRecognition
  , isGranted
  , isDenied
  , isNeverAskAgain
  ) where

import Prelude

import Effect.Aff (Aff)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)

foreign import data Permission :: Type
foreign import data PermissionStatus :: Type

foreign import readCalendar :: Permission
foreign import writeCalendar :: Permission
foreign import camera :: Permission
foreign import readContacts :: Permission
foreign import writeContacts :: Permission
foreign import getAccounts :: Permission
foreign import accessFineLocation :: Permission
foreign import accessCoarseLocation :: Permission
foreign import accessBackgroundLocation :: Permission
foreign import recordAudio :: Permission
foreign import readPhoneState :: Permission
foreign import callPhone :: Permission
foreign import readCallLog :: Permission
foreign import writeCallLog :: Permission
foreign import bodySensors :: Permission
foreign import sendSms :: Permission
foreign import receiveSms :: Permission
foreign import readSms :: Permission
foreign import receiveWapPush :: Permission
foreign import receiveMms :: Permission
foreign import readExternalStorage :: Permission
foreign import writeExternalStorage :: Permission
foreign import bluetoothConnect :: Permission
foreign import bluetoothScan :: Permission
foreign import bluetoothAdvertise :: Permission
foreign import nearbyWifiDevices :: Permission
foreign import postNotifications :: Permission
foreign import readMediaImages :: Permission
foreign import readMediaVideo :: Permission
foreign import readMediaAudio :: Permission
foreign import activityRecognition :: Permission

foreign import requestImpl :: Permission -> EffectFnAff PermissionStatus
foreign import requestMultipleImpl :: Array Permission -> EffectFnAff (Array PermissionStatus)
foreign import checkImpl :: Permission -> EffectFnAff Boolean

foreign import isGranted :: PermissionStatus -> Boolean
foreign import isDenied :: PermissionStatus -> Boolean
foreign import isNeverAskAgain :: PermissionStatus -> Boolean

request :: Permission -> Aff PermissionStatus
request = requestImpl >>> fromEffectFnAff

requestMultiple :: Array Permission -> Aff (Array PermissionStatus)
requestMultiple = requestMultipleImpl >>> fromEffectFnAff

check :: Permission -> Aff Boolean
check = checkImpl >>> fromEffectFnAff
