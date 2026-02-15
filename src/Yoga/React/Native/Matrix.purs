module Yoga.React.Native.Matrix
  ( LoginResponse
  , RoomInfo
  , MatrixEvent
  , login
  , sync
  , sendMessage
  , joinedRooms
  , roomName
  , roomMembers
  , genTxnId
  , getSyncNextBatch
  , getSyncJoinedRoomIds
  , getSyncTimelineEvents
  , getEventType
  , getEventSender
  , getEventBody
  , getEventMsgType
  , getEventId
  , getEventTs
  , getEventImageUrl
  , parseJson
  , stringifyJson
  ) where

import Prelude

import Data.Nullable (Nullable, toMaybe)
import Data.Maybe (Maybe)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)
import Foreign (Foreign)

type LoginResponse =
  { user_id :: String
  , access_token :: String
  , device_id :: String
  }

type RoomInfo =
  { user_id :: String
  , displayname :: String
  }

type MatrixEvent = Foreign

foreign import loginImpl :: String -> String -> String -> EffectFnAff LoginResponse

login :: String -> String -> String -> Aff LoginResponse
login homeserver user password = fromEffectFnAff (loginImpl homeserver user password)

foreign import syncImpl :: String -> String -> String -> Int -> EffectFnAff Foreign

sync :: String -> String -> String -> Int -> Aff Foreign
sync homeserver accessToken since timeout = fromEffectFnAff (syncImpl homeserver accessToken since timeout)

foreign import sendMessageImpl :: String -> String -> String -> String -> String -> EffectFnAff { event_id :: String }

sendMessage :: String -> String -> String -> String -> String -> Aff { event_id :: String }
sendMessage homeserver accessToken roomId txnId body = fromEffectFnAff (sendMessageImpl homeserver accessToken roomId txnId body)

foreign import joinedRoomsImpl :: String -> String -> EffectFnAff Foreign

joinedRooms :: String -> String -> Aff (Array String)
joinedRooms homeserver accessToken = do
  resp <- fromEffectFnAff (joinedRoomsImpl homeserver accessToken)
  pure (getJoinedRoomIds resp)

foreign import roomNameImpl :: String -> String -> String -> EffectFnAff String

roomName :: String -> String -> String -> Aff String
roomName homeserver accessToken roomId = fromEffectFnAff (roomNameImpl homeserver accessToken roomId)

foreign import roomMembersImpl :: String -> String -> String -> EffectFnAff (Array RoomInfo)

roomMembers :: String -> String -> String -> Aff (Array RoomInfo)
roomMembers homeserver accessToken roomId = fromEffectFnAff (roomMembersImpl homeserver accessToken roomId)

foreign import genTxnId :: Effect String

-- Sync response accessors
foreign import getJoinedRoomIds :: Foreign -> Array String
foreign import getSyncNextBatch :: Foreign -> String
foreign import getSyncJoinedRoomIds :: Foreign -> Array String
foreign import getSyncTimelineEvents :: Foreign -> String -> Array MatrixEvent

-- Event accessors
foreign import getEventType :: MatrixEvent -> String
foreign import getEventSender :: MatrixEvent -> String
foreign import getEventBody :: MatrixEvent -> String
foreign import getEventMsgType :: MatrixEvent -> String
foreign import getEventId :: MatrixEvent -> String
foreign import getEventTs :: MatrixEvent -> Number
foreign import getEventImageUrl :: MatrixEvent -> String

-- JSON helpers for session persistence
foreign import parseJsonImpl :: String -> Nullable Foreign
foreign import stringifyJson :: Foreign -> String

parseJson :: String -> Maybe Foreign
parseJson = toMaybe <<< parseJsonImpl
