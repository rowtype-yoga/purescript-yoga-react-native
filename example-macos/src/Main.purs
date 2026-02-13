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
import Yoga.React.Native.SFSymbol (sfSymbol)
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
    -- Navigation
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
            setErrorMsg (const (Just "The folder can\x2019t be opened because you don\x2019t have permission to see its contents."))

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

    -- Formatting
    formatSize bytes
      | bytes < 1024.0 = show (floor bytes) <> " bytes"
      | bytes < 1048576.0 = show (floor (bytes / 1024.0)) <> " KB"
      | bytes < 1073741824.0 = show (floor (bytes / 1048576.0)) <> " MB"
      | otherwise = show (floor (bytes / 1073741824.0)) <> " GB"

    fileCount = length (filter _.isFile entries)
    folderCount = length (filter _.isDirectory entries)
    statusText = show folderCount <> " folders, " <> show fileCount <> " files"

    -- SF Symbol icon helpers
    icon name color size =
      sfSymbol { name, color, size, style: Style.style { width: size + 4.0, height: size + 4.0 } }

    sidebarSF name color =
      view { style: Style.style { width: 20.0, height: 20.0, marginRight: 6.0, alignItems: "center", justifyContent: "center" } }
        [ icon name color 14.0 ]

    contentSF name color =
      view { style: Style.style { width: 20.0, height: 20.0, marginRight: 8.0, alignItems: "center", justifyContent: "center" } }
        [ icon name color 15.0 ]

    -- File/folder icons using SF Symbols
    fileIconView item
      | item.isDirectory = contentSF "folder.fill" "#48A5F5"
      | otherwise = case extensionOf item.name of
          "purs" -> contentSF "doc.text.fill" "#8B5CF6"
          "js" -> contentSF "doc.text.fill" "#F7DF1E"
          "ts" -> contentSF "doc.text.fill" "#3178C6"
          "json" -> contentSF "doc.text.fill" "#FF9500"
          "md" -> contentSF "doc.richtext.fill" "#1d1d1f"
          "txt" -> contentSF "doc.text" "#8E8E93"
          "png" -> contentSF "photo.fill" "#34C759"
          "jpg" -> contentSF "photo.fill" "#34C759"
          "gif" -> contentSF "photo.fill" "#34C759"
          "svg" -> contentSF "photo" "#FF9500"
          "pdf" -> contentSF "doc.richtext.fill" "#FF3B30"
          "zip" -> contentSF "doc.zipper" "#8E8E93"
          "gz" -> contentSF "doc.zipper" "#8E8E93"
          "lock" -> contentSF "lock.fill" "#8E8E93"
          _ -> contentSF "doc.fill" "#c7c7cc"

    fileKind name = case extensionOf name of
      "purs" -> "PureScript Source"
      "js" -> "JavaScript"
      "ts" -> "TypeScript"
      "json" -> "JSON Document"
      "md" -> "Markdown"
      "txt" -> "Plain Text"
      "png" -> "PNG Image"
      "jpg" -> "JPEG Image"
      "gif" -> "GIF Image"
      "svg" -> "SVG Image"
      "pdf" -> "PDF Document"
      "zip" -> "ZIP Archive"
      "gz" -> "GZip Archive"
      "lock" -> "Lock File"
      "" -> "Document"
      ext -> ext <> " File"

    extensionOf name = case lastIndexOf (Pattern ".") name of
      Nothing -> ""
      Just i -> drop (i + 1) name

    -- Sidebar
    sidebarItem label path sideIcon =
      pressable
        { onPress: handler_ (navigateTo path)
        , onMouseEnter: handler_ (setHoveredSidebar (const (Just label)))
        , onMouseLeave: handler_ (setHoveredSidebar (const Nothing))
        , cursor: "pointer"
        , tooltip: path
        , style: Style.style
            { flexDirection: "row"
            , alignItems: "center"
            , paddingHorizontal: 8.0
            , paddingVertical: 3.0
            , marginHorizontal: 8.0
            , borderRadius: 5.0
            , backgroundColor:
                if currentPath == path then "rgba(0,0,0,0.1)"
                else if hoveredSidebar == Just label then "rgba(0,0,0,0.04)"
                else "transparent"
            }
        }
        [ sideIcon
        , text
            { style: Style.style
                { fontSize: 13.0
                , color: "#1d1d1f"
                , letterSpacing: -0.08
                }
            }
            label
        ]

    sidebarHeader label =
      text
        { style: Style.style
            { fontSize: 11.0
            , fontWeight: "600"
            , color: "#8e8e93"
            , paddingHorizontal: 16.0
            , paddingTop: 16.0
            , paddingBottom: 4.0
            , letterSpacing: 0.06
            }
        }
        label

    sidebar = view
      { style: Style.style
          { width: 200.0
          , backgroundColor: "rgba(246,246,246,0.92)"
          , borderRightWidth: StyleSheet.hairlineWidth
          , borderRightColor: "#c6c6c8"
          , paddingTop: 4.0
          , paddingBottom: 8.0
          }
      , allowsVibrancy: true
      }
      [ sidebarHeader "Favorites"
      , sidebarItem "Documents" FS.documentDirectoryPath (sidebarSF "folder.fill" "#48A5F5")
      , sidebarItem "Caches" FS.cachesDirectoryPath (sidebarSF "archivebox.fill" "#8E8E93")
      , sidebarItem "Temp" FS.temporaryDirectoryPath (sidebarSF "clock.fill" "#FF9500")
      , sidebarHeader "Locations"
      , sidebarItem "Root" "/" (sidebarSF "externaldrive.fill" "#8E8E93")
      , sidebarItem "tmp" "/tmp" (sidebarSF "folder.fill" "#8E8E93")
      , sidebarItem "usr" "/usr" (sidebarSF "folder.fill" "#8E8E93")
      ]

    -- Toolbar
    toolbar = view
      { style: Style.style
          { flexDirection: "row"
          , alignItems: "center"
          , paddingHorizontal: 8.0
          , height: 38.0
          , backgroundColor: "rgba(246,246,246,0.92)"
          , borderBottomWidth: StyleSheet.hairlineWidth
          , borderBottomColor: "#c6c6c8"
          }
      }
      [ -- Back button with SF Symbol
        pressable
          { onPress: handler_ (navigateTo (parentPath currentPath))
          , cursor: "pointer"
          , tooltip: "Back"
          , style: Style.style
              { width: 28.0
              , height: 24.0
              , borderRadius: 5.0
              , alignItems: "center"
              , justifyContent: "center"
              , backgroundColor: "transparent"
              , marginRight: 2.0
              }
          }
          [ icon "chevron.left" "#007AFF" 14.0 ]
      , -- Path bar
        view { style: Style.style { flex: 1.0, marginHorizontal: 8.0 } }
          [ textInput
              { value: pathInput
              , onChangeText: mkEffectFn1 \t -> setPathInput (const t)
              , onSubmitEditing: handler_ (navigateTo pathInput)
              , style: Style.style
                  { fontSize: 12.0
                  , height: 22.0
                  , borderRadius: 5.0
                  , paddingHorizontal: 8.0
                  , backgroundColor: "rgba(0,0,0,0.04)"
                  , color: "#1d1d1f"
                  , textAlign: "center"
                  }
              }
          ]
      , -- Item count
        text
          { style: Style.style { fontSize: 11.0, color: "#8e8e93", marginLeft: 8.0 } }
          statusText
      ]

    -- Column headers
    columnHeaders = view
      { style: Style.style
          { flexDirection: "row"
          , alignItems: "center"
          , paddingHorizontal: 12.0
          , paddingVertical: 4.0
          , borderBottomWidth: StyleSheet.hairlineWidth
          , borderBottomColor: "#d1d1d6"
          , backgroundColor: "#fafafa"
          }
      }
      [ view { style: Style.style { width: 28.0 } } []
      , view { style: Style.style { flex: 1.0 } }
          [ colHeaderText "Name" ]
      , view { style: Style.style { width: 90.0 } }
          [ colHeaderText "Size" ]
      , view { style: Style.style { width: 120.0 } }
          [ colHeaderText "Kind" ]
      ]

    colHeaderText label =
      text
        { style: Style.style
            { fontSize: 11.0
            , fontWeight: "500"
            , color: "#8e8e93"
            }
        }
        label

    -- File row
    isSelected item = selectedItem == Just item.name
    isHovered item = hoveredItem == Just item.name

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
        , style: Style.style
            { flexDirection: "row"
            , alignItems: "center"
            , paddingHorizontal: 12.0
            , height: 24.0
            , backgroundColor:
                if isSelected item then "#0058D0"
                else if isHovered item then "rgba(0,0,0,0.04)"
                else "transparent"
            , borderRadius: if isSelected item then 4.0 else 0.0
            , marginHorizontal: if isSelected item then 4.0 else 0.0
            }
        }
        [ fileIconView item
        , view { style: Style.style { flex: 1.0 } }
            [ text
                { style: Style.style
                    { fontSize: 13.0
                    , color:
                        if isSelected item then "#ffffff"
                        else "#1d1d1f"
                    , letterSpacing: -0.08
                    }
                , numberOfLines: 1
                }
                item.name
            ]
        , view { style: Style.style { width: 90.0 } }
            [ text
                { style: Style.style
                    { fontSize: 11.0
                    , color: if isSelected item then "rgba(255,255,255,0.8)" else "#8e8e93"
                    }
                }
                (if item.isDirectory then "--" else formatSize item.size)
            ]
        , view { style: Style.style { width: 120.0 } }
            [ text
                { style: Style.style
                    { fontSize: 11.0
                    , color: if isSelected item then "rgba(255,255,255,0.8)" else "#8e8e93"
                    }
                , numberOfLines: 1
                }
                (if item.isDirectory then "Folder" else fileKind item.name)
            ]
        ]

    -- Content area
    contentArea =
      if loading then
        view { style: tw "flex-1 items-center justify-center" }
          [ activityIndicator { size: "large", color: "#007AFF" } ]
      else case errorMsg of
        Just msg ->
          view
            { style: Style.style
                { flex: 1.0
                , alignItems: "center"
                , justifyContent: "center"
                , paddingHorizontal: 40.0
                }
            }
            [ icon "exclamationmark.triangle.fill" "#FF9500" 32.0
            , text
                { style: Style.style { fontSize: 13.0, color: "#1d1d1f", fontWeight: "600", marginBottom: 4.0, marginTop: 12.0 } }
                "The folder can\x2019t be opened."
            , text
                { style: Style.style { fontSize: 11.0, color: "#8e8e93", textAlign: "center" } }
                msg
            ]
        Nothing ->
          view { style: Style.style { flex: 1.0 } }
            [ columnHeaders
            , scrollView { style: Style.style { flex: 1.0 } }
                (map fileRow entries)
            , -- Status bar
              view
                { style: Style.style
                    { flexDirection: "row"
                    , alignItems: "center"
                    , justifyContent: "center"
                    , height: 22.0
                    , borderTopWidth: StyleSheet.hairlineWidth
                    , borderTopColor: "#d1d1d6"
                    , backgroundColor: "#fafafa"
                    }
                }
                [ text
                    { style: Style.style { fontSize: 11.0, color: "#8e8e93" } }
                    statusText
                ]
            ]

  React.useEffectOnce do
    navigateTo FS.documentDirectoryPath
    pure (pure unit)

  pure do
    safeAreaView { style: tw "flex-1" }
      ( view { style: Style.style { flex: 1.0, backgroundColor: "#ffffff" } }
          [ toolbar
          , view { style: Style.style { flexDirection: "row", flex: 1.0 } }
              [ sidebar
              , contentArea
              ]
          ]
      )

foreign import homePath :: String
foreign import lengthStr :: String -> Int
foreign import floor :: Number -> Int
