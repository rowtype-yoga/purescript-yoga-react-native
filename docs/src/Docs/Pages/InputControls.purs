module Docs.Pages.InputControls where

import Deku.Core (Nut)
import Deku.DOM as D
import Docs.Components.Layout as L
import Docs.Components.PropsTable (propsTable)

page :: Nut
page =
  D.div_
    [ L.section "Input Controls" [ D.p_ [ D.text_ "Native macOS AppKit input controls." ] ]
    , button
    , switch
    , slider
    , stepper
    , checkbox
    , radioButton
    , segmented
    , popUp
    , comboBox
    , searchField
    , tokenField
    , datePicker
    , colorWell
    , helpButton
    ]

button :: Nut
button = L.componentDoc "nativeButton" "Yoga.React.Native.MacOS.Button (nativeButton)"
  """status /\ setStatus <- useState' "Ready"

nativeButton
  { title: "Say Hello"
  , bezelStyle: T.push
  , primary: true
  , onPress: setStatus "Hello from PureScript!"
  }"""
  [ propsTable
      [ { name: "title", type_: "String", description: "Button label text (mutually exclusive with sfSymbol)" }
      , { name: "sfSymbol", type_: "String", description: "SF Symbol icon (mutually exclusive with title)" }
      , { name: "bezelStyle", type_: "BezelStyle", description: "push | toolbar | texturedSquare | inline" }
      , { name: "destructive", type_: "Boolean", description: "Red destructive styling" }
      , { name: "primary", type_: "Boolean", description: "Primary action button" }
      , { name: "buttonEnabled", type_: "Boolean", description: "Enable/disable the button" }
      , { name: "onPress", type_: "Effect Unit", description: "Press callback" }
      ]
  ]

switch :: Nut
switch = L.componentDoc "nativeSwitch" "Yoga.React.Native.MacOS.Switch (nativeSwitch)"
  """on /\ setOn <- useState' false

nativeSwitch
  { on
  , onChange: setOn
  }"""
  [ propsTable
      [ { name: "on", type_: "Boolean", description: "Current on/off state" }
      , { name: "onChange", type_: "Boolean -> Effect Unit", description: "Toggle callback" }
      ]
  ]

slider :: Nut
slider = L.componentDoc "nativeSlider" "Yoga.React.Native.MacOS.Slider (nativeSlider)"
  """value /\ setValue <- useState' 50.0

nativeSlider
  { value
  , minValue: 0.0
  , maxValue: 100.0
  , numberOfTickMarks: 11
  , onChange: setValue
  }"""
  [ propsTable
      [ { name: "value", type_: "Number", description: "Current value" }
      , { name: "minValue", type_: "Number", description: "Range minimum" }
      , { name: "maxValue", type_: "Number", description: "Range maximum" }
      , { name: "numberOfTickMarks", type_: "Int", description: "Number of tick marks" }
      , { name: "allowsTickMarkValuesOnly", type_: "Boolean", description: "Snap to tick marks only" }
      , { name: "onChange", type_: "Number -> Effect Unit", description: "Value change callback" }
      ]
  ]

stepper :: Nut
stepper = L.componentDoc "nativeStepper" "Yoga.React.Native.MacOS.Stepper (nativeStepper)"
  """value /\ setValue <- useState' 5.0

nativeStepper
  { value
  , minValue: 0.0
  , maxValue: 50.0
  , increment: 1.0
  , onChange: setValue
  }"""
  [ propsTable
      [ { name: "value", type_: "Number", description: "Current value" }
      , { name: "minValue", type_: "Number", description: "Range minimum" }
      , { name: "maxValue", type_: "Number", description: "Range maximum" }
      , { name: "increment", type_: "Number", description: "Step increment" }
      , { name: "onChange", type_: "Number -> Effect Unit", description: "Value change callback" }
      ]
  ]

checkbox :: Nut
checkbox = L.componentDoc "nativeCheckbox" "Yoga.React.Native.MacOS.Checkbox (nativeCheckbox)"
  """a /\ setA <- useState' true

nativeCheckbox
  { checked: a
  , title: "Enable notifications"
  , enabled: true
  , onChange: setA
  }"""
  [ propsTable
      [ { name: "title", type_: "String", description: "Label text" }
      , { name: "checked", type_: "Boolean", description: "Checked state" }
      , { name: "enabled", type_: "Boolean", description: "Enable/disable" }
      , { name: "onChange", type_: "Boolean -> Effect Unit", description: "Toggle callback" }
      ]
  ]

radioButton :: Nut
radioButton = L.componentDoc "nativeRadioButton" "Yoga.React.Native.MacOS.RadioButton (nativeRadioButton)"
  """choice /\ setChoice <- useState' "option1"

nativeRadioButton
  { selected: choice == "option1"
  , title: "Small"
  , enabled: true
  , onChange: \_ -> setChoice "option1"
  }
nativeRadioButton
  { selected: choice == "option2"
  , title: "Medium"
  , enabled: true
  , onChange: \_ -> setChoice "option2"
  }"""
  [ propsTable
      [ { name: "title", type_: "String", description: "Label text" }
      , { name: "selected", type_: "Boolean", description: "Selection state" }
      , { name: "enabled", type_: "Boolean", description: "Enable/disable" }
      , { name: "onChange", type_: "Boolean -> Effect Unit", description: "Selection callback" }
      ]
  ]

segmented :: Nut
segmented = L.componentDoc "nativeSegmented" "Yoga.React.Native.MacOS.Segmented (nativeSegmented)"
  """mapType /\ setMapType <- useState' 0

nativeSegmented
  { labels: [ "Standard", "Satellite", "Hybrid" ]
  , selectedIndex: mapType
  , onChange: setMapType
  }"""
  [ propsTable
      [ { name: "labels", type_: "Array String", description: "Segment labels" }
      , { name: "sfSymbols", type_: "Array String", description: "SF Symbol icons per segment" }
      , { name: "selectedIndex", type_: "Int", description: "Currently selected index" }
      , { name: "onChange", type_: "Int -> Effect Unit", description: "Selection callback" }
      ]
  ]

popUp :: Nut
popUp = L.componentDoc "nativePopUp" "Yoga.React.Native.MacOS.PopUp (nativePopUp)"
  """idx /\ setIdx <- useState' 0
title /\ setTitle <- useState' "Small"
let items = [ "Small", "Medium", "Large", "Extra Large" ]

nativePopUp
  { items
  , selectedIndex: idx
  , onChange: \i -> do
      setIdx i
      setTitle (fromMaybe "" (items !! i))
  }"""
  [ propsTable
      [ { name: "items", type_: "Array String", description: "Menu items" }
      , { name: "selectedIndex", type_: "Int", description: "Selected item index" }
      , { name: "onChange", type_: "Int -> Effect Unit", description: "Selection callback" }
      ]
  ]

comboBox :: Nut
comboBox = L.componentDoc "nativeComboBox" "Yoga.React.Native.MacOS.ComboBox (nativeComboBox)"
  """txt /\ setTxt <- useState' ""
result /\ setResult <- useState' ""

nativeComboBox
  { items: [ "Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape" ]
  , text: txt
  , placeholder: "Type a fruit..."
  , onChangeText: setTxt
  , onSelectItem: \t -> do
      setTxt t
      setResult ("Selected: " <> t)
  }"""
  [ propsTable
      [ { name: "items", type_: "Array String", description: "Autocomplete suggestions" }
      , { name: "text", type_: "String", description: "Current text value" }
      , { name: "placeholder", type_: "String", description: "Placeholder text" }
      , { name: "onChangeText", type_: "String -> Effect Unit", description: "Text change callback" }
      , { name: "onSelectItem", type_: "String -> Effect Unit", description: "Item selection callback" }
      ]
  ]

searchField :: Nut
searchField = L.componentDoc "nativeSearchField" "Yoga.React.Native.MacOS.SearchField (nativeSearchField)"
  """query /\ setQuery <- useState' ""
result /\ setResult <- useState' ""

nativeSearchField
  { text: query
  , placeholder: "Search..."
  , onChangeText: setQuery
  , onSearch: \t -> setResult ("Searched: " <> t)
  }"""
  [ propsTable
      [ { name: "text", type_: "String", description: "Current search text" }
      , { name: "placeholder", type_: "String", description: "Placeholder text" }
      , { name: "onChangeText", type_: "String -> Effect Unit", description: "Text change callback" }
      , { name: "onSearch", type_: "String -> Effect Unit", description: "Search submit callback" }
      ]
  ]

tokenField :: Nut
tokenField = L.componentDoc "nativeTokenField" "Yoga.React.Native.MacOS.TokenField (nativeTokenField)"
  """tokens /\ setTokens <- useState' [ "PureScript", "React", "macOS" ]

nativeTokenField
  { tokens
  , placeholder: "Add tags..."
  , onChangeTokens: setTokens
  }"""
  [ propsTable
      [ { name: "tokens", type_: "Array String", description: "Current tokens" }
      , { name: "placeholder", type_: "String", description: "Placeholder text" }
      , { name: "onChangeTokens", type_: "Array String -> Effect Unit", description: "Tokens change callback" }
      ]
  ]

datePicker :: Nut
datePicker = L.componentDoc "nativeDatePicker" "Yoga.React.Native.MacOS.DatePicker (nativeDatePicker)"
  """dateText /\ setDateText <- useState' ""

nativeDatePicker
  { graphical: false
  , onChange: setDateText
  }"""
  [ propsTable
      [ { name: "graphical", type_: "Boolean", description: "Show graphical calendar picker" }
      , { name: "onChange", type_: "String -> Effect Unit", description: "Date change callback" }
      ]
  ]

colorWell :: Nut
colorWell = L.componentDoc "nativeColorWell" "Yoga.React.Native.MacOS.ColorWell (nativeColorWell)"
  """color /\ setColor <- useState' "#FF6600"

nativeColorWell
  { color
  , minimal: true
  , onChange: setColor
  }"""
  [ propsTable
      [ { name: "color", type_: "String", description: "Current color hex value" }
      , { name: "minimal", type_: "Boolean", description: "Minimal inline style" }
      , { name: "onChange", type_: "String -> Effect Unit", description: "Color change callback" }
      ]
  ]

helpButton :: Nut
helpButton = L.componentDoc "nativeHelpButton" "Yoga.React.Native.MacOS.HelpButton (nativeHelpButton)"
  """nativeHelpButton
  { onPress: showHelp }"""
  [ propsTable
      [ { name: "onPress", type_: "Effect Unit", description: "Press callback" }
      ]
  ]
