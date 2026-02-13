module Main where

import Prelude

import Data.Array (filter, length, sortBy)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.String (Pattern(..), lastIndexOf, drop, take)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Aff (launchAff_, try)
import Effect.Class (liftEffect)
import Effect.Uncurried (mkEffectFn1)
import React.Basic (JSX)
import React.Basic.Events (handler_)
import React.Basic.Hooks as React
import Yoga.React (component)
import Yoga.React.Native (registerComponent, view, text, textInput, pressable, scrollView, safeAreaView, activityIndicator, tw)
import Yoga.React.Native.FS as FS
import Yoga.React.Native.Style as Style
import Yoga.React.Native.StyleSheet as StyleSheet

main :: Effect Unit
main = registerComponent "YogaReactExample" \_ -> app {}

app :: {} -> JSX
app = component "App" \_ -> React.do
  currentPath /\ setCurrentPath <- React.useState FS.documentDirectoryPath
  entries /\ setEntries <- React.useState ([] :: Array FS.DirItem)
  selectedItem /\ setSelectedItem <- React.useState (Nothing :: Maybe String)
  loading /\ setLoading <- React.useState true
  hoveredItem /\ setHoveredItem <- React.useState (Nothing :: Maybe String)
  hoveredSidebar /\ setHoveredSidebar <- React.useState (Nothing :: Maybe String)
  errorMsg /\ setErrorMsg <- React.useState (Nothing :: Maybe String)
  pathInput /\ setPathInput <- React.useState ""

  let
    navigateTo path = do
      setLoading (const true)
      setSelectedItem (const Nothing)
      setErrorMsg (const Nothing)
      setCurrentPath (const path)
      setPathInput (const path)
      launchAff_ do
        result <- try (FS.readDir path)
        liftEffect case result of
          Right items -> do
            let sorted = sortBy compareDirItems items
            setEntries (const sorted)
            setLoading (const false)
          Left _ -> do
            setEntries (const [])
            setLoading (const false)
            setErrorMsg (const (Just "No permission to read this folder"))

    compareDirItems a b = case a.isDirectory, b.isDirectory of
      true, false -> LT
      false, true -> GT
      _, _ -> compare a.name b.name

    parentPath p = do
      let trimmed = if take 1 (drop (length' p - 1) p) == "/" then take (length' p - 1) p else p
      case lastIndexOf (Pattern "/") trimmed of
        Nothing -> "/"
        Just 0 -> "/"
        Just i -> take i trimmed

    length' = lengthStr

    formatSize bytes
      | bytes < 1024.0 = show (round bytes) <> " B"
      | bytes < 1048576.0 = show (round (bytes / 1024.0)) <> " KB"
      | bytes < 1073741824.0 = show (round (bytes / 1048576.0)) <> " MB"
      | otherwise = show (round (bytes / 1073741824.0)) <> " GB"

    round n = do
      let i = floor n
      i

    fileCount = length (filter _.isFile entries)
    folderCount = length (filter _.isDirectory entries)
    statusText = show folderCount <> " folders, " <> show fileCount <> " files"

    -- Sidebar icon — colored text glyph (no background box)
    sidebarIcon color glyph =
      text { style: Style.styles [ tw "mr-2 text-center", Style.style { color, fontSize: 14.0, width: 18.0 } ] } glyph

    -- Sidebar
    sidebarItem label path icon =
      pressable
        { onPress: handler_ (navigateTo path)
        , onMouseEnter: handler_ (setHoveredSidebar (const (Just path)))
        , onMouseLeave: handler_ (setHoveredSidebar (const Nothing))
        , cursor: "pointer"
        , tooltip: path
        , style: Style.styles
            [ tw "flex-row items-center px-3 py-1 mx-2 rounded"
            , Style.style
                { backgroundColor:
                    if currentPath == path then "#007AFF"
                    else if hoveredSidebar == Just path then "#e8e8ed"
                    else "transparent"
                }
            ]
        }
        [ icon
        , text
            { style: Style.styles
                [ tw "text-sm"
                , Style.style
                    { color: if currentPath == path then "#ffffff" else "#1d1d1f" }
                ]
            }
            label
        ]

    sidebarHeader label =
      text { style: Style.styles [ tw "text-xs font-semibold px-4 pt-4 pb-1", Style.style { color: "#8e8e93" } ] }
        label

    sidebar = view
      { style: Style.styles
          [ tw "pt-2 pb-4"
          , Style.style { width: 200.0, backgroundColor: "#f2f2f7", borderRightWidth: StyleSheet.hairlineWidth, borderRightColor: "#d1d1d6" }
          ]
      , allowsVibrancy: true
      }
      [ sidebarHeader "APP"
      , sidebarItem "Documents" FS.documentDirectoryPath (sidebarIcon "#007AFF" "⊡")
      , sidebarItem "Caches" FS.cachesDirectoryPath (sidebarIcon "#8E8E93" "⊘")
      , sidebarItem "Temp" FS.temporaryDirectoryPath (sidebarIcon "#FF9500" "⊙")
      , sidebarHeader "SYSTEM"
      , sidebarItem "tmp" "/tmp" (sidebarIcon "#8E8E93" "⊞")
      , sidebarItem "usr" "/usr" (sidebarIcon "#8E8E93" "⊞")
      , sidebarItem "var" "/var" (sidebarIcon "#8E8E93" "⊞")
      ]

    -- Toolbar
    toolbar = view
      { style: Style.styles
          [ tw "flex-row items-center px-3 py-2"
          , Style.style { backgroundColor: "#f2f2f7", borderBottomWidth: StyleSheet.hairlineWidth, borderBottomColor: "#d1d1d6", height: 38.0 }
          ]
      }
      [ pressable
          { onPress: handler_ (navigateTo (parentPath currentPath))
          , cursor: "pointer"
          , tooltip: "Go to parent folder (⌫)"
          , style: Style.styles
              [ tw "px-2 py-1 rounded mr-2"
              , Style.style { backgroundColor: "#e5e5ea" }
              ]
          }
          [ text { style: Style.styles [ tw "text-sm", Style.style { color: "#1d1d1f" } ] } "◀" ]
      , textInput
          { value: pathInput
          , onChangeText: mkEffectFn1 \t -> setPathInput (const t)
          , onSubmitEditing: handler_ (navigateTo pathInput)
          , style: Style.styles
              [ tw "flex-1 text-sm rounded px-2 py-1 mr-2"
              , Style.style
                  { backgroundColor: "#ffffff"
                  , borderWidth: StyleSheet.hairlineWidth
                  , borderColor: "#c6c6c8"
                  , color: "#1d1d1f"
                  }
              ]
          }
      , text { style: Style.styles [ tw "text-xs", Style.style { color: "#8e8e93" } ] } statusText
      ]

    -- File row
    fileRow item =
      pressable
        { onPress: handler_ do
            if item.isDirectory then navigateTo item.path
            else setSelectedItem (const (Just item.name))
        , onDoubleClick: handler_ do
            if item.isDirectory then navigateTo item.path
            else pure unit
        , onMouseEnter: handler_ (setHoveredItem (const (Just item.name)))
        , onMouseLeave: handler_ (setHoveredItem (const Nothing))
        , cursor: if item.isDirectory then "pointer" else "default"
        , tooltip: item.path
        , style: Style.styles
            [ tw "flex-row items-center px-4 py-2"
            , Style.style
                { backgroundColor:
                    if selectedItem == Just item.name then "#007AFF"
                    else if hoveredItem == Just item.name then "#f5f5f5"
                    else "transparent"
                , borderBottomWidth: StyleSheet.hairlineWidth
                , borderBottomColor: "#ebebeb"
                }
            ]
        }
        [ -- Icon
          fileIconView item
        , -- Name
          view { style: tw "flex-1" }
            [ text
                { style: Style.styles
                    [ tw "text-sm"
                    , Style.style
                        { color:
                            if selectedItem == Just item.name then "#ffffff"
                            else if item.isDirectory then "#007AFF"
                            else "#1d1d1f"
                        }
                    ]
                }
                item.name
            ]
        , -- Size
          text
            { style: Style.styles
                [ tw "text-xs mr-4"
                , Style.style
                    { color: if selectedItem == Just item.name then "#ffffffcc" else "#8e8e93"
                    , width: 70.0
                    }
                ]
            }
            (if item.isDirectory then "--" else formatSize item.size)
        , -- Kind
          text
            { style: Style.styles
                [ tw "text-xs"
                , Style.style
                    { color: if selectedItem == Just item.name then "#ffffffcc" else "#8e8e93"
                    , width: 80.0
                    }
                ]
            }
            (if item.isDirectory then "Folder" else fileKind item.name)
        ]

    contentIcon color glyph =
      text { style: Style.styles [ tw "mr-3 text-center", Style.style { color, fontSize: 16.0, width: 20.0 } ] } glyph

    fileIconView item
      | item.isDirectory = contentIcon "#007AFF" "▶"
      | otherwise = case extensionOf item.name of
          "purs" -> contentIcon "#8B5CF6" "◆"
          "js" -> contentIcon "#F7DF1E" "◆"
          "ts" -> contentIcon "#3178C6" "◆"
          "json" -> contentIcon "#8E8E93" "◇"
          "md" -> contentIcon "#1d1d1f" "◇"
          "txt" -> contentIcon "#8E8E93" "◇"
          "png" -> contentIcon "#34C759" "◈"
          "jpg" -> contentIcon "#34C759" "◈"
          "gif" -> contentIcon "#34C759" "◈"
          "pdf" -> contentIcon "#FF3B30" "◆"
          "zip" -> contentIcon "#FF9500" "◆"
          "gz" -> contentIcon "#FF9500" "◆"
          _ -> contentIcon "#c7c7cc" "◇"

    fileKind name = case extensionOf name of
      "purs" -> "PureScript"
      "js" -> "JavaScript"
      "ts" -> "TypeScript"
      "json" -> "JSON"
      "md" -> "Markdown"
      "txt" -> "Plain Text"
      "png" -> "PNG Image"
      "jpg" -> "JPEG Image"
      "gif" -> "GIF Image"
      "pdf" -> "PDF"
      "zip" -> "Archive"
      "gz" -> "Archive"
      "" -> "Document"
      ext -> ext <> " file"

    extensionOf name = case lastIndexOf (Pattern ".") name of
      Nothing -> ""
      Just i -> drop (i + 1) name

    -- Column headers
    columnHeaders = view
      { style: Style.styles
          [ tw "flex-row items-center px-4 py-1"
          , Style.style { backgroundColor: "#fafafa", borderBottomWidth: StyleSheet.hairlineWidth, borderBottomColor: "#d1d1d6" }
          ]
      }
      [ view { style: Style.style { width: 20.0, marginRight: 12.0 } } []
      , view { style: tw "flex-1" }
          [ text { style: Style.styles [ tw "text-xs font-semibold", Style.style { color: "#8e8e93" } ] } "Name" ]
      , text { style: Style.styles [ tw "text-xs font-semibold mr-4", Style.style { color: "#8e8e93", width: 70.0 } ] } "Size"
      , text { style: Style.styles [ tw "text-xs font-semibold", Style.style { color: "#8e8e93", width: 80.0 } ] } "Kind"
      ]

    -- Content area
    contentArea =
      if loading then
        view { style: tw "flex-1 items-center justify-center" }
          [ activityIndicator { size: "large", color: "#007AFF" } ]
      else case errorMsg of
        Just msg ->
          view { style: tw "flex-1 items-center justify-center" }
            [ text { style: Style.styles [ tw "text-base mb-2", Style.style { color: "#FF3B30" } ] } msg
            , text { style: Style.styles [ tw "text-sm", Style.style { color: "#8e8e93" } ] }
                "Try navigating to a different folder"
            ]
        Nothing ->
          view { style: tw "flex-1" }
            [ columnHeaders
            , scrollView { style: tw "flex-1" }
                (map fileRow entries)
            ]

  React.useEffectOnce do
    navigateTo FS.documentDirectoryPath
    pure (pure unit)

  pure do
    safeAreaView { style: tw "flex-1" }
      ( view { style: Style.styles [ tw "flex-1", Style.style { backgroundColor: "#ffffff" } ] }
          [ toolbar
          , view { style: tw "flex-row flex-1" }
              [ sidebar
              , contentArea
              ]
          ]
      )

foreign import homePath :: String
foreign import lengthStr :: String -> Int
foreign import floor :: Number -> Int
