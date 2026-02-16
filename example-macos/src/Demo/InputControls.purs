module Demo.InputControls
  ( buttonDemo
  , switchDemo
  , sliderDemo
  , popUpDemo
  , comboBoxDemo
  , stepperDemo
  , datePickerDemo
  , colorWellDemo
  , checkboxDemo
  , radioButtonDemo
  , searchFieldDemo
  , tokenFieldDemo
  ) where

import Prelude

import Demo.Shared (DemoProps, card, desc, label, round, scrollWrap, sectionTitle)
import React.Basic (JSX)
import React.Basic.Events (handler, handler_, unsafeEventFn)
import React.Basic.Hooks (useState', (/\))
import React.Basic.Hooks as React
import Yoga.React (component)
import Yoga.React.Native (nativeEvent, text, tw, view)
import Yoga.React.Native.MacOS.Button (nativeButton)
import Yoga.React.Native.MacOS.Checkbox (nativeCheckbox)
import Yoga.React.Native.MacOS.ColorWell (nativeColorWell)
import Yoga.React.Native.MacOS.ComboBox (nativeComboBox)
import Yoga.React.Native.MacOS.DatePicker (nativeDatePicker)
import Yoga.React.Native.MacOS.Events as E
import Yoga.React.Native.MacOS.LevelIndicator (nativeLevelIndicator)
import Yoga.React.Native.MacOS.PopUp (nativePopUp)
import Yoga.React.Native.MacOS.Progress (nativeProgress)
import Yoga.React.Native.MacOS.RadioButton (nativeRadioButton)
import Yoga.React.Native.MacOS.SearchField (nativeSearchField)
import Yoga.React.Native.MacOS.Slider (nativeSlider)
import Yoga.React.Native.MacOS.Stepper (nativeStepper)
import Yoga.React.Native.MacOS.Switch (nativeSwitch)
import Yoga.React.Native.MacOS.TokenField (nativeTokenField)
import Yoga.React.Native.MacOS.Types as T
import Yoga.React.Native.Style as Style

buttonDemo :: DemoProps -> JSX
buttonDemo = component "ButtonDemo" \dp -> React.do
  status /\ setStatus <- useState' "Ready"
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Button"
      , card dp.cardBg
          [ view { style: tw "flex-row items-center" }
              [ nativeButton
                  { title: "Say Hello"
                  , bezelStyle: T.push
                  , primary: true
                  , onPress: handler_ (setStatus "Hello from PureScript!")
                  , style: Style.style { height: 24.0, width: 140.0 }
                  }
              , nativeButton
                  { title: "Reset"
                  , bezelStyle: T.push
                  , onPress: handler_ (setStatus "Ready")
                  , style: Style.style { height: 24.0, width: 100.0, marginLeft: 8.0 }
                  }
              , label dp.dimFg status
              ]
          ]
      ]

switchDemo :: DemoProps -> JSX
switchDemo = component "SwitchDemo" \dp -> React.do
  on /\ setOn <- useState' false
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Switch"
      , card dp.cardBg
          [ view { style: tw "flex-row items-center" }
              [ nativeSwitch
                  { on
                  , onChange: E.onBool "on" setOn
                  , style: Style.style { height: 24.0, width: 48.0 }
                  }
              , label dp.dimFg (if on then "On" else "Off")
              ]
          ]
      ]

sliderDemo :: DemoProps -> JSX
sliderDemo = component "SliderDemo" \dp -> React.do
  value /\ setValue <- useState' 50.0
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Slider + Level Indicator + Progress"
      , card dp.cardBg
          [ nativeSlider
              { value
              , minValue: 0.0
              , maxValue: 100.0
              , numberOfTickMarks: 11
              , onChange: E.onNumber "value" setValue
              , style: Style.style { height: 24.0 }
              }
          , label dp.dimFg ("Value: " <> show (round value) <> " / 100")
          , nativeLevelIndicator
              { value
              , minValue: 0.0
              , maxValue: 100.0
              , warningValue: 70.0
              , criticalValue: 90.0
              , style: Style.style { height: 18.0, marginTop: 8.0 }
              }
          , nativeProgress
              { value
              , style: Style.style { height: 18.0, marginTop: 8.0 }
              }
          ]
      ]

popUpDemo :: DemoProps -> JSX
popUpDemo = component "PopUpDemo" \dp -> React.do
  idx /\ setIdx <- useState' 0
  title /\ setTitle <- useState' "Small"
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Pop Up Button"
      , card dp.cardBg
          [ view { style: tw "flex-row items-center" }
              [ nativePopUp
                  { items: [ "Small", "Medium", "Large", "Extra Large" ]
                  , selectedIndex: idx
                  , onChange: handler
                      ( nativeEvent >>> unsafeEventFn \e ->
                          { idx: E.getFieldInt "selectedIndex" e, title: E.getFieldStr "title" e }
                      )
                      \r -> do
                        setIdx r.idx
                        setTitle r.title
                  , style: Style.style { height: 24.0, width: 160.0 }
                  }
              , label dp.dimFg ("Selected: " <> title)
              ]
          ]
      ]

comboBoxDemo :: DemoProps -> JSX
comboBoxDemo = component "ComboBoxDemo" \dp -> React.do
  txt /\ setTxt <- useState' ""
  result /\ setResult <- useState' ""
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Combo Box"
      , desc dp "Editable dropdown with autocomplete"
      , card dp.cardBg
          [ nativeComboBox
              { items: [ "Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape" ]
              , text: txt
              , placeholder: "Type a fruit..."
              , onChangeText: E.onString "text" setTxt
              , onSelectItem: E.onString "text" \t -> do
                  setTxt t
                  setResult ("Selected: " <> t)
              , style: Style.style { height: 28.0 } <> tw "mb-2"
              }
          , if result == "" then mempty
            else label dp.dimFg result
          ]
      ]

stepperDemo :: DemoProps -> JSX
stepperDemo = component "StepperDemo" \dp -> React.do
  value /\ setValue <- useState' 5.0
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Stepper"
      , desc dp "Up/down increment control"
      , card dp.cardBg
          [ view { style: tw "flex-row items-center" }
              [ text { style: tw "text-sm mr-3" <> Style.style { color: dp.fg } } "Quantity:"
              , nativeStepper
                  { value
                  , minValue: 0.0
                  , maxValue: 50.0
                  , increment: 1.0
                  , onChange: E.onNumber "value" setValue
                  , style: Style.style { width: 100.0, height: 24.0 }
                  }
              ]
          ]
      ]

datePickerDemo :: DemoProps -> JSX
datePickerDemo = component "DatePickerDemo" \dp -> React.do
  dateText /\ setDateText <- useState' ""
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Date Picker"
      , card dp.cardBg
          [ nativeDatePicker
              { graphical: false
              , onChange: E.onString "date" setDateText
              , style: Style.style { height: 24.0, width: 200.0 }
              }
          , if dateText == "" then mempty
            else label dp.dimFg ("Picked: " <> dateText)
          ]
      ]

colorWellDemo :: DemoProps -> JSX
colorWellDemo = component "ColorWellDemo" \dp -> React.do
  color /\ setColor <- useState' "#FF6600"
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Color Well"
      , card dp.cardBg
          [ view { style: tw "flex-row items-center" }
              [ nativeColorWell
                  { color
                  , minimal: true
                  , onChange: E.onString "color" setColor
                  , style: Style.style { height: 32.0, width: 48.0 }
                  }
              , view
                  { style: tw "ml-3 rounded" <> Style.style
                      { width: 24.0, height: 24.0, backgroundColor: color }
                  }
                  []
              , label dp.dimFg color
              ]
          ]
      ]

checkboxDemo :: DemoProps -> JSX
checkboxDemo = component "CheckboxDemo" \dp -> React.do
  a /\ setA <- useState' true
  b /\ setB <- useState' false
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Checkbox"
      , card dp.cardBg
          [ nativeCheckbox
              { checked: a
              , title: "Enable notifications"
              , enabled: true
              , onChange: E.onBool "checked" setA
              , style: Style.style { height: 24.0 } <> tw "mb-1"
              }
          , nativeCheckbox
              { checked: b
              , title: "Dark mode"
              , enabled: true
              , onChange: E.onBool "checked" setB
              , style: Style.style { height: 24.0 }
              }
          ]
      ]

radioButtonDemo :: DemoProps -> JSX
radioButtonDemo = component "RadioButtonDemo" \dp -> React.do
  choice /\ setChoice <- useState' "option1"
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Radio Button"
      , card dp.cardBg
          [ nativeRadioButton
              { selected: choice == "option1"
              , title: "Small"
              , enabled: true
              , onChange: handler_ (setChoice "option1")
              , style: Style.style { height: 24.0 } <> tw "mb-1"
              }
          , nativeRadioButton
              { selected: choice == "option2"
              , title: "Medium"
              , enabled: true
              , onChange: handler_ (setChoice "option2")
              , style: Style.style { height: 24.0 } <> tw "mb-1"
              }
          , nativeRadioButton
              { selected: choice == "option3"
              , title: "Large"
              , enabled: true
              , onChange: handler_ (setChoice "option3")
              , style: Style.style { height: 24.0 }
              }
          , label dp.dimFg ("Selected: " <> choice)
          ]
      ]

searchFieldDemo :: DemoProps -> JSX
searchFieldDemo = component "SearchFieldDemo" \dp -> React.do
  query /\ setQuery <- useState' ""
  result /\ setResult <- useState' ""
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Search Field"
      , nativeSearchField
          { text: query
          , placeholder: "Search..."
          , onChangeText: E.onString "text" setQuery
          , onSearch: E.onString "text" \t -> setResult ("Searched: " <> t)
          , style: Style.style { height: 28.0 } <> tw "mb-2"
          }
      , if result == "" then mempty
        else label dp.dimFg result
      ]

tokenFieldDemo :: DemoProps -> JSX
tokenFieldDemo = component "TokenFieldDemo" \dp -> React.do
  tokens /\ setTokens <- useState' ([ "PureScript", "React", "macOS" ] :: Array String)
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Token Field"
      , desc dp "Type text and press Enter to add tokens"
      , nativeTokenField
          { tokens
          , placeholder: "Add tags..."
          , onChangeTokens: E.onStrings "tokens" setTokens
          , style: Style.style { height: 28.0 } <> tw "mb-2"
          }
      ]
