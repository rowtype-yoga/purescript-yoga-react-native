module Demo.Chat (chatDemo) where

import Prelude

import Data.Array (mapWithIndex, length, filter, snoc, (!!), modifyAt)
import Data.Foldable (foldl)
import Data.Int (toNumber)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Nullable (Nullable, toMaybe)
import Data.String (take)
import Data.String as String

import Demo.Shared (DemoProps)
import Effect (Effect)
import Effect.Uncurried (EffectFn2, runEffectFn2)

import React.Basic (JSX)
import React.Basic.Events (handler_)
import React.Basic.Hooks (useState, useState', (/\))
import React.Basic.Hooks as React
import Yoga.React (component)
import Yoga.React.Native (text, tw, view)
import Yoga.React.Native.MacOS.AnimatedImage (nativeAnimatedImage)
import Yoga.React.Native.MacOS.RichTextLabel (EmojiMap, nativeRichTextLabel, emojiMap)
import Yoga.React.Native.MacOS.Button (nativeButton)
import Yoga.React.Native.MacOS.HoverView (nativeHoverView)
import Yoga.React.Native.MacOS.Popover (nativePopover)
import Yoga.React.Native.MacOS.PatternBackground (nativePatternBackground)
import Yoga.React.Native.MacOS.ScrollView (nativeScrollView)
import Yoga.React.Native.MacOS.Sidebar (sidebarLayout)
import Yoga.React.Native.MacOS.TextField (nativeTextField)
import Yoga.React.Native.MacOS.Types as T
import Yoga.React.Native.Style as Style

type Reaction = { emoji :: String, count :: Int }

type Message =
  { sender :: String
  , body :: String
  , isMine :: Boolean
  , reactions :: Array Reaction
  , replyTo :: Maybe Int
  }

type Room =
  { roomId :: String
  , name :: String
  , lastMessage :: String
  }

reactionEmoji :: Array String
reactionEmoji = [ "👍", "❤️", "😂", "😮", "😢", "🔥" ]

avatarColors :: Array String
avatarColors = [ "#5856D6", "#FF9500", "#34C759", "#FF2D55", "#5AC8FA", "#FF6B6B", "#4ECDC4", "#45B7D1" ]

avatarColor :: String -> String
avatarColor roomId = fromMaybe "#5856D6" (avatarColors !! (mod (hashCode roomId) (length avatarColors)))
  where
  hashCode s = abs (foldl (\acc c -> acc * 31 + c) 0 (charCodes s))

foreign import charCodes :: String -> Array Int
foreign import abs :: Int -> Int
foreign import isSingleEmoji :: String -> Boolean
foreign import replaceEmoji :: String -> String
foreign import setTimeout_ :: EffectFn2 Int (Effect Unit) Unit
foreign import emojiDir :: String
foreign import singleCustomEmoji_ :: EmojiMap -> String -> Nullable String

singleCustomEmoji :: String -> Maybe String
singleCustomEmoji = toMaybe <<< singleCustomEmoji_ customEmojiMap

customEmojiMap :: EmojiMap
customEmojiMap = emojiMap
  { ps: "purescript.png"
  , haskell: "haskell.png"
  , shipit: "shipit.png"
  , party: "party.png"
  , parrot: "parrot.gif"
  , fastparrot: "fastparrot.gif"
  , ultraparrot: "ultraparrot.gif"
  , congaparrot: "congaparrot.gif"
  , opensourceparrot: "opensourceparrot.gif"
  , dealwithit: "dealwithit.gif"
  , doge: "cooldoge.gif"
  , partyblob: "partyblob.gif"
  , typingcat: "typingcat.gif"
  }

addReaction :: String -> Array Reaction -> Array Reaction
addReaction emoji rs = case filter (\r -> r.emoji == emoji) rs of
  [] -> snoc rs { emoji, count: 1 }
  _ -> map (\r -> if r.emoji == emoji then r { count = r.count + 1 } else r) rs

mockRooms :: Array Room
mockRooms =
  [ { roomId: "general", name: "General", lastMessage: "Welcome!" }
  , { roomId: "purescript", name: "PureScript", lastMessage: "Types are great" }
  , { roomId: "react-native", name: "React Native", lastMessage: "Check out macOS support" }
  , { roomId: "random", name: "Random", lastMessage: "Anyone here?" }
  ]

mockMessages :: String -> Array Message
mockMessages room = map (\m -> m { body = replaceEmoji m.body }) (mockMessagesRaw room)

noReactions :: Array Reaction
noReactions = []

mockMessagesRaw :: String -> Array Message
mockMessagesRaw = case _ of
  "general" ->
    [ { sender: "Alice", body: "Hey everyone! Welcome to the chat demo :wave:", isMine: false, reactions: [ { emoji: "👋", count: 3 } ], replyTo: Nothing }
    , { sender: "Bob", body: "This is built with :ps: + React Native macOS", isMine: false, reactions: [ { emoji: "🔥", count: 2 }, { emoji: "❤️", count: 1 } ], replyTo: Nothing }
    , { sender: "You", body: "That's awesome! :fire:", isMine: true, reactions: noReactions, replyTo: Just 1 }
    , { sender: "Alice", body: "Try typing :rocket: or :heart: in a message", isMine: false, reactions: noReactions, replyTo: Nothing }
    , { sender: "You", body: "The bubbles look great :sparkles:", isMine: true, reactions: [ { emoji: "👍", count: 2 } ], replyTo: Nothing }
    , { sender: "Bob", body: "Click the smiley to react!", isMine: false, reactions: noReactions, replyTo: Just 4 }
    , { sender: "Alice", body: ":party: :shipit:", isMine: false, reactions: [ { emoji: "🎉", count: 5 } ], replyTo: Nothing }
    , { sender: "Bob", body: ":parrot: Party Parrot! :parrot:", isMine: false, reactions: [ { emoji: "🦜", count: 3 } ], replyTo: Nothing }
    , { sender: "You", body: ":dealwithit: deal with it :doge:", isMine: true, reactions: noReactions, replyTo: Nothing }
    , { sender: "Alice", body: ":typingcat:", isMine: false, reactions: noReactions, replyTo: Nothing }
    ]
  "purescript" ->
    [ { sender: "Phil", body: "Has anyone tried the new compiler release?", isMine: false, reactions: [ { emoji: "👍", count: 4 } ], replyTo: Nothing }
    , { sender: "You", body: "Yes! The build times are much better", isMine: true, reactions: noReactions, replyTo: Just 0 }
    , { sender: "Phil", body: "Row polymorphism makes FFI so clean", isMine: false, reactions: [ { emoji: "❤️", count: 3 } ], replyTo: Nothing }
    , { sender: "Jordan", body: "The ecosystem keeps getting better", isMine: false, reactions: noReactions, replyTo: Nothing }
    , { sender: "You", body: "Agreed, especially for React Native", isMine: true, reactions: [ { emoji: "🔥", count: 1 } ], replyTo: Just 2 }
    , { sender: "Jordan", body: ":opensourceparrot: :ps: :haskell: :opensourceparrot:", isMine: false, reactions: [ { emoji: "❤️", count: 4 } ], replyTo: Nothing }
    ]
  "react-native" ->
    [ { sender: "Christoph", body: "macOS support is looking solid", isMine: false, reactions: [ { emoji: "🔥", count: 3 } ], replyTo: Nothing }
    , { sender: "You", body: "Native controls feel right at home", isMine: true, reactions: noReactions, replyTo: Just 0 }
    , { sender: "Christoph", body: "NSOutlineView, NSSplitView, toolbars...", isMine: false, reactions: noReactions, replyTo: Nothing }
    , { sender: "You", body: "Even the vibrancy effects work", isMine: true, reactions: [ { emoji: "😮", count: 2 } ], replyTo: Nothing }
    , { sender: "Christoph", body: "🚀", isMine: false, reactions: [ { emoji: "🚀", count: 7 } ], replyTo: Nothing }
    , { sender: "You", body: ":fastparrot: :congaparrot: :ultraparrot: conga line!", isMine: true, reactions: [ { emoji: "🎉", count: 3 } ], replyTo: Nothing }
    ]
  "random" ->
    [ { sender: "Eve", body: "Anyone here?", isMine: false, reactions: noReactions, replyTo: Nothing }
    , { sender: "You", body: "👋", isMine: true, reactions: [ { emoji: "👋", count: 1 } ], replyTo: Just 0 }
    , { sender: "Eve", body: ":partyblob: :partyblob: :partyblob:", isMine: false, reactions: [ { emoji: "🎉", count: 2 } ], replyTo: Nothing }
    ]
  _ -> []

truncate :: Int -> String -> String
truncate n s = if String.length s <= n then s else take n s <> "…"

estimatedY :: Int -> Number
estimatedY idx = 8.0 + 70.0 * toNumber idx

chatDemo :: DemoProps -> JSX
chatDemo = component "ChatDemo" \dp -> React.do
  activeRoom /\ setActiveRoom <- useState' (Just "general")
  messages /\ setMessages <- useState (mockMessages "general")
  inputText /\ setInputText <- useState' ""
  reactPopover /\ setReactPopover <- useState' (Nothing :: Maybe Int)
  replyingTo /\ setReplyingTo <- useState' (Nothing :: Maybe Int)
  highlightIdx /\ setHighlightIdx <- useState' (Nothing :: Maybe Int)
  scrollBottomTrigger /\ setScrollBottomTrigger <- useState 1
  scrollY /\ setScrollY <- useState' 0.0
  scrollTrigger /\ setScrollTrigger <- useState 0
  hoveredIdx /\ setHoveredIdx <- useState' (Nothing :: Maybe Int)
  let
    selectRoom rid = do
      setActiveRoom (Just rid)
      setMessages (const (mockMessages rid))
      setReactPopover Nothing
      setReplyingTo Nothing
      setScrollBottomTrigger (_ + 1)

    sendMessage _rid msg = do
      if msg == "" then pure unit
      else do
        let newMsg = { sender: "You", body: replaceEmoji msg, isMine: true, reactions: noReactions, replyTo: replyingTo }
        setInputText ""
        setReplyingTo Nothing
        setMessages \msgs -> snoc msgs newMsg
        setScrollBottomTrigger (_ + 1)

    reactToMessage idx emoji = do
      setMessages \msgs -> fromMaybe msgs (modifyAt idx (\m -> m { reactions = addReaction emoji m.reactions }) msgs)
      setReactPopover Nothing

    scrollToMessage idx = do
      setScrollY (estimatedY idx)
      setScrollTrigger (_ + 1)
      setHighlightIdx (Just idx)
      runEffectFn2 setTimeout_ 1500 (setHighlightIdx Nothing)

    sentBubbleBg = if dp.isDark then "#65B86A" else "#5CB85C"
    receivedBubbleBg = if dp.isDark then "#3B3B3D" else "#FFFFFF"
    reactionBg = if dp.isDark then "#3B3B3D" else "#F0F0F0"
    replyQuoteBg = if dp.isDark then "#2A2A2C" else "#F0EDE8"
    replyBarColor = if dp.isDark then "#65B86A" else "#5CB85C"
    highlightBg = if dp.isDark then "#3A3A1E" else "#FFF9C4"
    chatBg = if dp.isDark then "#17212B" else "#E8DFD3"

    roomSidebar = view { style: tw "pt-2" }
      ( mockRooms <#> \r ->
          view
            { style: tw "flex-row items-center px-3 py-2 mx-2 rounded-lg"
                <> Style.style
                  { backgroundColor: if activeRoom == Just r.roomId then (if dp.isDark then "#2B5278" else "#419FD9") else "transparent" }
            }
            [ view
                { style: tw "rounded-full items-center justify-center"
                    <> Style.style { width: 32.0, height: 32.0, backgroundColor: avatarColor r.roomId }
                }
                [ text { style: tw "text-xs font-bold" <> Style.style { color: "#FFFFFF" } } (take 1 r.name) ]
            , view { style: tw "ml-2 flex-1" }
                [ text
                    { style: tw "text-sm font-semibold"
                        <> Style.style { color: if activeRoom == Just r.roomId then "#FFFFFF" else dp.fg }
                    }
                    r.name
                , text
                    { style: tw "text-xs"
                        <> Style.style { color: if activeRoom == Just r.roomId then "#FFFFFFCC" else dp.dimFg }
                    }
                    r.lastMessage
                ]
            , nativeButton
                { title: ""
                , bezelStyle: T.toolbar
                , onPress: selectRoom r.roomId
                , style: Style.style { position: "absolute", top: 0.0, left: 0.0, right: 0.0, bottom: 0.0, opacity: 0.0 }
                }
            ]
      )

    reactionPills msg =
      if length msg.reactions == 0 then mempty
      else view { style: tw "flex-row mt-1" <> Style.style { alignSelf: if msg.isMine then "flex-end" else "flex-start" } }
        ( msg.reactions <#> \r ->
            view
              { style: tw "flex-row items-center rounded-full px-2 py-0.5 mr-1"
                  <> Style.style { backgroundColor: reactionBg }
              }
              [ text { style: Style.style { fontSize: 12.0 } } r.emoji
              , text { style: tw "text-xs ml-1" <> Style.style { color: dp.dimFg } } (show r.count)
              ]
        )

    showSmiley idx = hoveredIdx == Just idx || reactPopover == Just idx

    reactionPicker idx =
      nativePopover
        { visible: reactPopover == Just idx
        , preferredEdge: T.bottom
        , behavior: T.transient
        , onClose: setReactPopover Nothing
        , style: Style.style { opacity: if showSmiley idx then 1.0 else 0.0 }
        }
        [ nativeButton
            { title: "☺"
            , bezelStyle: T.toolbar
            , onPress:
                if reactPopover == Just idx then setReactPopover Nothing
                else setReactPopover (Just idx)
            , style: Style.style { height: 24.0, width: 28.0 }
            , buttonEnabled: showSmiley idx
            }
        , view { style: tw "flex-row items-center" }
            ( mapWithIndex
                ( \_ emoji ->
                    nativeButton
                      { title: emoji
                      , bezelStyle: T.inline
                      , onPress: reactToMessage idx emoji
                      , style: Style.style { height: 28.0, width: 28.0, marginLeft: 2.0, marginRight: 2.0 }
                      }
                )
                reactionEmoji
            )
        ]

    replyQuote msg = case msg.replyTo of
      Nothing -> mempty
      Just origIdx -> case messages !! origIdx of
        Nothing -> mempty
        Just orig ->
          view
            { style: tw "flex-row rounded-lg mb-1 overflow-hidden"
                <> Style.style { backgroundColor: replyQuoteBg }
            }
            [ view { style: Style.style { width: 3.0, backgroundColor: replyBarColor } } []
            , view { style: tw "px-2 py-1" }
                [ text { style: tw "text-xs font-semibold" <> Style.style { color: replyBarColor } } orig.sender
                , text { style: tw "text-xs" <> Style.style { color: dp.dimFg } } (truncate 80 orig.body)
                ]
            , nativeButton
                { title: ""
                , bezelStyle: T.toolbar
                , onPress: scrollToMessage origIdx
                , style: Style.style { position: "absolute", top: 0.0, left: 0.0, right: 0.0, bottom: 0.0, opacity: 0.0 }
                }
            ]

    messageBubble idx msg = do
      let align = if msg.isMine then "flex-end" else "flex-start"
      let bigEmoji = isSingleEmoji msg.body
      let singleGif = singleCustomEmoji msg.body
      let senderLabel = if msg.isMine then "" else msg.sender
      let isHighlighted = highlightIdx == Just idx
      nativeHoverView
        { onHoverChange: \hovered ->
            if hovered then setHoveredIdx (Just idx)
            else setHoveredIdx Nothing
        , style: tw "px-3 mb-1 rounded-lg" <> Style.style { backgroundColor: if isHighlighted then highlightBg else "transparent" }
        }
        [ view { style: Style.style { alignSelf: align } }
            [ view
                { onDoubleClick: handler_ (setReplyingTo (Just idx))
                , style: Style.style { maxWidth: 360.0 }
                }
                [ if senderLabel == "" then text { style: Style.style { height: 0.0 } } ""
                  else text { style: tw "text-xs mb-0.5" <> Style.style { color: dp.dimFg } } senderLabel
                , replyQuote msg
                , view { style: tw "flex-row items-end" }
                    [ case singleGif of
                        Just gifFile ->
                          nativeAnimatedImage
                            { source: gifFile
                            , animating: true
                            , cornerRadius: 8.0
                            , style: Style.style { width: 120.0, height: 120.0 }
                            }
                        Nothing ->
                          if bigEmoji then
                            text
                              { style: Style.style { fontSize: 64.0, lineHeight: 72.0 } }
                              msg.body
                          else
                            view
                              { style: tw "rounded-2xl px-3 py-2"
                                  <> Style.style
                                    { backgroundColor: if msg.isMine then sentBubbleBg else receivedBubbleBg }
                              }
                              [ view { style: Style.style {} }
                                  [ text
                                      { style: Style.style { fontSize: 14.0, color: "transparent" } }
                                      msg.body
                                  , nativeRichTextLabel
                                      { text: msg.body
                                      , emojiMap: customEmojiMap
                                      , textColor: if msg.isMine then "#FFFFFF" else (if dp.isDark then "#FFFFFF" else "#000000")
                                      , fontSize: 14.0
                                      , emojiSize: 0.0
                                      , style: Style.style { position: "absolute", top: 0.0, left: 0.0, right: 0.0, bottom: 0.0 }
                                      }
                                  ]
                              ]
                    , if not msg.isMine then reactionPicker idx else mempty
                    ]
                , reactionPills msg
                ]
            ]
        ]

    replyPreview = case replyingTo of
      Nothing -> mempty
      Just idx -> case messages !! idx of
        Nothing -> mempty
        Just orig ->
          view
            { style: tw "flex-row items-center px-3 py-2"
                <> Style.style { borderTopWidth: 0.5, borderColor: dp.dimFg, backgroundColor: "transparent" }
            }
            [ view { style: Style.style { width: 3.0, height: 28.0, borderRadius: 2.0, backgroundColor: replyBarColor, marginRight: 8.0 } } []
            , view { style: tw "flex-1" }
                [ text { style: tw "text-xs font-semibold" <> Style.style { color: replyBarColor } } ("Reply to " <> orig.sender)
                , text { style: tw "text-xs" <> Style.style { color: dp.dimFg } } (truncate 80 orig.body)
                ]
            , nativeButton
                { title: "✕"
                , bezelStyle: T.toolbar
                , onPress: setReplyingTo Nothing
                , style: Style.style { height: 20.0, width: 24.0 }
                }
            ]

    activeRoomName = case activeRoom of
      Nothing -> "Select a room"
      Just rid -> fromMaybe rid (map _.name (filter (\r -> r.roomId == rid) mockRooms !! 0))

  pure do
    sidebarLayout
      { sidebar: roomSidebar
      , sidebarWidth: 220.0
      , content: view { style: tw "flex-1" <> Style.style { backgroundColor: "transparent" } }
          [ view
              { style: tw "px-4 py-2 border-b"
                  <> Style.style { borderBottomWidth: 0.5, borderColor: dp.dimFg, backgroundColor: "transparent" }
              }
              [ text { style: tw "text-base font-semibold" <> Style.style { color: dp.fg } } activeRoomName ]
          , nativePatternBackground
              { patternColor: if dp.isDark then "#FFFFFF" else "#000000"
              , background: chatBg
              , patternOpacity: if dp.isDark then 0.04 else 0.06
              , patternScale: 1.0
              , style: tw "flex-1"
              }
              ( nativeScrollView
                  { scrollToBottom: scrollBottomTrigger
                  , scrollToY: scrollY
                  , scrollToYTrigger: scrollTrigger
                  , style: tw "flex-1" <> Style.style { backgroundColor: "transparent" }
                  }
                  ( view { style: tw "py-2 pr-3" }
                      (mapWithIndex messageBubble messages)
                  )
              )
          , replyPreview
          , view
              { style: tw "flex-row items-center px-3 py-2"
                  <> Style.style { borderTopWidth: 0.5, borderColor: dp.dimFg, backgroundColor: "transparent" }
              }
              ( case activeRoom of
                  Nothing ->
                    [ text { style: tw "text-sm" <> Style.style { color: dp.dimFg } } "Select a room to start chatting" ]
                  Just rid ->
                    [ nativeTextField
                        { text: inputText
                        , placeholder: "Message..."
                        , search: false
                        , rounded: true
                        , onChangeText: \t -> setInputText (replaceEmoji t)
                        , onSubmit: \t -> sendMessage rid t
                        , style: tw "flex-1" <> Style.style { height: 28.0 }
                        }
                    , nativeButton
                        { sfSymbol: "paperplane.fill"
                        , bezelStyle: T.toolbar
                        , onPress: sendMessage rid inputText
                        , style: Style.style { height: 28.0, width: 36.0, marginLeft: 8.0 }
                        }
                    ]
              )
          ]
      }
