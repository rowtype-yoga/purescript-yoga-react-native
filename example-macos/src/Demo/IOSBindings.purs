module Demo.IOSBindings
  ( iosDemo
  ) where

import Prelude

import Data.Array.NonEmpty as NonEmptyArray
import Data.DateTime.Instant (Instant, instant, toDateTime)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.String.CodeUnits as String
import Data.Time.Duration (Milliseconds(..))
import Demo.DatingDemo (datingDemo)
import Demo.Shared (DemoProps)
import Demo.SpringAnimation (springDemo)
import Effect (Effect)
import Effect.Aff (attempt, launchAff_)
import Effect.Class (liftEffect)
import Effect.Exception (message)
import Effect.Uncurried (EffectFn1, mkEffectFn1)
import React.Basic (JSX)
import React.Basic.Events (EventHandler, handler_)
import React.Basic.Hooks (useState', (/\))
import React.Basic.Hooks as React
import Yoga.React (component)
import Yoga.React.Native
  ( activityIndicator
  , button
  , image
  , imageBackground
  , keyboardAvoidingView
  , modal
  , pressable
  , scrollView
  , switch
  , text
  , textInput
  , tw
  , view
  )
import Yoga.React.Native.Alert as Alert
import Yoga.React.Native.Appearance as Appearance
import Yoga.React.Native.IOS.ActionSheet as ActionSheet
import Yoga.React.Native.IOS.CollectionView as CollectionView
import Yoga.React.Native.IOS.DatePicker as DatePicker
import Yoga.React.Native.IOS.Haptics as Haptics
import Yoga.React.Native.IOS.LinkingIOS as LinkingIOS
import Yoga.React.Native.IOS.SafeArea as SafeArea
import Yoga.React.Native.IOS.SearchBar as SearchBar
import Yoga.React.Native.IOS.SegmentedControl as SegmentedControl
import Yoga.React.Native.Image (uri)
import Yoga.React.Native.Style as Style
import Yoga.React.Native.Types (Availability(..), AvailabilityReason(..), ColorScheme(..), ControlState(..), ItemId(..), RefreshState(..), URL(..))

data CatalogueSegment
  = OverviewSegment
  | DetailsSegment
  | MetricsSegment

derive instance Eq CatalogueSegment

instance Show CatalogueSegment where
  show OverviewSegment = "overview"
  show DetailsSegment = "details"
  show MetricsSegment = "metrics"

segmentIndex :: CatalogueSegment -> Int
segmentIndex = case _ of
  OverviewSegment -> 0
  DetailsSegment -> 1
  MetricsSegment -> 2

catalogueSegments :: NonEmptyArray.NonEmptyArray (SegmentedControl.Segment CatalogueSegment)
catalogueSegments = NonEmptyArray.cons'
  { value: OverviewSegment, label: "Overview" }
  [ { value: DetailsSegment, label: "Details" }
  , { value: MetricsSegment, label: "Metrics" }
  ]

type CatalogueCollectionValue =
  { id :: ItemId
  , index :: Int
  }

catalogueCollectionItems :: Either CollectionView.CollectionItemsError (CollectionView.CollectionItems CatalogueCollectionValue)
catalogueCollectionItems = CollectionView.collectionItems
  [ collectionItem 0 "pressable" "Pressable"
  , collectionItem 1 "text-input" "TextInput"
  , collectionItem 2 "switch" "Switch"
  , collectionItem 3 "modal" "Modal"
  , collectionItem 4 "image" "Image"
  , collectionItem 5 "collection-view" "UICollectionView"
  , collectionItem 6 "safe-area" "SafeAreaView"
  , collectionItem 7 "keyboard-avoiding" "KeyboardAvoidingView"
  , collectionItem 8 "activity-indicator" "ActivityIndicator"
  , collectionItem 9 "refresh-control" "UIRefreshControl"
  , collectionItem 10 "status-bar" "StatusBar"
  ]
  where
  collectionItem indexValue id title =
    let itemId = ItemId id
    in { id: itemId, value: { id: itemId, index: indexValue }, title }

data CatalogueAction
  = CancelCatalogueAction
  | SaveCatalogueAction
  | DeleteCatalogueAction

derive instance Eq CatalogueAction

instance Show CatalogueAction where
  show CancelCatalogueAction = "Cancel"
  show SaveCatalogueAction = "Save"
  show DeleteCatalogueAction = "Delete"

catalogueActions :: Either ActionSheet.ActionSheetConfigurationError (ActionSheet.Actions CatalogueAction)
catalogueActions = ActionSheet.actions $ NonEmptyArray.cons'
  { value: CancelCatalogueAction, label: "Cancel", style: ActionSheet.CancelAction, state: Enabled }
  [ { value: SaveCatalogueAction, label: "Save", style: ActionSheet.DefaultAction, state: Enabled }
  , { value: DeleteCatalogueAction, label: "Delete", style: ActionSheet.DestructiveAction, state: Enabled }
  ]

initialDateValue :: Maybe Instant
initialDateValue = instant (Milliseconds 1783848600000.0)

catalogueDateBounds :: Either DatePicker.DatePickerConfigurationError DatePicker.DatePickerBounds
catalogueDateBounds = DatePicker.datePickerBounds Nothing Nothing

vibration400ms :: Maybe Haptics.VibrationDuration
vibration400ms = Haptics.vibrationDuration 400.0

pureScriptWebsite :: URL
pureScriptWebsite = URL "https://purescript.org"

showItemId :: ItemId -> String
showItemId (ItemId value) = value

showURL :: URL -> String
showURL (URL value) = value

availabilityStatus :: String -> Availability Unit -> String
availabilityStatus action = case _ of
  Available _ -> "Dispatched " <> action <> "."
  Unavailable UnsupportedPlatform -> action <> " unavailable: unsupported platform."
  Unavailable MissingNativeModule -> action <> " unavailable: native module missing."

dateValueLabel :: Instant -> String
dateValueLabel = show <<< toDateTime

type Page = String

landingPage :: Page
landingPage = "landing"

controlsPage :: Page
controlsPage = "controls"

inputsPage :: Page
inputsPage = "inputs"

uikitPage :: Page
uikitPage = "uikit"

feedbackPage :: Page
feedbackPage = "feedback"

dataPage :: Page
dataPage = "data"

listPage :: Page
listPage = "list"

platformPage :: Page
platformPage = "platform"

springsPage :: Page
springsPage = "springs"

datingPage :: Page
datingPage = "dating"

type IOSScreenProps =
  { page :: Page
  , navigate :: Page -> Effect Unit
  , goBack :: Effect Unit
  }

foreign import iosNativeStackImpl :: (IOSScreenProps -> JSX) -> JSX

iosDemo :: {} -> JSX
iosDemo _ = iosNativeStackImpl iosScreen

iosScreen :: IOSScreenProps -> JSX
iosScreen = component "IOSScreen" \props -> React.do
  status /\ setStatus <- useState' "Ready — choose an example below."
  pressCount /\ setPressCount <- useState' 0
  isPressed /\ setIsPressed <- useState' false
  switchOn /\ setSwitchOn <- useState' false
  name /\ setName <- useState' ""
  password /\ setPassword <- useState' ""
  notes /\ setNotes <- useState' ""
  inputStatus /\ setInputStatus <- useState' "No field edited yet."
  dateValue /\ setDateValue <- useState' initialDateValue
  selectedSegment /\ setSelectedSegment <- useState' OverviewSegment
  searchText /\ setSearchText <- useState' (SearchBar.SearchText "")
  searchStatus /\ setSearchStatus <- useState' "Result: no search event yet."
  busy /\ setBusy <- useState' true
  modalVisible /\ setModalVisible <- useState' false
  imageStatus /\ setImageStatus <- useState' "Image waiting to load."
  listStatus /\ setListStatus <- useState' "Tap a row or pull to refresh."
  selectedId /\ setSelectedId <- useState' Nothing
  refreshCount /\ setRefreshCount <- useState' 0
  colorScheme <- Appearance.useColorScheme
  let isDark = colorScheme == Just Dark
  let dp = palette isDark
  let navigate next = do
        setStatus "Ready — follow the expected result on this screen."
        props.navigate next
  let backButton = quietButton dp "‹ BACK" props.goBack
  pure do
    SafeArea.safeAreaView { style: tw "flex-1" <> Style.style { backgroundColor: dp.bg } } $
      if props.page == springsPage then
        view { style: tw "flex-1" }
          [ view { style: tw "px-4 pt-2" } [ backButton ]
          , springDemo dp
          ]
      else if props.page == listPage then
        listDemo dp backButton listStatus setListStatus selectedId setSelectedId refreshCount setRefreshCount
      else if props.page == landingPage then
        landing dp navigate status
      else if props.page == datingPage then
        datingDemo backButton
      else
        scrollView
          { style: tw "flex-1"
          , contentContainerStyle: tw "px-4 pb-8"
          , showsVerticalScrollIndicator: true
          , automaticallyAdjustKeyboardInsets: true
          , keyboardDismissMode: "interactive"
          , keyboardShouldPersistTaps: "never"
          }
          [ view { style: tw "pt-2 mb-3" } [ backButton ]
          , if props.page == controlsPage then controls dp pressCount setPressCount isPressed setIsPressed switchOn setSwitchOn
            else if props.page == inputsPage then inputs dp name setName password setPassword notes setNotes inputStatus setInputStatus
            else if props.page == uikitPage then uikitWidgets dp dateValue setDateValue selectedSegment setSelectedSegment searchText setSearchText searchStatus setSearchStatus
            else if props.page == feedbackPage then feedback dp busy setBusy modalVisible setModalVisible status setStatus
            else if props.page == dataPage then dataAndMedia dp imageStatus setImageStatus (navigate listPage)
            else platformServices dp status setStatus
          ]
palette :: Boolean -> DemoProps
palette isDark =
  { fg: if isDark then "#F5F5F7" else "#1C1C1E"
  , dimFg: if isDark then "#AEAEB2" else "#636366"
  , cardBg: if isDark then "#2C2C2E" else "#F2F2F7"
  , bg: if isDark then "#1C1C1E" else "#FAFAFC"
  , isDark
  }

landing :: DemoProps -> (Page -> Effect Unit) -> String -> JSX
landing dp navigate status =
  scrollView
    { style: tw "flex-1"
    , contentContainerStyle: tw "px-4 pb-8"
    , showsVerticalScrollIndicator: true
    }
    [ view { style: tw "pt-5 pb-4" }
        [ eyebrow dp "NATIVE IOS COMPONENT CATALOGUE"
        , text { style: tw "text-3xl font-bold" <> Style.style { color: dp.fg } } "iOS component catalogue"
        , text { style: tw "text-sm mt-2" <> Style.style { color: dp.dimFg, lineHeight: 20.0 } }
            "Exercise React Native components and genuine UIKit bindings with observable results."
        ]
    , statusPanel dp "Walkthrough status" status
    , category dp "01" "Controls" "Portable React Native press, switch and button controls" (navigate controlsPage)
    , category dp "02" "Text & keyboard" "Portable React Native inputs and keyboard behavior" (navigate inputsPage)
    , category dp "03" "UIKit widgets" "Genuine UIKit date picker, segmented control and search bar" (navigate uikitPage)
    , category dp "04" "Feedback & overlays" "Progress, alert, modal and explicit dismissal results" (navigate feedbackPage)
    , category dp "05" "Data & media" "Image, image background, virtualized list and refresh" (navigate dataPage)
    , category dp "06" "Apple services" "Action sheet, haptics, appearance, links and safe area" (navigate platformPage)
    , category dp "07" "Springs & gestures" "Native-driver springs, press transitions, stagger and pan-to-snap" (navigate springsPage)
    , category dp "08" "Lumen dating demo" "A polished UI-only dating discovery experience" (navigate datingPage)
    ]

category :: DemoProps -> String -> String -> String -> Effect Unit -> JSX
category dp number title subtitle onPress =
  pressable
    { onPress: handler_ onPress
    , accessibilityLabel: "Open " <> title <> " examples"
    , style: tw "py-4 border-b" <> Style.style { borderColor: if dp.isDark then "#3A3A3C" else "#D1D1D6" }
    }
    [ view { style: tw "flex-row items-start" }
        [ text { style: tw "text-xs font-semibold mr-4 mt-1" <> Style.style { color: "#0A84FF", width: 24.0 } } number
        , view { style: tw "flex-1" }
            [ text { style: tw "text-lg font-semibold" <> Style.style { color: dp.fg } } title
            , text { style: tw "text-sm mt-1" <> Style.style { color: dp.dimFg, lineHeight: 19.0 } } subtitle
            ]
        , text { style: tw "text-xl ml-2" <> Style.style { color: dp.dimFg } } "›"
        ]
    ]

controls :: DemoProps -> Int -> (Int -> Effect Unit) -> Boolean -> (Boolean -> Effect Unit) -> Boolean -> (Boolean -> Effect Unit) -> JSX
controls dp count setCount held setHeld enabled setEnabled =
  view {}
    [ pageHeader dp "Controls" "Touch behavior should be visible before, during and after interaction."
    , example dp "Pressable" "Expected: tap increments the count; holding changes the live state."
        [ pressable
            { onPress: handler_ (setCount (count + 1))
            , onPressIn: handler_ (setHeld true)
            , onPressOut: handler_ (setHeld false)
            , onLongPress: handler_ (setCount 0)
            , accessibilityLabel: "Pressable counter; long press resets"
            , style: tw "rounded-lg px-4 py-3" <> Style.style { backgroundColor: if held then "#0060C7" else "#0A84FF" }
            }
            [ text { style: tw "text-sm font-semibold text-center" <> Style.style { color: "#F9F9FB" } }
                (if held then "Pressed…" else "Tap me · " <> show count)
            ]
        , result dp (if count == 0 then "Result: no taps recorded." else "Result: received " <> show count <> " tap(s). Long-press resets.")
        ]
    , example dp "Native Button" "Expected: first button records success; disabled button does nothing."
        [ button { title: "Run native action", onPress: handler_ (setCount (count + 1)), color: "#0A84FF", accessibilityLabel: "Run native button action" }
        , button { title: "Disabled example", onPress: handler_ (pure unit), disabled: true, color: "#8E8E93", accessibilityLabel: "Disabled button example" }
        , result dp ("Result counter: " <> show count)
        ]
    , example dp "Switch" "Expected: label mirrors the native switch immediately."
        [ view { style: tw "flex-row items-center justify-between" }
            [ text { style: tw "text-sm" <> Style.style { color: dp.fg } } "Catalogue notifications"
            , switch
                { value: enabled
                , onValueChange: mkEffectFn1 setEnabled
                , trackColor: { false: "#636366", true: "#30D158" }
                , thumbColor: "#F9F9FB"
                , accessibilityLabel: "Catalogue notifications"
                }
            ]
        , result dp (if enabled then "Result: switch is ON." else "Result: switch is OFF.")
        ]
    ]

inputs :: DemoProps -> String -> (String -> Effect Unit) -> String -> (String -> Effect Unit) -> String -> (String -> Effect Unit) -> String -> (String -> Effect Unit) -> JSX
inputs dp name setName password setPassword notes setNotes status setStatus =
  keyboardAvoidingView
    { behavior: "padding"
    , enabled: true
    , keyboardVerticalOffset: 12.0
    , style: tw "flex-1"
    }
    [ pageHeader dp "Text & keyboard" "Edit each field and verify focus, masking, wrapping and keyboard avoidance."
    , example dp "Text input" "Expected: text echoes below; Return records submission."
        [ input dp
            { value: name
            , onChangeText: mkEffectFn1 \value -> do
                setName value
                setStatus ("Editing name: " <> value)
            , placeholder: "Type a name"
            , onSubmitEditing: handler_ (setStatus ("Submitted name: " <> name))
            , onFocus: handler_ (setStatus "Name field focused.")
            , onBlur: handler_ (setStatus "Name field blurred.")
            }
        , result dp (if name == "" then "Result: waiting for text." else "Result: “" <> name <> "”")
        ]
    , example dp "Secure input" "Expected: typed characters are obscured; only character count is reported."
        [ textInput
            { value: password
            , onChangeText: mkEffectFn1 \value -> do
                setPassword value
                setStatus "Secure field edited."
            , placeholder: "Password"
            , placeholderTextColor: dp.dimFg
            , secureTextEntry: true
            , autoCapitalize: "none"
            , autoCorrect: false
            , accessibilityLabel: "Secure password field"
            , style: inputStyle dp 48.0
            }
        , result dp ("Result: " <> show (String.length password) <> " concealed character(s).")
        ]
    , example dp "Multiline input" "Expected: text wraps across up to four visible lines."
        [ textInput
            { value: notes
            , onChangeText: mkEffectFn1 \value -> do
                setNotes value
                setStatus "Multiline notes updated."
            , placeholder: "Write two or three lines…"
            , placeholderTextColor: dp.dimFg
            , multiline: true
            , numberOfLines: 4
            , accessibilityLabel: "Multiline notes field"
            , style: inputStyle dp 104.0 <> Style.style { textAlignVertical: "top" }
            }
        , result dp (if notes == "" then "Result: no notes yet." else "Result: multiline value captured.")
        ]
    , statusPanel dp "Input event status" status
    ]

uikitWidgets
  :: DemoProps
  -> Maybe Instant
  -> (Maybe Instant -> Effect Unit)
  -> CatalogueSegment
  -> (CatalogueSegment -> Effect Unit)
  -> SearchBar.SearchText
  -> (SearchBar.SearchText -> Effect Unit)
  -> String
  -> (String -> Effect Unit)
  -> JSX
uikitWidgets dp maybeDateValue setDateValue selectedSegment setSelectedSegment searchText setSearchText searchStatus setSearchStatus =
  view {}
    [ pageHeader dp "UIKit widgets" "These exercises render genuine UIKit widgets rather than portable React Native controls."
    , case maybeDateValue, catalogueDateBounds of
        Nothing, _ -> configurationError dp "Date picker configuration error: initial instant is outside the supported range."
        _, Left DatePicker.MinimumAfterMaximum -> configurationError dp "Date picker configuration error: minimum is after maximum."
        Just dateValue, Right bounds ->
          example dp "Genuine UIKit UIDatePicker" "Expected: the native date-time wheel starts at the controlled instant and every change updates that value below."
            [ DatePicker.datePicker dateValue DatePicker.DateAndTime (setDateValue <<< Just)
                { bounds
                , state: Enabled
                , accessibilityLabel: "Genuine UIKit date and time picker"
                , style: Style.style { width: "100%", height: 216.0 }
                }
            , result dp ("Result: controlled instant = " <> dateValueLabel dateValue)
            ]
    , example dp "Genuine UIKit UISegmentedControl" "Expected: selecting one of three stable segments reports its id and zero-based index."
        [ SegmentedControl.segmentedControl catalogueSegments selectedSegment setSelectedSegment
            { state: Enabled
            , accessibilityLabel: "Genuine UIKit three-option segmented control"
            , style: Style.style { width: "100%", height: 40.0 }
            }
        , result dp ("Result: selected id = " <> show selectedSegment <> "; index = " <> show (segmentIndex selectedSegment) <> ".")
        ]
    , example dp "Genuine UIKit UISearchBar" "Expected: text remains controlled; editing, Search submission and Cancel each report their native callback."
        [ SearchBar.searchBar searchText
            (\value@(SearchBar.SearchText textValue) -> do
              setSearchText value
              setSearchStatus ("Result: change = “" <> textValue <> "”.")
            )
            { placeholder: Just "Search the catalogue"
            , cancelButton: SearchBar.ShowCancelButton
            , state: Enabled
            , onSubmit: Just \(SearchBar.SearchText value) ->
                setSearchStatus ("Result: submitted = “" <> value <> "”.")
            , onCancel: Just do
                setSearchText (SearchBar.SearchText "")
                setSearchStatus "Result: cancel received; controlled text cleared."
            , accessibilityLabel: "Genuine UIKit catalogue search bar"
            , style: Style.style { width: "100%", height: 56.0 }
            }
        , result dp searchStatus
        ]
    ]

input :: DemoProps -> { value :: String, onChangeText :: EffectFn1 String Unit, placeholder :: String, onSubmitEditing :: EventHandler, onFocus :: EventHandler, onBlur :: EventHandler } -> JSX
input dp props =
  textInput
    { value: props.value
    , onChangeText: props.onChangeText
    , placeholder: props.placeholder
    , placeholderTextColor: dp.dimFg
    , autoCapitalize: "words"
    , autoCorrect: true
    , onSubmitEditing: props.onSubmitEditing
    , onFocus: props.onFocus
    , onBlur: props.onBlur
    , accessibilityLabel: props.placeholder
    , style: inputStyle dp 48.0
    }

inputStyle :: DemoProps -> Number -> Style.Style
inputStyle dp height =
  tw "rounded-lg px-3" <> Style.style
    { height
    , color: dp.fg
    , backgroundColor: dp.bg
    , borderWidth: 1.0
    , borderColor: if dp.isDark then "#48484A" else "#C7C7CC"
    }

feedback :: DemoProps -> Boolean -> (Boolean -> Effect Unit) -> Boolean -> (Boolean -> Effect Unit) -> String -> (String -> Effect Unit) -> JSX
feedback dp busy setBusy visible setVisible status setStatus =
  view {}
    [ pageHeader dp "Feedback & overlays" "Every overlay provides a visible completion path."
    , example dp "Activity indicator" "Expected: control alternates between spinning and stopped."
        [ view { style: tw "flex-row items-center justify-between" }
            [ activityIndicator { animating: busy, size: "large", color: "#0A84FF", accessibilityLabel: "Loading indicator" }
            , quietButton dp (if busy then "Stop" else "Start") (setBusy (not busy))
            ]
        , result dp (if busy then "Result: indicator is animating." else "Result: indicator is stopped.")
        ]
    , example dp "Alert" "Expected: choose an action; the selected button appears below."
        [ primaryButton "Show alert" $ Alert.alertWithButtons "Catalogue alert" "Choose one result to test the callback."
            [ { text: "Cancel", style: "cancel", onPress: setStatus "Alert result: Cancel." }
            , { text: "Confirm", style: "default", onPress: setStatus "Alert result: Confirm." }
            ]
        , result dp status
        ]
    , example dp "Modal" "Expected: a full-screen sheet appears; Done dismisses it."
        [ primaryButton "Present modal" do
            setStatus "Modal presented."
            setVisible true
        , result dp (if visible then "Result: modal is visible." else "Result: modal is dismissed.")
        , modal
            { visible
            , animationType: "slide"
            , presentationStyle: "pageSheet"
            , onShow: handler_ (setStatus "Modal onShow fired.")
            , onDismiss: handler_ (setStatus "Modal onDismiss fired.")
            , onRequestClose: handler_ (setVisible false)
            }
            [ SafeArea.safeAreaView { style: tw "flex-1" <> Style.style { backgroundColor: dp.bg } } $
                view { style: tw "flex-1 px-6 pt-8" }
                  [ eyebrow dp "MODAL EXAMPLE"
                  , text { style: tw "text-2xl font-bold mb-2" <> Style.style { color: dp.fg } } "Native presentation"
                  , text { style: tw "text-sm mb-6" <> Style.style { color: dp.dimFg } } "Expected: tapping Done returns to Feedback & overlays."
                  , primaryButton "Done" do
                      setStatus "Modal dismissed with Done."
                      setVisible false
                  ]
            ]
        ]
    ]

dataAndMedia :: DemoProps -> String -> (String -> Effect Unit) -> Effect Unit -> JSX
dataAndMedia dp imageStatus setImageStatus openList =
  view {}
    [ pageHeader dp "Data & media" "Network media reports lifecycle events; the native UIKit collection has its own non-nested screen."
    , example dp "Image" "Expected: remote image fills the 16:9 frame and reports loaded or failed."
        [ image
            { source: uri "https://images.unsplash.com/photo-1519608487953-e999c86e7455?w=900"
            , resizeMode: "cover"
            , onLoadStart: handler_ (setImageStatus "Image loading…")
            , onLoad: handler_ (setImageStatus "Image loaded successfully.")
            , onLoadEnd: handler_ (pure unit)
            , onError: handler_ (setImageStatus "Image failed to load; check network access.")
            , accessibilityLabel: "Night sky over a mountain ridge"
            , style: tw "rounded-lg" <> Style.style { height: 180.0, width: "100%" }
            }
        , result dp imageStatus
        ]
    , example dp "Image background" "Expected: editorial caption remains readable over the photograph."
        [ imageBackground
            { source: uri "https://images.unsplash.com/photo-1470770841072-f978cf4d019e?w=900"
            , resizeMode: "cover"
            , imageStyle: tw "rounded-lg"
            , style: tw "rounded-lg overflow-hidden"
            , accessibilityLabel: "Mountain lake photograph with caption"
            }
            [ view { style: tw "justify-end px-4 py-4" <> Style.style { height: 150.0, backgroundColor: "rgba(0,0,0,0.32)" } }
                [ text { style: tw "text-lg font-bold" <> Style.style { color: "#F9F9FB" } } "ImageBackground"
                , text { style: tw "text-xs mt-1" <> Style.style { color: "#E5E5EA" } } "Result: child content is layered over the image."
                ]
            ]
        ]
    , example dp "Native collection + refresh" "Expected: opens a genuine UIKit UICollectionView with native selection, cell reuse, and pull-to-refresh."
        [ primaryButton "Open native collection" openList ]
    ]

listDemo :: DemoProps -> JSX -> String -> (String -> Effect Unit) -> Maybe ItemId -> (Maybe ItemId -> Effect Unit) -> Int -> (Int -> Effect Unit) -> JSX
listDemo dp backButton listStatus setListStatus selectedId setSelectedId refreshes setRefreshes =
  view { style: tw "flex-1 px-4" }
    [ view { style: tw "pt-2 mb-3" } [ backButton ]
    , pageHeader dp "Native UIKit collection" "UICollectionView owns scrolling, cell reuse, selection visuals, accessibility state, and pull-to-refresh."
    , result dp (listStatus <> " · refreshes: " <> show refreshes)
    , case catalogueCollectionItems of
        Left CollectionView.EmptyItemId -> configurationError dp "Collection configuration error: an item id is empty."
        Left (CollectionView.DuplicateItemId duplicate) -> configurationError dp ("Collection configuration error: duplicate item id “" <> showItemId duplicate <> "”.")
        Right items -> CollectionView.collectionView items
          (\selection -> do
            availability <- Haptics.selectionChanged
            setSelectedId (Just selection.id)
            setListStatus
              ( "Selected native row " <> show selection.index <> ": " <> showItemId selection.id
                  <> " · " <> availabilityStatus "selection feedback" availability
              )
          )
          (do
            setRefreshes (refreshes + 1)
            setListStatus ("Native refresh completed · " <> show (refreshes + 1))
          )
          { selected: selectedId
          , refreshState: RefreshIdle
          , accessibilityLabel: "Native UIKit component collection"
          , style: tw "flex-1"
          }
    ]

platformServices :: DemoProps -> String -> (String -> Effect Unit) -> JSX
platformServices dp status setStatus =
  view {}
    [ pageHeader dp "Apple services" "Platform calls retain the original demos and add observable results."
    , statusPanel dp "Latest platform result" status
    , case catalogueActions of
        Left ActionSheet.MultipleCancelActions -> configurationError dp "Action sheet configuration error: multiple cancel actions."
        Right configuredActions ->
          example dp "Action sheet" "Expected: selecting or dismissing the sheet appears in the status panel."
            [ primaryButton "Show action sheet" $
                ActionSheet.showActionSheet configuredActions
                  { title: Just "Choose Action" }
                  \actionResult -> setStatus case actionResult of
                    Left ActionSheet.ActionSheetUnavailable -> "Action sheet unavailable."
                    Left ActionSheet.InvalidNativeActionResponse -> "Action sheet returned an invalid native response."
                    Right ActionSheet.DismissedActionSheet -> "Action sheet dismissed."
                    Right (ActionSheet.SelectedAction selectedAction) -> "Action sheet selected “" <> show selectedAction <> "”."
            ]
    , example dp "Haptics" "Expected: device produces the named physical feedback; status reports availability."
        [ compactButtons
            [ primaryButton "Vibrate 400ms" case vibration400ms of
                Nothing -> setStatus "Vibration configuration error: 400ms duration is invalid."
                Just duration -> do
                  Haptics.vibrate duration
                  setStatus "Dispatched 400ms vibration."
            , primaryButton "Impact light" do
                availability <- Haptics.impact Haptics.ImpactLight
                setStatus (availabilityStatus "light impact" availability)
            , primaryButton "Impact medium" do
                availability <- Haptics.impact Haptics.ImpactMedium
                setStatus (availabilityStatus "medium impact" availability)
            , primaryButton "Impact heavy" do
                availability <- Haptics.impact Haptics.ImpactHeavy
                setStatus (availabilityStatus "heavy impact" availability)
            , primaryButton "Success" do
                availability <- Haptics.notification Haptics.NotificationSuccess
                setStatus (availabilityStatus "success notification" availability)
            , primaryButton "Warning" do
                availability <- Haptics.notification Haptics.NotificationWarning
                setStatus (availabilityStatus "warning notification" availability)
            , primaryButton "Error" do
                availability <- Haptics.notification Haptics.NotificationError
                setStatus (availabilityStatus "error notification" availability)
            , primaryButton "Selection" do
                availability <- Haptics.selectionChanged
                setStatus (availabilityStatus "selection change" availability)
            , quietButton dp "Cancel vibration" do
                Haptics.cancel
                setStatus "Cancelled vibration."
            ]
        ]
    , example dp "Appearance" "Expected: reports the current native color scheme; catalogue colors remain legible."
        [ primaryButton "Read color scheme" do
            scheme <- Appearance.getColorScheme
            setStatus case scheme of
              Just Light -> "Native color scheme: light."
              Just Dark -> "Native color scheme: dark."
              Nothing -> "Native color scheme unavailable."
        ]
    , example dp "Linking" "Expected: capability and initial URL report here; opening a link preserves failure details."
        [ compactButtons
            [ primaryButton "Can open website?" do
                launchAff_ do
                  can <- LinkingIOS.canOpenURL pureScriptWebsite
                  liftEffect (setStatus ("Can open https: " <> show can <> "."))
            , primaryButton "Open PureScript.org" do
                launchAff_ do
                  opened <- attempt $ LinkingIOS.openURL pureScriptWebsite
                  case opened of
                    Left err -> liftEffect (setStatus ("Open URL failed: " <> message err))
                    Right _ -> liftEffect (setStatus "Opened https://purescript.org.")
            , primaryButton "Get initial URL" do
                launchAff_ do
                  initial <- LinkingIOS.getInitialURL
                  liftEffect $ setStatus case initial of
                    Nothing -> "Initial URL: none."
                    Just urlValue -> "Initial URL: " <> showURL urlValue
            , primaryButton "Open Settings" do
                launchAff_ do
                  opened <- attempt LinkingIOS.openSettings
                  case opened of
                    Left err -> liftEffect (setStatus ("Open Settings failed: " <> message err))
                    Right _ -> liftEffect (setStatus "Opened Settings.")
            ]
        ]
    , example dp "Safe area" "Expected: every page clears the notch, home indicator and rounded corners."
        [ result dp "Result: SafeAreaView wraps the entire catalogue and modal." ]
    ]

pageHeader :: DemoProps -> String -> String -> JSX
pageHeader dp title subtitle =
  view { style: tw "pb-4" }
    [ eyebrow dp "COMPONENT EXERCISES"
    , text { style: tw "text-2xl font-bold" <> Style.style { color: dp.fg } } title
    , text { style: tw "text-sm mt-2" <> Style.style { color: dp.dimFg, lineHeight: 20.0 } } subtitle
    ]

configurationError :: DemoProps -> String -> JSX
configurationError dp errorMessage =
  example dp "Configuration error" "This static typed configuration must be corrected before the native control can render."
    [ result dp errorMessage ]

example :: DemoProps -> String -> String -> Array JSX -> JSX
example dp title expected children =
  view { style: tw "mb-5" }
    [ text { style: tw "text-base font-semibold mb-1" <> Style.style { color: dp.fg } } title
    , text { style: tw "text-xs mb-3" <> Style.style { color: dp.dimFg, lineHeight: 17.0 } } expected
    , view { style: tw "rounded-xl p-3" <> Style.style { backgroundColor: dp.cardBg } } children
    ]

statusPanel :: DemoProps -> String -> String -> JSX
statusPanel dp title value =
  view { style: tw "rounded-xl px-4 py-3 mb-4" <> Style.style { backgroundColor: if dp.isDark then "#102A43" else "#EAF4FF" } }
    [ text { style: tw "text-xs font-semibold mb-1" <> Style.style { color: if dp.isDark then "#64D2FF" else "#0060C7" } } title
    , text { style: tw "text-sm" <> Style.style { color: dp.fg } } value
    ]

result :: DemoProps -> String -> JSX
result dp value =
  text { style: tw "text-xs mt-3" <> Style.style { color: dp.dimFg, lineHeight: 17.0 } } value

eyebrow :: DemoProps -> String -> JSX
eyebrow dp value =
  text { style: tw "text-xs font-semibold mb-2" <> Style.style { color: if dp.isDark then "#64D2FF" else "#0060C7", letterSpacing: 1.2 } } value

primaryButton :: String -> Effect Unit -> JSX
primaryButton title action =
  pressable
    { onPress: handler_ action
    , accessibilityLabel: title
    , style: tw "rounded-lg px-4 py-3 mb-2" <> Style.style { backgroundColor: "#0A84FF" }
    }
    [ text { style: tw "text-sm font-semibold text-center" <> Style.style { color: "#F9F9FB" } } title ]

quietButton :: DemoProps -> String -> Effect Unit -> JSX
quietButton dp title action =
  pressable
    { onPress: handler_ action
    , accessibilityLabel: title
    , style: tw "self-start rounded-lg px-3 py-2 mb-2" <> Style.style { backgroundColor: if dp.isDark then "#3A3A3C" else "#E5E5EA" }
    }
    [ text { style: tw "text-sm font-semibold" <> Style.style { color: dp.fg } } title ]

compactButtons :: Array JSX -> JSX
compactButtons children = view { style: tw "mb-1" } children
