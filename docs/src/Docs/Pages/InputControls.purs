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
  """nativeButton
  { title: "Click me"
  , bezelStyle: T.push
  , onPress: handler_ doSomething
  }"""
  [ propsTable
      [ { name: "title", type_: "String", description: "Button label text" }
      , { name: "bezelStyle", type_: "BezelStyle", description: "push | toolbar | texturedSquare | inline" }
      , { name: "destructive", type_: "Boolean", description: "Red destructive styling" }
      , { name: "primary", type_: "Boolean", description: "Primary action button" }
      , { name: "buttonEnabled", type_: "Boolean", description: "Enable/disable the button" }
      , { name: "onPress", type_: "EventHandler", description: "Press callback" }
      ]
  ]

switch :: Nut
switch = L.componentDoc "nativeSwitch" "Yoga.React.Native.MacOS.Switch (nativeSwitch)"
  """nativeSwitch
  { on: true
  , onChange: handler (syntheticEvent >>> \e -> ...)
  }"""
  [ propsTable
      [ { name: "on", type_: "Boolean", description: "Current on/off state" }
      , { name: "onChange", type_: "EventHandler", description: "Toggle callback" }
      ]
  ]

slider :: Nut
slider = L.componentDoc "nativeSlider" "Yoga.React.Native.MacOS.Slider (nativeSlider)"
  """nativeSlider
  { value: 50.0
  , minValue: 0.0
  , maxValue: 100.0
  , onChange: handler (syntheticEvent >>> \e -> ...)
  }"""
  [ propsTable
      [ { name: "value", type_: "Number", description: "Current value" }
      , { name: "minValue", type_: "Number", description: "Range minimum" }
      , { name: "maxValue", type_: "Number", description: "Range maximum" }
      , { name: "numberOfTickMarks", type_: "Int", description: "Number of tick marks" }
      , { name: "allowsTickMarkValuesOnly", type_: "Boolean", description: "Snap to tick marks only" }
      , { name: "onChange", type_: "EventHandler", description: "Value change callback" }
      ]
  ]

stepper :: Nut
stepper = L.componentDoc "nativeStepper" "Yoga.React.Native.MacOS.Stepper (nativeStepper)"
  """nativeStepper
  { value: 1.0
  , minValue: 0.0
  , maxValue: 10.0
  , increment: 1.0
  , onChange: handler (syntheticEvent >>> \e -> ...)
  }"""
  [ propsTable
      [ { name: "value", type_: "Number", description: "Current value" }
      , { name: "minValue", type_: "Number", description: "Range minimum" }
      , { name: "maxValue", type_: "Number", description: "Range maximum" }
      , { name: "increment", type_: "Number", description: "Step increment" }
      , { name: "onChange", type_: "EventHandler", description: "Value change callback" }
      ]
  ]

checkbox :: Nut
checkbox = L.componentDoc "nativeCheckbox" "Yoga.React.Native.MacOS.Checkbox (nativeCheckbox)"
  """nativeCheckbox
  { title: "Enable notifications"
  , checked: true
  , onChange: handler (syntheticEvent >>> \e -> ...)
  }"""
  [ propsTable
      [ { name: "title", type_: "String", description: "Label text" }
      , { name: "checked", type_: "Boolean", description: "Checked state" }
      , { name: "enabled", type_: "Boolean", description: "Enable/disable" }
      , { name: "onChange", type_: "EventHandler", description: "Toggle callback" }
      ]
  ]

radioButton :: Nut
radioButton = L.componentDoc "nativeRadioButton" "Yoga.React.Native.MacOS.RadioButton (nativeRadioButton)"
  """nativeRadioButton
  { title: "Option A"
  , selected: true
  , onChange: handler (syntheticEvent >>> \e -> ...)
  }"""
  [ propsTable
      [ { name: "title", type_: "String", description: "Label text" }
      , { name: "selected", type_: "Boolean", description: "Selection state" }
      , { name: "enabled", type_: "Boolean", description: "Enable/disable" }
      , { name: "onChange", type_: "EventHandler", description: "Selection callback" }
      ]
  ]

segmented :: Nut
segmented = L.componentDoc "nativeSegmented" "Yoga.React.Native.MacOS.Segmented (nativeSegmented)"
  """nativeSegmented
  { labels: ["One", "Two", "Three"]
  , sfSymbols: ["1.circle", "2.circle", "3.circle"]
  , selectedIndex: 0
  , onChange: handler (syntheticEvent >>> \e -> ...)
  }"""
  [ propsTable
      [ { name: "labels", type_: "Array String", description: "Segment labels" }
      , { name: "sfSymbols", type_: "Array String", description: "SF Symbol icons per segment" }
      , { name: "selectedIndex", type_: "Int", description: "Currently selected index" }
      , { name: "onChange", type_: "EventHandler", description: "Selection callback" }
      ]
  ]

popUp :: Nut
popUp = L.componentDoc "nativePopUp" "Yoga.React.Native.MacOS.PopUp (nativePopUp)"
  """nativePopUp
  { items: ["Small", "Medium", "Large"]
  , selectedIndex: 1
  , onChange: handler (syntheticEvent >>> \e -> ...)
  }"""
  [ propsTable
      [ { name: "items", type_: "Array String", description: "Menu items" }
      , { name: "selectedIndex", type_: "Int", description: "Selected item index" }
      , { name: "onChange", type_: "EventHandler", description: "Selection callback" }
      ]
  ]

comboBox :: Nut
comboBox = L.componentDoc "nativeComboBox" "Yoga.React.Native.MacOS.ComboBox (nativeComboBox)"
  """nativeComboBox
  { items: ["Apple", "Banana", "Cherry"]
  , text: "Apple"
  , placeholder: "Choose a fruit..."
  , onChangeText: handler (syntheticEvent >>> \e -> ...)
  , onSelectItem: handler (syntheticEvent >>> \e -> ...)
  }"""
  [ propsTable
      [ { name: "items", type_: "Array String", description: "Autocomplete suggestions" }
      , { name: "text", type_: "String", description: "Current text value" }
      , { name: "placeholder", type_: "String", description: "Placeholder text" }
      , { name: "onChangeText", type_: "EventHandler", description: "Text change callback" }
      , { name: "onSelectItem", type_: "EventHandler", description: "Item selection callback" }
      ]
  ]

searchField :: Nut
searchField = L.componentDoc "nativeSearchField" "Yoga.React.Native.MacOS.SearchField (nativeSearchField)"
  """nativeSearchField
  { placeholder: "Search..."
  , text: ""
  , onChangeText: handler (syntheticEvent >>> \e -> ...)
  , onSearch: handler (syntheticEvent >>> \e -> ...)
  }"""
  [ propsTable
      [ { name: "text", type_: "String", description: "Current search text" }
      , { name: "placeholder", type_: "String", description: "Placeholder text" }
      , { name: "onChangeText", type_: "EventHandler", description: "Text change callback" }
      , { name: "onSearch", type_: "EventHandler", description: "Search submit callback" }
      ]
  ]

tokenField :: Nut
tokenField = L.componentDoc "nativeTokenField" "Yoga.React.Native.MacOS.TokenField (nativeTokenField)"
  """nativeTokenField
  { tokens: ["tag1", "tag2"]
  , placeholder: "Add tags..."
  , onChangeTokens: handler (syntheticEvent >>> \e -> ...)
  }"""
  [ propsTable
      [ { name: "tokens", type_: "Array String", description: "Current tokens" }
      , { name: "placeholder", type_: "String", description: "Placeholder text" }
      , { name: "onChangeTokens", type_: "EventHandler", description: "Tokens change callback" }
      ]
  ]

datePicker :: Nut
datePicker = L.componentDoc "nativeDatePicker" "Yoga.React.Native.MacOS.DatePicker (nativeDatePicker)"
  """nativeDatePicker
  { graphical: true
  , onChange: handler (syntheticEvent >>> \e -> ...)
  }"""
  [ propsTable
      [ { name: "graphical", type_: "Boolean", description: "Show graphical calendar picker" }
      , { name: "onChange", type_: "EventHandler", description: "Date change callback" }
      ]
  ]

colorWell :: Nut
colorWell = L.componentDoc "nativeColorWell" "Yoga.React.Native.MacOS.ColorWell (nativeColorWell)"
  """nativeColorWell
  { color: "#ff0000"
  , minimal: true
  , onChange: handler (syntheticEvent >>> \e -> ...)
  }"""
  [ propsTable
      [ { name: "color", type_: "String", description: "Current color hex value" }
      , { name: "minimal", type_: "Boolean", description: "Minimal inline style" }
      , { name: "onChange", type_: "EventHandler", description: "Color change callback" }
      ]
  ]

helpButton :: Nut
helpButton = L.componentDoc "nativeHelpButton" "Yoga.React.Native.MacOS.HelpButton (nativeHelpButton)"
  """nativeHelpButton
  { onPress: handler_ showHelp }"""
  [ propsTable
      [ { name: "onPress", type_: "EventHandler", description: "Press callback" }
      ]
  ]
