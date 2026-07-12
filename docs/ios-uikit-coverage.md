# UIKit closed-world coverage ledger

## Scope and decision rules

**Closed world.** The source inventory is `agent://UIKitExhaustiveInventory`, based on the installed iPhoneOS 26.5 SDK. This ledger accounts for every symbol explicitly listed in inventory sections A and B, including items explicitly excluded there. Section C exclusions that name additional symbols are recorded in the final boundary table. Protocols and unnamed category examples are prerequisites, not inventory entries.

**Status values (mutually exclusive).**

- **Implemented (I):** a genuine named native class is behind a public leaf-typed PureScript API, has an observable catalogue exercise, and has runtime evidence that the named class is instantiated, obtained through its documented accessor, or attached as the named interaction or recognizer. Private implementation details do not count, except `UICollectionViewCell`, whose behavior is deliberately exercised by the public collection contract.
- **Portable substitute (P):** audit vocabulary for typed React Native or installed-package behavior that achieves a similar user outcome without a dedicated binding to the named class. P is nonterminal debt and earns zero named-class completion credit. In this revised ledger no row remains P.
- **Missing (M):** a concrete, current, user-facing SDK surface lacks the required genuine named-class typed public contract. Every M row names exactly one finite vertical slice below.
- **Deprecated/unavailable (D):** deprecated compatibility API, abstract API, private API, non-UIKit API, or replaced API that must not receive a new binding. Availability-gated current APIs remain M, not D.
- **Infrastructure-only (N):** lifecycle, hosting, model, renderer, layout, superclass, or support object with an exact recorded reason that it is not a standalone catalogue promise.

**Completion predicate.** Every concrete, current, user-facing row must be I; every N and D row must retain an exact reason; P = 0 and M = 0. Every I row must pass named native identity, public leaf-typed PureScript API, observable `Genuine UIKit` catalogue card, specified JS/native tests, simulator acceptance, required physical-device acceptance, explicit availability/capability behavior, cancellation and lifetime cleanup, and no public `Foreign` payload.

**Current architecture observed.**

- Genuine native views use an Objective-C++ `RCTViewManager` in `example-macos/ios/YogaReactExample`, a small `requireNativeComponent` JS adapter under `src/Yoga/React/Native/IOS`, and a typed `FFINativeComponent_` PureScript module beside it.
- Existing genuine catalogue surfaces are `UIDatePicker`, `UISegmentedControl`, `UISearchBar`, and `UICollectionView`; the collection internally owns `UICollectionViewCell` and `UIRefreshControl` behavior. Their native files are `IOSDatePickerManager.mm`, `IOSSegmentedControlManager.mm`, `IOSSearchBarManager.mm`, and `IOSCollectionViewManager.mm`.
- Portable RN surfaces exported from `Yoga.React.Native`, the installed native-stack (`@react-navigation/native-stack` plus `react-native-screens`), package-backed gestures, and `AppDelegate.swift`'s application `UIWindow` may remain app infrastructure or portable alternatives. Internal UIKit use by those packages is not a dedicated public typed binding to a named inventory class.
- The dedicated catalogue route is `uikitPage = "uikit"`, displayed as **UIKit widgets**, in `example-macos/src/Demo/IOSBindings.purs`. Every catalogue card must prefix its kind with **Genuine UIKit**, **Portable RN substitute**, **Compatibility only**, or **Infrastructure only**. `Portable RN substitute` is migration/comparison copy only and never evidence that an inventory row is complete.
- Shared contracts must stay leaf-typed in PureScript. Controllers expose cancellation separately from success, availability before presentation, main-thread presentation/dismissal, and retained delegates. No universal `UIKitObject` or arbitrary controller escape hatch is allowed.

## Entry-by-entry coverage

### A1. Fundamental visible views and containers

| # | Inventory entry | Status | Slice | Checkable repository disposition |
|---:|---|:---:|:---:|---|
| 001 | `UIView` | M | V41 | Dedicated genuine `UIView` host: bounded typed visual/container props, native child hosting, accessibility, controlled updates, and mount/unmount evidence. `Yoga.React.Native.View` remains a portable substitute only. |
| 002 | `UIWindow` | N | — | Owned by `AppDelegate.swift`; no catalogue constructor. |
| 003 | `UILabel` | M | V41 | Genuine `UILabel`: typed text, lines, alignment, line breaking/truncation, Dynamic Type style, accessibility, and controlled updates. RN `Text` and the private collection-cell label are portable/private current state and earn no row credit. |
| 004 | `UIImageView` | M | V41 | Genuine `UIImageView`: bounded typed image resource, content mode, load/failure or unsupported-resource result, controlled replacement, accessibility, and cleanup. RN `Image` is substitute context; `ImageBackground` is composition-only. |
| 005 | `UIStackView` | M | V41 | Genuine `UIStackView`: typed axis, alignment, distribution, spacing/margins, stable arranged-subview identity/order, insertion/removal/reordering, bounded custom spacing, and hidden-arranged-view behavior. RN/Yoga flex resemblance is portable current state, not completion. |
| 006 | `UIScrollView` | M | V41 | Genuine `UIScrollView`: bounded axis, inset, bounce, paging, indicator and keyboard policies, typed offset and drag/deceleration events, controlled scroll commands, safe-area behavior, accessibility, and delegate teardown. RN `ScrollView` remains substitute-only. |
| 007 | `UITableView` | M | V01 | Dedicated genuine table contract, not `FlatList`. |
| 008 | `UICollectionView` | I | — | `IOSCollectionViewManager.mm` + `Yoga.React.Native.IOS.CollectionView`; catalogue exercise exists. |
| 009 | `UITableViewCell` | M | V01 | Delivered with genuine table slice. |
| 010 | `UICollectionReusableView` | M | V02 | Add typed supplementary header/footer support; base inheritance alone is insufficient. |
| 011 | `UICollectionViewCell` | I | — | `IOSCollectionViewCell` exercises reuse, selection, highlight, and accessibility through collection API. |
| 012 | `UICollectionViewListCell` | M | V02 | Add list-cell appearance mode and observable accessories/configuration. |
| 013 | `UIContentUnavailableView` | M | V03 | Availability-gated empty/unavailable state. |
| 014 | `UIVisualEffectView` | M | V03 | Genuine blur/vibrancy/glass host; effects remain opaque inputs. |
| 015 | `UIBackgroundExtensionView` | M | V05 | iOS 26 availability-gated visual utility. |
| 016 | `UIInputView` | M | V04 | Genuine responder-hosted input surface; RN `InputAccessoryView` is not the same contract. |
| 017 | `UIPopoverBackgroundView` | D | — | Deprecated iOS 13 compatibility chrome; do not create a primary binding. |

### A2. Controls

| # | Inventory entry | Status | Slice | Checkable repository disposition |
|---:|---|:---:|:---:|---|
| 018 | `UIControl` | N | — | No standalone public constructor: generic target-action, event-mask, tracking, and control-state superclass with no class-specific appearance or value model. It is narrow infrastructure inside separately inventoried concrete-control managers; RN `Pressable`/`Button` are only portable action alternatives. |
| 019 | `UIButton` | M | V42 | Genuine `UIButton`: typed role/type or bounded configuration style, title/image, enabled/selected state, stable action ID/callback, Dynamic Type, accessibility, and controlled configuration updates. `Yoga.React.Native.Button` remains a portable substitute only. |
| 020 | `UICloseButton` | M | V05 | Genuine iOS 26 standard close control. |
| 021 | `UISwitch` | M | V42 | Genuine `UISwitch`: controlled `isOn`, enabled state, bounded tint styling, animated updates, value-change callback, accessibility toggle semantics, and controlled rollback. `Yoga.React.Native.Switch` remains substitute-only. |
| 022 | `UISlider` | M | V06 | No iOS typed slider export. |
| 023 | `UIStepper` | M | V06 | No iOS typed stepper export. |
| 024 | `UISegmentedControl` | I | — | Existing genuine manager, typed module, controlled selection, catalogue exercise. |
| 025 | `UIPageControl` | M | V06 | Genuine current-page control and callbacks. |
| 026 | `UIProgressView` | M | V06 | No portable progress component is exported. |
| 027 | `UIActivityIndicatorView` | M | V42 | Genuine `UIActivityIndicatorView`: typed style/color, animating state, `hidesWhenStopped`, start/stop lifecycle, availability, and accessibility. `Yoga.React.Native.ActivityIndicator` remains substitute-only. |
| 028 | `UIDatePicker` | I | — | Existing genuine manager, typed modes/value, catalogue exercise. |
| 029 | `UIPickerView` | M | V07 | Wheel picker with finite item/selection callback record. |
| 030 | `UICalendarView` | M | V08 | Calendar plus single/multi-date selection capabilities. |
| 031 | `UIColorWell` | M | V09 | Genuine color well and color-result contract. |
| 032 | `UIPasteControl` | M | V09 | Genuine paste affordance with recipient/configuration and denial path. |
| 033 | `UIPageControlTimerProgress` | M | V10 | Concrete iOS 17 timed page-progress behavior. |
| 034 | `UIPageControlProgress` | D | — | Abstract documented base; never construct or catalogue independently. |
| 035 | `UIRefreshControl` | I | — | Genuine instance owned and observably exercised by `IOSCollectionViewManager.mm`. Portable standalone `RefreshControl` also exists but does not alter I status. |

### A3. Text and search widgets

| # | Inventory entry | Status | Slice | Checkable repository disposition |
|---:|---|:---:|:---:|---|
| 036 | `UITextField` | M | V43 | Distinct genuine `UITextField`: controlled composition-safe text, placeholder, secure/keyboard/content traits, selection/focus commands, editing/change/return/clear callbacks, accessibility, and delegate teardown. RN `TextInput` single-line mode is substitute-only. |
| 037 | `UITextView` | M | V43 | Distinct genuine `UITextView`: composition-safe multiline text, editable/selectable state, text-container inset and scrolling, selection/focus, editing callbacks, Dynamic Type, and delegate teardown. RN `TextInput` multiline mode is substitute-only. |
| 038 | `UISearchBar` | I | — | Existing genuine manager, controlled text and change/submit/cancel callbacks. |
| 039 | `UITextSelectionHandleView` | M | V11 | Specialized delegate-supplied selection adornment, availability gated. |
| 040 | `UITextSelectionHighlightView` | M | V11 | Specialized delegate-supplied selection adornment, availability gated. |

### A4. Bars, tabs, and visible bar items

| # | Inventory entry | Status | Slice | Checkable repository disposition |
|---:|---|:---:|:---:|---|
| 041 | `UINavigationBar` | M | V44 | Genuine `UINavigationBar`: stable typed navigation-item stack, title/prompt, back/left/right items, bounded appearance/large-title behavior, push/pop or selected-item transitions, action/delegate events, safe-area behavior, and controlled diffing. Native-stack chrome is substitute context only. |
| 042 | `UIToolbar` | M | V12 | Genuine toolbar with typed items/actions. |
| 043 | `UITabBar` | M | V13 | Genuine legacy tab bar behavior. |
| 044 | `UIBarItem` | N | — | Borderline visible base; internal shared item descriptor only, never independently constructed. |
| 045 | `UIBarButtonItem` | M | V12 | Typed action item for navigation/toolbar hosts. |
| 046 | `UITabBarItem` | M | V13 | Typed legacy tab item. |
| 047 | `UITabAccessory` | M | V13 | iOS 18 accessory presentation. |
| 048 | `UISearchTab` | M | V13 | iOS 18 search-specialized tab. |
| 049 | `UITab` | M | V13 | iOS 18 tab/content contract. |
| 050 | `UITabGroup` | M | V13 | iOS 18 hierarchical tab group. |

### A5. General and container view controllers

| # | Inventory entry | Status | Slice | Checkable repository disposition |
|---:|---|:---:|:---:|---|
| 051 | `UIViewController` | N | — | No arbitrary public constructor: generic lifecycle, containment, presentation, trait, safe-area, and hosting base with no specialized standalone user behavior. It belongs only in F02 and concrete-controller implementations, avoiding a universal controller escape hatch; React Native screen hosts are infrastructure context. |
| 052 | `UINavigationController` | M | V44 | Genuine `UINavigationController`: stable typed child-route IDs, push/pop/pop-to/set-stack operations, navigation-item integration, visible/top route reporting, interactive-pop cancellation/result events, bounded transition/restoration policy, containment, and cleanup. Installed native-stack remains the app host but earns no row completion credit. |
| 053 | `UITabBarController` | M | V14 | No typed tabbed-screen controller contract. |
| 054 | `UISplitViewController` | M | V14 | No adaptive multi-column iOS controller contract. |
| 055 | `UIPageViewController` | M | V14 | No typed paged-child controller contract. |
| 056 | `UITableViewController` | M | V01 | Delivered with table slice. |
| 057 | `UICollectionViewController` | M | V02 | Controller-hosted collection mode, distinct from current embedded view. |
| 058 | `UIHostingController` | D | — | SwiftUI, not UIKit public inventory. |
| 059 | `UIInputViewController` | M | V04 | Extension/responder-hosted controller with explicit host capability. |

### A6. System picker/editor/presentation controllers

| # | Inventory entry | Status | Slice | Checkable repository disposition |
|---:|---|:---:|:---:|---|
| 060 | `UIAlertController` | M | V45 | Genuine `UIAlertController` presenter: typed alert/action-sheet styles, title/message, stable bounded action IDs/styles/enabled states, optional typed alert text fields, popover anchor for action sheets, and exactly-once selected/cancelled/dismissed/failure results. RN `Alert` is substitute-only. |
| 061 | `UIActivityViewController` | M | V45 | Genuine `UIActivityViewController`: bounded typed share items/resources, excluded activity types, popover anchor, invalid-input/capability failure, exactly-once activity-type/completed/cancelled/error result, and resource cleanup. Existing ActionSheet/share surfaces are portable presenter context only. |
| 062 | `UIImagePickerController` | M | V15 | Camera-only legacy media capture path; photo library must route to PHPicker. |
| 063 | `UIDocumentPickerViewController` | M | V16 | Typed import/open/export/move result with cancellation. |
| 064 | `UIDocumentViewController` | M | V16 | iOS 18 document-centric scene UI, availability gated. |
| 065 | `UICloudSharingController` | M | V17 | CloudKit prerequisites and cancellation/error result. |
| 066 | `UIColorPickerViewController` | M | V18 | Color result and continuous/final events. |
| 067 | `UIFontPickerViewController` | M | V18 | Opaque font descriptor result and cancellation. |
| 068 | `UITextFormattingViewController` | M | V19 | iOS 18 formatting coordinator/configuration bridge. |
| 069 | `UIPrintInteractionController` | M | V20 | Printable-item presenter, capability/failure/cancel result. |
| 070 | `UIReferenceLibraryViewController` | M | V20 | Availability query plus definition presentation. |
| 071 | `UIVideoEditorController` | D | — | Deprecated iOS 18 with no identical replacement; compatibility audit only. |

### A7. Presentation and menu surfaces

| # | Inventory entry | Status | Slice | Checkable repository disposition |
|---:|---|:---:|:---:|---|
| 072 | `UIPresentationController` | N | — | UIKit-created/subclassing infrastructure shared by presenter foundation. |
| 073 | `UIPopoverPresentationController` | M | V21 | Accessor-based popover configuration; never direct-init. |
| 074 | `UISheetPresentationController` | M | V46 | Present genuine content, obtain the actual `sheetPresentationController` accessor object, and expose typed detent IDs/configuration, selected detent, grabber, largest-undimmed detent, scroll expansion, edge attachment/width, bounded corner radius, adaptation/dismissal, delegate events, availability, and cleanup. RN `Modal` is substitute-only; direct initialization is not required. |
| 075 | `UISearchController` | M | V22 | Genuine search/results controller, distinct from existing search bar. |
| 076 | `UIContextMenuInteraction` | M | V23 | Typed preview/action result on attached host. |
| 077 | `UIEditMenuInteraction` | M | V23 | Typed edit-menu configuration and selected action. |
| 078 | `UIMenuController` | D | — | Deprecated iOS 16; replaced by edit-menu interaction. |
| 079 | `UILargeContentViewerInteraction` | M | V24 | Accessibility large-content HUD attached to host. |
| 080 | `UIFindInteraction` | M | V24 | Find navigator command/result contract. |
| 081 | `UITextInteraction` | M | V47 | Create genuine `UITextInteraction` in a typed mode, attach it to a genuine text host, supply the narrow delegate/text-input capability, expose selection/edit/menu behavior, and prove replace/disable/unmount detaches and releases it. RN `TextInput` behavior is substitute-only. |
| 082 | `UIDocumentBrowserViewController` | M | V25 | Document-browser app flow with lifecycle/cancellation. |

### A8. Gesture and direct interaction classes

| # | Inventory entry | Status | Slice | Checkable repository disposition |
|---:|---|:---:|:---:|---|
| 083 | `UITapGestureRecognizer` | M | V48 | Genuine attached recognizer: typed tap/touch counts, state, host-relative location, enabled/cancellation policy, bounded simultaneous/failure policy, replacement/detachment, and no post-unmount callbacks. RN `Pressable` tap behavior is substitute-only. |
| 084 | `UIPinchGestureRecognizer` | M | V26 | Dedicated typed recognizer event/state. |
| 085 | `UIRotationGestureRecognizer` | M | V26 | Dedicated typed recognizer event/state. |
| 086 | `UISwipeGestureRecognizer` | M | V26 | Dedicated typed direction/state. |
| 087 | `UIPanGestureRecognizer` | M | V48 | Genuine attached recognizer: typed state, translation, velocity, touch-count bounds, coordinate space, reset semantics, enabled/cancellation/simultaneous policy, replacement, and teardown. Gesture-handler package behavior is substitute-only. |
| 088 | `UIScreenEdgePanGestureRecognizer` | M | V26 | Edge enum plus translation/velocity/state. |
| 089 | `UILongPressGestureRecognizer` | M | V48 | Genuine attached recognizer: typed minimum duration, allowable movement, touch count, began/changed/ended/cancelled states, location, bounded cancellation/simultaneous policy, detachment, and teardown. RN `Pressable.onLongPress` is substitute-only. |
| 090 | `UIHoverGestureRecognizer` | M | V26 | Availability-gated hover location/state. |
| 091 | `UIDragGestureRecognizer` | M | V26 | iOS 18 direct drag recognizer, not drag/drop interaction. |
| 092 | `UIDragInteraction` | M | V27 | Typed drag items/session events. |
| 093 | `UIDropInteraction` | M | V27 | Typed proposal/drop result. |
| 094 | `UIPointerInteraction` | M | V28 | Pointer region/style callbacks with opaque style values. |
| 095 | `UIHoverInteraction` | M | V28 | iOS 18 hover interaction. |
| 096 | `UIBandSelectionInteraction` | M | V28 | Multi-selection band attached to supported host. |
| 097 | `UIPencilInteraction` | M | V29 | Pencil tap/squeeze event and availability. |
| 098 | `UIScribbleInteraction` | M | V29 | Scribble focus/writing callbacks. |
| 099 | `UIIndirectScribbleInteraction` | M | V29 | Indirect Scribble element/focus callbacks. |
| 100 | `UISpringLoadedInteraction` | M | V30 | Activation event attached to host. |
| 101 | `UIKeyboardMenuInteraction` | M | V30 | Keyboard menu attached to responder host. |
| 102 | `UIWindowSceneDragInteraction` | M | V30 | iOS 16 scene/window drag integration, device/iPad acceptance. |
| 103 | `UIPreviewInteraction` | D | — | Deprecated iOS 13; context-menu replacement. |

### B. First-party Apple UI-framework extensions

| # | Framework | Inventory entry | Status | Slice | Checkable repository disposition |
|---:|---|---|:---:|:---:|---|
| 104 | PhotosUI | `PHPickerViewController` | M | V31 | Modern typed photo/video picker and item-provider loading. |
| 105 | PhotosUI | `PHLivePhotoView` | M | V31 | Genuine renderer/player with playback state. |
| 106 | PhotosUI | `PHProjectExtensionController` | D | — | Deprecated iOS 18 extension-only compatibility surface. |
| 107 | PDFKit | `PDFView` | M | V32 | Genuine PDF document viewer; macOS binding does not satisfy iOS. |
| 108 | PDFKit | `PDFThumbnailView` | M | V32 | Associated thumbnail strip and selection. |
| 109 | QuickLook | `QLPreviewController` | M | V32 | Typed preview item list/index/dismissal. |
| 110 | QuickLook | `ARQuickLookPreviewItem` | N | — | Model prerequisite, not visible surface. |
| 111 | WebKit | `WKWebView` | M | V32 | Genuine web view with request/navigation events. |
| 112 | WebKit | `WKContentView` | D | — | Private/non-public API. |
| 113 | MapKit | `MKMapView` | M | V33 | Genuine map region/annotation/selection contract. |
| 114 | MapKit | `MKAnnotationView` | M | V33 | Bounded annotation-view style in map contract. |
| 115 | MapKit | `MKMarkerAnnotationView` | M | V33 | Marker appearance variant. |
| 116 | MapKit | `MKPinAnnotationView` | M | V33 | Pin appearance variant. |
| 117 | MapKit | `MKUserLocationView` | M | V33 | Availability-gated user-location appearance. |
| 118 | MapKit | `MKOverlayView` | D | — | Deprecated iOS 7; renderer replacement. |
| 119 | MapKit | `MKOverlayPathView` | D | — | Deprecated iOS 7; renderer replacement. |
| 120 | MapKit | `MKCircleView` | D | — | Deprecated iOS 7; renderer replacement. |
| 121 | MapKit | `MKPolygonView` | D | — | Deprecated iOS 7; renderer replacement. |
| 122 | MapKit | `MKPolylineView` | D | — | Deprecated iOS 7; renderer replacement. |
| 123 | MapKit | `MKCompassButton` | M | V34 | Map-associated accessory control. |
| 124 | MapKit | `MKScaleView` | M | V34 | Map-associated scale view. |
| 125 | MapKit | `MKUserTrackingButton` | M | V34 | Map-associated tracking control. |
| 126 | MapKit | `MKPitchControl` | M | V34 | iOS 17 map pitch control. |
| 127 | MapKit | `MKZoomControl` | M | V34 | iOS 17 map zoom control. |
| 128 | MapKit | `MKLookAroundViewController` | M | V34 | Scene-backed Look Around presenter. |
| 129 | MapKit | `MKMapItemDetailViewController` | M | V34 | iOS 18 map-item detail presenter. |
| 130 | MapKit | `MKSelectionAccessory` | N | — | Configuration/accessory descriptor only. |
| 131 | MapKit | `MKOverlayRenderer` | N | — | Rendering support, not independent UI. |
| 132 | MapKit | `MKOverlayPathRenderer` | N | — | Rendering support. |
| 133 | MapKit | `MKCircleRenderer` | N | — | Rendering support. |
| 134 | MapKit | `MKPolygonRenderer` | N | — | Rendering support. |
| 135 | MapKit | `MKPolylineRenderer` | N | — | Rendering support. |
| 136 | MapKit | `MKMultiPolylineRenderer` | N | — | Rendering support. |
| 137 | MapKit | `MKMultiPolygonRenderer` | N | — | Rendering support. |
| 138 | MapKit | `MKGradientPolylineRenderer` | N | — | Rendering support. |
| 139 | MapKit | `MKTileOverlayRenderer` | N | — | Rendering support. |
| 140 | SafariServices | `SFSafariViewController` | M | V35 | Genuine in-app Safari presentation and dismissal event. |
| 141 | SafariServices | `SFAuthenticationSession` | D | — | Deprecated iOS 12 and belongs to superseded authentication flow. |
| 142 | AVKit | `AVPlayerViewController` | M | V36 | Player/controller lifecycle and playback event. |
| 143 | AVKit | `AVRoutePickerView` | M | V36 | Genuine route picker. |
| 144 | AVKit | `AVPictureInPictureController` | M | V36 | PiP capability/start/stop/failure state. |
| 145 | AVKit | `AVCaptureEventInteraction` | M | V37 | Hardware capture event interaction. |
| 146 | AVKit | `AVInputPickerInteraction` | M | V37 | Input-selection UI interaction. |
| 147 | AVKit | `AVLegibleMediaOptionsMenuController` | M | V37 | iOS 26 subtitle/audio options menu. |
| 148 | VisionKit | `VNDocumentCameraViewController` | M | V38 | Document scan result/cancel/failure. |
| 149 | VisionKit | `DataScannerViewController` | M | V38 | Swift-interface-backed live data scanner. |
| 150 | VisionKit | `ImageAnalysisInteraction` | M | V39 | Analysis interaction attached to image host. |
| 151 | VisionKit | `ImageAnalysisOverlayView` | M | V39 | iOS 17 overlay view and preferred interaction types. |
| 152 | VisionKit | `ImageAnalyzer` | N | — | Analysis support object, not independent UI. |
| 153 | VisionKit | `RecognizedItem` | N | — | Result value, not UI. |
| 154 | MessageUI | `MFMailComposeViewController` | M | V40 | Capability-gated composer and typed compose result. |
| 155 | MessageUI | `MFMessageComposeViewController` | M | V40 | Capability-gated SMS/iMessage composer and typed result. |

### C. Additional explicitly named boundary entries

Rows already present above are not duplicated here: `UIMenuController`, `UIPreviewInteraction`, MapKit overlay views/renderers, `UIBarItem`, `UIPresentationController`, `UIWindow`, and framework model entries.

| # | Inventory entry | Status | Reason |
|---:|---|:---:|---|
| 156 | `UIActionSheet` | D | Deprecated/replaced by `UIAlertController`. |
| 157 | `UIAlertView` | D | Deprecated/replaced by `UIAlertController`. |
| 158 | `UISearchDisplayController` | D | Deprecated/replaced by `UISearchController`. |
| 159 | `UIPopoverController` | D | Deprecated/replaced by popover presentation. |
| 160 | `UIDocumentMenuViewController` | D | Deprecated/replaced by document picker. |
| 161 | `UIGestureRecognizer` | N | Abstract/support base; concrete recognizers are separately accounted for. |
| 162 | `UICollectionViewLayout` | N | Abstract layout support, not visible UI. |
| 163 | `UICollectionViewFlowLayout` | N | Layout support; already used privately by genuine collection. |
| 164 | `UICollectionViewCompositionalLayout` | N | Layout support, future opaque collection configuration only. |
| 165 | `UICollectionViewTransitionLayout` | N | Transition layout support. |
| 166 | `UIDynamicAnimator` and behaviors | N | Animation/physics support; no independent user-facing surface. |
| 167 | `UIForceLevelClassifier` | N | Classifier/support object, explicitly excluded from interaction inventory. |

**Boundary category disposition.** All protocols are N prerequisites represented only as narrow callback records. TextKit infrastructure, configurations/models/value resources, lifecycle objects (`UIApplication`, `UIScene`, `UIWindowScene`, sessions/delegates), feedback generators, private/SPI, and unnamed frameworks outside the approved boundary are N and cannot become catalogue rows without a new closed-world inventory. `UIControl` is N as the generic target-action/control-state superclass consumed narrowly by concrete controls: constructing the raw base yields no class-specific appearance or value semantics and is not a catalogue promise. `UIViewController` is N as the generic lifecycle, containment, presentation, trait, safe-area, and view-hosting base used by presenter/container foundations: an arbitrary public constructor would be an unsafe universal controller escape hatch, while concrete subclasses remain separately inventoried. Deprecated-only replacements are D. This prevents broad exclusion bullets from becoming accidental “other widgets” backlogs.

## Shared infrastructure contracts

These are dependencies, not catch-all implementation slices or substitutes for concrete slices. Each has an explicit done condition. F01 supplies common native view/control behavior; F02 supplies base-controller hosting without making `UIViewController` public; F03 owns recognizer/interaction attachment; F04 supplies bounded image/share resources. Using a base class inside a foundation never promotes its N row to I.

| ID | Shared native infrastructure | PureScript location | Done condition |
|---|---|---|---|
| F01 | View-manager foundation: main-queue creation, controlled props, direct event blocks, accessibility, teardown/delegate release, availability response | `Yoga.React.Native.IOS.Foundation.View` with minimal JS helper beside it | One fixture view proves prop update, event decoding, unmount release, unavailable result; all view slices reuse it. |
| F02 | Presenter foundation: locate active native-stack presenter, reject double presentation, retain delegate, distinguish success/cancel/failure/unavailable, dismiss on unmount | `Yoga.React.Native.IOS.Foundation.Presentation` | One fixture presenter proves every terminal result is emitted once and delegate/presenter references clear. |
| F03 | Interaction attachment foundation: stable host ref/tag lookup, add/remove interaction or recognizer, typed state/coordinates, availability | `Yoga.React.Native.IOS.Foundation.Interaction` | Fixture attaches, replaces, disables, unmounts, and emits no post-unmount event. |
| F04 | Opaque resource/loading foundation: security-scoped URLs, item providers, framework model handles, async cancellation, bounded byte ownership | `Yoga.React.Native.IOS.Foundation.Resource` | Fixture loads/cancels/releases a resource without exposing `Foreign` in public PureScript records. |
| F05 | Availability and capability algebra shared by all families | `Yoga.React.Native.IOS.Availability` | Public `Available a | Unavailable reason` and operation result algebras cover OS version, hardware, entitlement, extension-only, and service-disabled cases. |

## Dependency-ordered vertical slices

Every concrete non-I planning row maps to exactly one slice below: all 117 planning-state M rows map exactly once across V01–V48. “Tests” are files to add when implementing the slice; no test or command was run while producing this ledger. Unless a row says device-only, simulator acceptance is required on the newest available iPhone plus one minimum-supported runtime for the API. Every catalogue card displays availability rather than disappearing. Accessor-created sheets and host-attached text interactions/recognizers remain concrete genuine coverage obligations; direct initialization is not required when UIKit documents an accessor or attachment lifecycle.

| Order / ID | Inventory rows and finite delivered behavior | Depends on | Native implementation | PureScript module location | Catalogue location | Tests | Simulator/device acceptance |
|---|---|---|---|---|---|---|---|
| 01 / V01 | `UITableView`, `UITableViewCell`, `UITableViewController`: diffable rows/sections, stable IDs, selection, reuse, refresh, controller presentation mode | F01, F02, F05 | `IOSTableViewManager.mm`, controller presenter in `IOSSystemPresenter.mm` | `Yoga.React.Native.IOS.TableView` | UIKit widgets › Data › Genuine UIKit table | `test/IOSTableView.test.js`; native reuse/selection XCTest | Simulator: mutate sections, reuse while scrolling, select, refresh, present/dismiss controller; VoiceOver selected trait. |
| 02 / V02 | `UICollectionReusableView`, `UICollectionViewListCell`, `UICollectionViewController`: typed headers/footers, list appearance, controller host | F01, F02, F05; existing CollectionView | Extend `IOSCollectionViewManager.mm`; presenter adapter | Extend `Yoga.React.Native.IOS.CollectionView` | UIKit widgets › Data › Genuine UIKit advanced collection | `test/IOSCollectionAdvanced.test.js`; supplementary/reuse XCTest | Simulator: headers survive diff, list cell state correct, controller dismisses, existing collection contract unchanged. |
| 03 / V03 | `UIContentUnavailableView`, `UIVisualEffectView`: empty/loading/search configurations and blur/vibrancy/glass content host | F01, F05 | `IOSVisualUtilityManager.mm` | `Yoga.React.Native.IOS.ContentUnavailable`, `.VisualEffect` | UIKit widgets › Display › Genuine UIKit states & effects | `test/IOSVisualUtilities.test.js`; configuration XCTest | Simulator: switch all states/effects; iOS 26 glass gated; Reduce Transparency remains legible. |
| 04 / V04 | `UIInputView`, `UIInputViewController`: custom input surface plus responder/extension-hosted controller capability | F01, F02, F05 | `IOSInputSurfaceManager.mm`, `IOSInputControllerPresenter.mm` | `Yoga.React.Native.IOS.InputSurface` | UIKit widgets › Text › Genuine UIKit custom input | `test/IOSInputSurface.test.js`; responder lifecycle XCTest | Simulator: focus host, show/resize/dismiss input; unavailable extension mode is explicit. Device: hardware/software keyboard transition. |
| 05 / V05 | `UIBackgroundExtensionView`, `UICloseButton`: iOS 26 background extension and standard close action | F01, F05 | `IOSModernControlsManager.mm` | `Yoga.React.Native.IOS.ModernControls` | UIKit widgets › iOS 26 › Genuine UIKit modern surfaces | `test/IOSModernControls.test.js`; availability XCTest | iOS 26 simulator: background extends under bar and close emits once; older simulator shows unavailable cards. |
| 06 / V06 | `UISlider`, `UIStepper`, `UIPageControl`, `UIProgressView`: controlled values, ranges/steps/pages, continuous/final events, determinate progress | F01, F05 | `IOSScalarControlsManager.mm` | `Yoga.React.Native.IOS.ScalarControls` (leaf newtypes per control) | UIKit widgets › Controls › Genuine UIKit scalar controls | `test/IOSScalarControls.test.js`; range/clamp XCTest | Simulator: edge values, disabled state, RTL page direction, VoiceOver adjustable actions, controlled rollback. |
| 07 / V07 | `UIPickerView`: finite sections/items, selected IDs, controlled selection | F01, F05 | `IOSPickerViewManager.mm` | `Yoga.React.Native.IOS.PickerView` | UIKit widgets › Controls › Genuine UIKit wheel picker | `test/IOSPickerView.test.js`; delegate/data-source XCTest | Simulator: reload changed IDs, select each component, invalid controlled ID handled, Dynamic Type readable. |
| 08 / V08 | `UICalendarView`: visible date, selection mode, single/multiple dates, decoration request | F01, F05 | `IOSCalendarViewManager.mm` | `Yoga.React.Native.IOS.CalendarView` | UIKit widgets › Controls › Genuine UIKit calendar | `test/IOSCalendarView.test.js`; date/locale XCTest | iOS 16+ simulator: select/deselect, month navigation, locale/time-zone boundaries; older runtime unavailable. |
| 09 / V09 | `UIColorWell`, `UIPasteControl`: color change plus paste recipient/configuration/result | F01, F05 | `IOSColorWellManager.mm`, `IOSPasteControlManager.mm` | `Yoga.React.Native.IOS.ColorWell`, `.PasteControl` | UIKit widgets › Controls › Genuine UIKit color & paste | `test/IOSColorPaste.test.js`; paste-type XCTest | Simulator: choose color; paste allowed/denied/unsupported payload. Device: system paste privacy prompt and hardware clipboard. |
| 10 / V10 | `UIPageControlTimerProgress`: duration, pause/resume, preferred page callback attached to page control | V06, F05 | Extend scalar manager | `Yoga.React.Native.IOS.PageControlProgress` | UIKit widgets › Controls › Genuine UIKit timed pages | `test/IOSPageTimer.test.js`; timer lifecycle XCTest | iOS 17+ simulator: progress advances, pauses in background/unmount, changes page once; older unavailable. |
| 11 / V11 | `UITextSelectionHandleView`, `UITextSelectionHighlightView`: delegate-supplied custom adornment styles for controlled text host | F01, F03, F05 | `IOSTextSelectionManager.mm` | `Yoga.React.Native.IOS.TextSelectionAdornment` | UIKit widgets › Text › Genuine UIKit selection adornments | `test/IOSTextSelectionAdornment.test.js`; delegate lifetime XCTest | iOS 17+ simulator: select text, handles/highlight render and update; fallback unavailable on older runtime. |
| 12 / V12 | `UIToolbar`, `UIBarButtonItem`: stable typed items, system/custom images, enabled state, action IDs | F01, F05 | `IOSToolbarManager.mm` | `Yoga.React.Native.IOS.Toolbar` | UIKit widgets › Navigation › Genuine UIKit toolbar | `test/IOSToolbar.test.js`; item diff/action XCTest | Simulator: insert/remove/reorder items, disabled item silent, action ID exact, large text accessible. |
| 13 / V13 | `UITabBar`, `UITabBarItem`, `UITabAccessory`, `UISearchTab`, `UITab`, `UITabGroup`: legacy and iOS 18 tab models without conflating contracts | F01, F02, F05 | `IOSTabManager.mm`, `IOSTabControllerPresenter.mm` | `Yoga.React.Native.IOS.TabBar.Legacy`, `.TabBar.Modern` | UIKit widgets › Navigation › Genuine UIKit tabs | `test/IOSTabs.test.js`; legacy/modern availability XCTest | Simulator: legacy selection; iOS 18 group/search/accessory selection and state restoration; older runtime shows modern unavailable. |
| 14 / V14 | `UITabBarController`, `UISplitViewController`, `UIPageViewController`: typed child route IDs and container-specific events | F02, F05, V13 | `IOSContainerPresenter.mm` | `Yoga.React.Native.IOS.ContainerController` leaf modules | UIKit widgets › Navigation › Genuine UIKit containers | `test/IOSContainers.test.js`; containment/rotation XCTest | iPhone/iPad simulators: tabs, collapse/expand split, page swipes, rotation, dismiss, child identity retained. |
| 15 / V15 | `UIImagePickerController`: camera capture only, media type/result/cancel/error, explicit PHPicker guidance | F02, F04, F05 | `IOSMediaPickerPresenter.mm` | `Yoga.React.Native.IOS.LegacyMediaCapturePicker` | UIKit widgets › Pickers › Genuine UIKit camera capture (compatibility scope) | `test/IOSLegacyMediaPicker.test.js`; result decoding XCTest | Simulator: explicit no-camera unavailable. Physical device: capture/cancel/permission denial/background interruption. |
| 16 / V16 | `UIDocumentPickerViewController`, `UIDocumentViewController`: all picker modes, security-scoped result lifetime, iOS 18 document scene | F02, F04, F05 | `IOSDocumentPresenter.mm` | `Yoga.React.Native.IOS.DocumentPicker`, `.DocumentViewController` | UIKit widgets › Documents › Genuine UIKit document UI | `test/IOSDocumentUI.test.js`; URL lifetime XCTest | Simulator/device: import/open/export/move, cancel, unavailable document scene, open sample file and release scope. |
| 17 / V17 | `UICloudSharingController`: existing/new CKShare inputs, save/stop/cancel/failure | F02, F04, F05 | `IOSCloudSharePresenter.mm` | `Yoga.React.Native.IOS.CloudSharing` | UIKit widgets › Documents › Genuine UIKit Cloud sharing | `test/IOSCloudSharing.test.js`; delegate terminal-state XCTest | Simulator: no-account/unavailable and cancel. Signed device with CloudKit fixture: save and stop sharing. |
| 18 / V18 | `UIColorPickerViewController`, `UIFontPickerViewController`: initial/config values, continuous/final selection, cancel | F02, F04, F05 | `IOSStylePickerPresenter.mm` | `Yoga.React.Native.IOS.ColorPicker`, `.FontPicker` | UIKit widgets › Pickers › Genuine UIKit style pickers | `test/IOSStylePickers.test.js`; result conversion XCTest | Simulator: choose/cancel color and font, controlled initial values, Dynamic Type; availability cards on old runtime. |
| 19 / V19 | `UITextFormattingViewController`: formatting configuration/coordinator, applied attributes, cancel/dismiss | F02, F04, F05 | `IOSTextFormattingPresenter.mm` | `Yoga.React.Native.IOS.TextFormatting` | UIKit widgets › Text › Genuine UIKit formatting | `test/IOSTextFormatting.test.js`; coordinator lifetime XCTest | iOS 18+ iPad/iPhone simulator: apply formatting and dismiss; old runtime unavailable. |
| 20 / V20 | `UIPrintInteractionController`, `UIReferenceLibraryViewController`: printable item workflow and term-definition presentation | F02, F04, F05 | `IOSUtilityPresenter.mm` | `Yoga.React.Native.IOS.Print`, `.ReferenceLibrary` | UIKit widgets › System UI › Genuine UIKit print & definition | `test/IOSUtilityPresenters.test.js`; capability/result XCTest | Simulator: definition available/unavailable, print UI/cancel where supported. Device: AirPrint-capability path without requiring actual print completion. |
| 21 / V21 | `UIPopoverPresentationController`: source rect/item, arrows, adaptive result, outside-tap dismissal | F02, F05, V12 | `IOSPopoverPresenter.mm` | `Yoga.React.Native.IOS.Popover` | UIKit widgets › Presentation › Genuine UIKit popover | `test/IOSPopover.test.js`; accessor/config XCTest | iPad simulator: anchored popover; iPhone adaptive presentation; rotation/reanchor/dismiss and invalid-anchor failure. |
| 22 / V22 | `UISearchController`: controlled query, active state, result IDs, submit/cancel, presentation-context cleanup | F01, F02, F05 | `IOSSearchControllerManager.mm` | `Yoga.React.Native.IOS.SearchController` | UIKit widgets › Text › Genuine UIKit search controller | `test/IOSSearchController.test.js`; delegate lifetime XCTest | Simulator: type/filter/select/cancel, rotate while active, unmount restores presentation context. |
| 23 / V23 | `UIContextMenuInteraction`, `UIEditMenuInteraction`: bounded menu/action tree, preview metadata, action/cancel events | F03, F05 | `IOSMenuInteractionManager.mm` | `Yoga.React.Native.IOS.MenuInteraction` | UIKit widgets › Interactions › Genuine UIKit menus | `test/IOSMenuInteractions.test.js`; attach/action XCTest | Simulator: long-press context menu and edit menu, choose/cancel, disabled actions, unmount. Physical device validates pointer preview. |
| 24 / V24 | `UILargeContentViewerInteraction`, `UIFindInteraction`: large-content accessibility HUD and find navigator query/results | F03, F05 | `IOSAssistiveInteractionManager.mm` | `Yoga.React.Native.IOS.AssistiveInteraction` | UIKit widgets › Accessibility › Genuine UIKit large content & find | `test/IOSAssistiveInteractions.test.js`; command/state XCTest | Simulator: accessibility text sizes reveal HUD; hardware keyboard invokes find and cycles results. Device: long-press large-content behavior. |
| 25 / V25 | `UIDocumentBrowserViewController`: create/import/open/move document browser lifecycle | F02, F04, F05, V16 | `IOSDocumentBrowserPresenter.mm` | `Yoga.React.Native.IOS.DocumentBrowser` | UIKit widgets › Documents › Genuine UIKit browser | `test/IOSDocumentBrowser.test.js`; lifecycle XCTest | Simulator/device: browse/open/create/cancel; iCloud disabled state explicit; security scope released. |
| 26 / V26 | `UIPinchGestureRecognizer`, `UIRotationGestureRecognizer`, `UISwipeGestureRecognizer`, `UIScreenEdgePanGestureRecognizer`, `UIHoverGestureRecognizer`, `UIDragGestureRecognizer`: one bounded recognizer manager with distinct typed event payloads | F03, F05 | `IOSGestureRecognizerManager.mm` | `Yoga.React.Native.IOS.Gesture` leaf recognizer modules | UIKit widgets › Gestures › Genuine UIKit recognizers | `test/IOSGestureRecognizers.test.js`; state/payload XCTest | Simulator: pinch/rotate/swipe/edge/hover/drag transitions and simultaneous-policy fixture. Physical pointer/device verifies hover/drag. |
| 27 / V27 | `UIDragInteraction`, `UIDropInteraction`: local typed payload IDs, proposals, enter/update/exit/drop, cancellation | F03, F04, F05 | `IOSDragDropInteractionManager.mm` | `Yoga.React.Native.IOS.DragDrop` | UIKit widgets › Interactions › Genuine UIKit drag & drop | `test/IOSDragDrop.test.js`; session/proposal XCTest | iPad simulator/device: reorder/local transfer, reject type, cancel, cross-app item-provider load and cleanup. |
| 28 / V28 | `UIPointerInteraction`, `UIHoverInteraction`, `UIBandSelectionInteraction`: pointer region/style capability, hover phase, band-selected stable IDs | F03, F05 | `IOSPointerInteractionManager.mm` | `Yoga.React.Native.IOS.PointerInteraction` | UIKit widgets › Interactions › Genuine UIKit pointer & selection | `test/IOSPointerInteractions.test.js`; region/selection XCTest | iPad simulator with pointer: hover/style and band selection; iOS 18 hover interaction gated; physical trackpad acceptance. |
| 29 / V29 | `UIPencilInteraction`, `UIScribbleInteraction`, `UIIndirectScribbleInteraction`: pencil action plus direct/indirect Scribble element/focus contracts | F03, F05 | `IOSPencilInteractionManager.mm` | `Yoga.React.Native.IOS.PencilInteraction` | UIKit widgets › Interactions › Genuine UIKit Pencil & Scribble | `test/IOSPencilInteractions.test.js`; delegate lifetime XCTest | Simulator shows explicit unsupported capability. Physical iPad + Pencil: tap/squeeze where available, Scribble focus and indirect element selection. |
| 30 / V30 | `UISpringLoadedInteraction`, `UIKeyboardMenuInteraction`, `UIWindowSceneDragInteraction`: activation/menu/scene-drag event contracts | F03, F05 | `IOSSystemInteractionManager.mm` | `Yoga.React.Native.IOS.SystemInteraction` | UIKit widgets › Interactions › Genuine UIKit system interactions | `test/IOSSystemInteractions.test.js`; availability/action XCTest | iPad simulator/device: spring-load activation, keyboard menu selection, scene drag on supported multitasking environment; unsupported states explicit. |
| 31 / V31 | `PHPickerViewController`, `PHLivePhotoView`: typed selection limit/filter/results/resource loading and live-photo playback | F01, F02, F04, F05 | `IOSPhotosUIPresenter.mm`, `IOSLivePhotoViewManager.mm` | `Yoga.React.Native.IOS.PhotosPicker`, `.LivePhotoView` | UIKit widgets › Photos › Genuine PhotosUI | `test/IOSPhotosUI.test.js`; item-provider/playback XCTest | Simulator/device: select multiple/cancel/limited library/load failure; live photo play/stop. Device validates real library and memory release. |
| 32 / V32 | `PDFView`, `PDFThumbnailView`, `QLPreviewController`, `WKWebView`: bounded document/web package with shared URL resource contract, but separate leaf APIs | F01, F02, F04, F05 | `IOSDocumentViewManagers.mm`, `IOSQuickLookPresenter.mm`, `IOSWebViewManager.mm` | `Yoga.React.Native.IOS.PDFView`, `.QuickLook`, `.WebView` | UIKit widgets › Documents & Web › Genuine Apple framework views | `test/IOSDocumentViews.test.js`, `test/IOSWebView.test.js`; navigation/document XCTest | Simulator: PDF page/thumbnail sync, QL index/dismiss, WK load/back/error/cancel and blocked scheme; offline fixture only. |
| 33 / V33 | `MKMapView`, four annotation views: controlled region, stable annotations, selection, user-location state, explicit annotation style sum type | F01, F04, F05 | `IOSMapViewManager.mm` | `Yoga.React.Native.IOS.MapView` | UIKit widgets › Maps › Genuine MapKit map | `test/IOSMapView.test.js`; annotation reuse/region XCTest | Simulator: pan/zoom/select all four styles, location denied/authorized, controlled region rollback. Device validates GPS update. |
| 34 / V34 | Five map controls plus `MKLookAroundViewController` and `MKMapItemDetailViewController`: associated map controls and two finite presenters | F01, F02, F04, F05, V33 | `IOSMapAccessoryManager.mm`, `IOSMapPresenter.mm` | `Yoga.React.Native.IOS.MapAccessories`, `.MapPresenters` | UIKit widgets › Maps › Genuine MapKit accessories | `test/IOSMapAccessories.test.js`; association/presenter XCTest | Simulator: control association/actions; Look Around available/unavailable; iOS 18 detail present/dismiss; device validates user tracking. |
| 35 / V35 | `SFSafariViewController`: URL/config, initial load, completion/dismiss and invalid URL result | F02, F05 | `IOSSafariPresenter.mm` | `Yoga.React.Native.IOS.Safari` | UIKit widgets › Web › Genuine SafariServices | `test/IOSSafari.test.js`; presenter XCTest | Simulator/device: open local HTTPS fixture, Done and swipe dismiss, invalid URL, no duplicate callback. |
| 36 / V36 | `AVPlayerViewController`, `AVRoutePickerView`, `AVPictureInPictureController`: URL-backed player, route UI, PiP capability/state | F01, F02, F04, F05 | `IOSAVPlayerPresenter.mm`, `IOSRoutePickerManager.mm`, `IOSPictureInPictureModule.mm` | `Yoga.React.Native.IOS.Player`, `.RoutePicker`, `.PictureInPicture` | UIKit widgets › Media › Genuine AVKit playback | `test/IOSAVPlayback.test.js`; state/lifetime XCTest | Simulator: local media play/pause/end, route picker opens, PiP unsupported state. Device: AirPlay route and PiP start/stop/background restore. |
| 37 / V37 | `AVCaptureEventInteraction`, `AVInputPickerInteraction`, `AVLegibleMediaOptionsMenuController`: capture event, input picker, iOS 26 legible options | F03, F04, F05, V36 | `IOSAVInteractionManager.mm` | `Yoga.React.Native.IOS.AVInteraction` | UIKit widgets › Media › Genuine AVKit interactions | `test/IOSAVInteractions.test.js`; capability/action XCTest | Simulator shows capability states and iOS 26 menu with fixture tracks. Device: volume/capture hardware event and input route selection. |
| 38 / V38 | `VNDocumentCameraViewController`, `DataScannerViewController`: scan/cancel/failure plus recognized-item add/update/remove events | F02, F04, F05 | Swift `IOSVisionScannerModule.swift` with ObjC bridge | `Yoga.React.Native.IOS.VisionScanner` | UIKit widgets › Vision › Genuine VisionKit scanners | `test/IOSVisionScanners.test.js`; Swift result/lifetime XCTest | Simulator explicit camera unsupported. Device: permission denial, document pages, live recognized items, interruption/resume, cancel. |
| 39 / V39 | `ImageAnalysisInteraction`, `ImageAnalysisOverlayView`: analyze image resource then expose live-text/data-detector interaction overlay | F01, F03, F04, F05 | Swift `IOSImageAnalysisManager.swift` with ObjC bridge | `Yoga.React.Native.IOS.ImageAnalysis` | UIKit widgets › Vision › Genuine VisionKit analysis | `test/IOSImageAnalysis.test.js`; analysis cancellation XCTest | iOS 16/17+ simulator/device: analyze fixture, select/copy text, update image cancels old work, overlay gated on iOS 17. |
| 40 / V40 | `MFMailComposeViewController`, `MFMessageComposeViewController`: typed recipients/body/attachments and sent/saved/cancelled/failed result | F02, F04, F05 | `IOSMessageComposerPresenter.mm` | `Yoga.React.Native.IOS.MailComposer`, `.MessageComposer` | UIKit widgets › Communication › Genuine MessageUI composers | `test/IOSMessageComposer.test.js`; capability/result XCTest | Simulator: cannot-send states explicit. Configured device: present/cancel mail and message, attachment lifetime, exactly one terminal callback. |
| 41 / V41 | `UIView`, `UILabel`, `UIImageView`, `UIStackView`, `UIScrollView`: dedicated genuine hosts with bounded typed visual/container props; native child hosting; label text/layout/Dynamic Type; bounded image resources/content mode/results; stable arranged-subview identity/order/diffs; scroll policies, offset commands, drag/deceleration events, accessibility, and teardown | F01, F04, F05 | `IOSCoreViewsManager.mm` with separate exported managers/components and runtime class-identity assertions; F04 handles bounded image resources | Leaf modules `Yoga.React.Native.IOS.View`, `.Label`, `.ImageView`, `.StackView`, `.ScrollView`; no universal UIKit object or shared `Foreign` props | UIKit widgets › Display & Layout › Genuine UIKit core views; one observable exercise per named class | `test/IOSCoreViews.test.js`; native class identity, arranged-subview diffing, scroll delegate/lifetime, and image-resource XCTest | Simulator: update visual props, Dynamic Type/RTL label, replace image including failure, insert/remove/reorder/hide arranged views, scroll/drag/decelerate and controlled-offset rollback, accessibility and no post-unmount events. Minimum-supported and newest runtime; device only if selected image source requires it. |
| 42 / V42 | `UIButton`, `UISwitch`, `UIActivityIndicatorView`: button role/configuration/title/image/action and controlled states; switch controlled value/tint/animation/rollback; indicator style/color/animating/`hidesWhenStopped`; accessibility and lifecycle | F01, F05, V41 | `IOSBasicControlsManager.mm`; base `UIControl` remains private infrastructure, not a fourth exported component | Leaf modules `Yoga.React.Native.IOS.Button`, `.Switch`, `.ActivityIndicator`, with control-specific newtypes and event records | UIKit widgets › Controls › Genuine UIKit basic controls | `test/IOSBasicControls.test.js`; native target-action, controlled-state rollback, event-cardinality, and teardown XCTest | Simulator: press enabled/disabled/selected variants, toggle and externally roll back switch, start/stop indicator, Dynamic Type, relevant RTL, VoiceOver names/traits, controlled updates, and cleanup. |
| 43 / V43 | `UITextField`, `UITextView`: distinct genuine classes with composition-safe controlled text, selection/focus, keyboard/content traits, editing callbacks; field placeholder/secure/return/clear; view multiline container inset/scrolling/editability; Dynamic Type, accessibility, delegate teardown | F01, F05, V41 | `IOSTextInputManagers.mm` with separate `UITextField` and `UITextView` managers/delegates; no mode switch pretending one class covers both | `Yoga.React.Native.IOS.TextField` and `.TextView`, sharing only leaf value types where genuinely identical | UIKit widgets › Text › Genuine UIKit text field and text view; separate exercises and class labels | `test/IOSNativeTextInputs.test.js`; composition-safe update, selection, return, multiline, focus, and delegate-release XCTest | Simulator: focus/blur, marked/composed text, update/rollback, selection, clear/return, multiline insert/scroll, secure entry, keyboard traits, Dynamic Type, accessibility. Device: hardware/software keyboard transition and real IME composition. |
| 44 / V44 | `UINavigationBar`, `UINavigationController`: stable typed navigation-item and child-route stacks; titles/items/appearance/large titles; push/pop/pop-to/set-stack; actions/delegate events; visible/top route; interactive-pop cancellation/results; bounded transition/restoration, containment, safe area, and cleanup | F01, F02, F05, V12 | `IOSNavigationManager.mm` for bar hosting and `IOSNavigationControllerPresenter.mm` for genuine stack containment/presentation; coexist with native-stack without claiming it as the binding | `Yoga.React.Native.IOS.NavigationBar` and `.NavigationController`; stable item/route IDs and finite operations, never arbitrary `UIViewController` handles | UIKit widgets › Navigation › Genuine UIKit navigation bar and controller | `test/IOSNavigationPrimitives.test.js`; item-stack diff, containment, transition, interactive-pop cancellation, delegate lifetime, and class-identity XCTest | iPhone/iPad simulators: item diffs/actions, push/pop/pop-to/set stack, operations during transitions, cancel/complete interactive pop, rotation, top/visible IDs, retention, Dynamic Type/VoiceOver, dismiss/unmount. Existing native-stack app routes remain unchanged. |
| 45 / V45 | `UIAlertController`, `UIActivityViewController`: typed alert/action-sheet content/actions/text fields and bounded share items/resources/exclusions; required popover anchors; typed invalid-input/capability/presenter-busy failures; exactly-once action/activity, cancellation, dismissal, completion, and error results; cleanup | F02, F04, F05 | Extend `IOSSystemPresenter.mm` or focused `IOSAlertPresenter.mm` and `IOSActivityPresenter.mm`, reusing the single presenter-foundation convention | `Yoga.React.Native.IOS.AlertController` and `.ActivityViewController`; explicit success/action, cancellation, failure, unavailable, and presenter-busy results | UIKit widgets › System UI › Genuine UIKit alerts & sharing | `test/IOSSystemPresenters.test.js`; action/result decoding, anchor validation, double-presentation rejection, terminal-callback cardinality, resource/delegate cleanup XCTest | iPhone/iPad simulators: alert action/cancel/text value, anchored/adaptive action sheet, share text/file and choose/cancel where available, invalid anchor/resource, double presentation, swipe/dismiss/unmount with one result. Device: real share target/resource handoff and cleanup. |
| 46 / V46 | `UISheetPresentationController`: present genuine content, configure the accessor-returned sheet with typed detent IDs/configuration and selection, grabber, largest-undimmed detent, scroll expansion, edge attachment/width, bounded corner radius, adaptation/dismissal, events, availability, and cleanup | F02, F05 | `IOSSheetPresenter.mm`: present through F02 and configure the accessor-returned `UISheetPresentationController`; never attempt direct construction | `Yoga.React.Native.IOS.SheetPresentation` with opaque/leaf detent identifiers and typed configuration/events | UIKit widgets › Presentation › Genuine UIKit sheet presentation | `test/IOSSheetPresentation.test.js`; accessor identity, detent conversion/selection, delegate event, adaptation, dismissal, and release XCTest | Supported iPhone/iPad simulators: medium/large and bounded custom detents, programmatic/interactive selection, grabber/dimming/edge attachment/scroll expansion, rotation/adaptation/dismissal, double-presentation rejection; older runtimes show unavailable properties without hiding card. |
| 47 / V47 | `UITextInteraction`: create genuine interaction in a typed mode, attach to a genuine text host with narrow delegate/text-input capability, expose selection/edit/menu behavior, and deterministic replace/disable/detach/release | F03, F05, V43 | `IOSTextInteractionManager.mm`: attach to V43 native text-host fixture, retain narrow delegate, replace/remove deterministically | `Yoga.React.Native.IOS.TextInteraction` with typed mode, attachment token/ref discipline, enabled state, and bounded events; no arbitrary interaction object | UIKit widgets › Text › Genuine UIKit text interaction | `test/IOSTextInteraction.test.js`; mode/attachment, replacement, first-responder behavior, delegate lifetime, and no-post-unmount-event XCTest | Simulator: attach to field/view, focus/select/edit, invoke menu behavior, replace mode/host, disable, unmount/remount, no duplicate interaction or stale callback. Device: real touch selection/menu behavior. |
| 48 / V48 | `UITapGestureRecognizer`, `UIPanGestureRecognizer`, `UILongPressGestureRecognizer`: distinct genuine attached recognizers with typed class-specific configuration/payloads, state/location; tap/touch counts; pan translation/velocity/reset; long-press duration/movement/full state sequence; bounded enabled/cancellation/simultaneous/failure policies, replacement, and teardown | F03, F05 | Extend `IOSGestureRecognizerManager.mm` from V26 with three distinct genuine constructors/event encoders; never route through Pressable or gesture-handler | Leaf modules under `Yoga.React.Native.IOS.Gesture` for tap, pan, and long press, with distinct payloads and only shared state/coordinate newtypes | UIKit widgets › Gestures › Genuine UIKit basic recognizers | `test/IOSBasicGestureRecognizers.test.js`; class identity, state sequence, coordinate/velocity conversion, failure/simultaneous policy, replacement, and teardown XCTest | Simulator: tap counts, pan translation/velocity/cancellation, long-press timing/movement/states, disable/replace, simultaneous/failure fixture, unmount while active, no stale events. Device: real multi-touch/timing where simulator input is insufficient. |

## Completion gates and counts

The same completion gate applies to former-portable and originally-missing rows. A slice is complete only when every named symbol in its row has: runtime proof of the named native implementation, documented accessor identity, or attachment identity; public leaf-typed PureScript API; observable catalogue card labelled **Genuine UIKit**; specified JS and native tests; simulator acceptance; required physical-device acceptance; explicit availability/capability behavior; cancellation and lifetime cleanup; and no public `Foreign` payload. Foundations F01–F05 are introduced before their first consumers but earn no concrete-row credit.

No concrete row may finish as P. Portable substitutes may remain documented as migration/comparison current state, but contribute zero completion credit. Completing V01–V48 takes every planning-state M row to I; D and N remain intentionally outside standalone binding scope for their exact recorded reasons.

**Planning-state totals: 167 explicit inventory/boundary rows = I 6 + P 0 + M 117 + D 19 + N 25.** All 117 missing rows map exactly once across **48 finite vertical slices**. The original 98 M mappings remain unchanged in V01–V40; the 19 newly recognized genuine named-class gaps occupy V41–V48 with cardinalities `[5, 3, 2, 2, 2, 1, 1, 3]`. There is no “other widgets,” “miscellaneous,” vague catch-all, or unnamed slice.

**Terminal totals after all 48 slices: I 123 + P 0 + M 0 + D 19 + N 25 = 167.** This is the post-delivery target, not the current implementation state: I 123 = current I 6 + all 117 delivered M rows.
