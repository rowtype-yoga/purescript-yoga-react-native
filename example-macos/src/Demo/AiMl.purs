module Demo.AiMl
  ( ocrDemo
  , speechRecognitionDemo
  , naturalLanguageDemo
  , cameraDemo
  ) where

import Prelude

import Data.Foldable (for_)
import Data.String (joinWith)
import Demo.Shared (DemoProps, desc, scrollWrap, sectionTitle)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import React.Basic (JSX)
import React.Basic.Events (handler, handler_, unsafeEventFn)
import React.Basic.Hooks (useState', (/\))
import React.Basic.Hooks as React
import Yoga.React (component)
import Yoga.React.Native (nativeEvent, text, tw, view)
import Yoga.React.Native.MacOS.Button (nativeButton)
import Yoga.React.Native.MacOS.CameraView (nativeCameraView)
import Yoga.React.Native.MacOS.Events as E
import Yoga.React.Native.MacOS.FilePicker (nativeFilePicker)
import Yoga.React.Native.MacOS.NaturalLanguage (analyzeSentiment, detectLanguage, tokenize)
import Yoga.React.Native.MacOS.OCR (recognizeText)
import Yoga.React.Native.MacOS.SpeechRecognition (useSpeechRecognition)
import Yoga.React.Native.MacOS.TextField (nativeTextField)
import Yoga.React.Native.MacOS.Types as T
import Yoga.React.Native.Style as Style

ocrDemo :: DemoProps -> JSX
ocrDemo = component "OCRDemo" \dp -> React.do
  result /\ setResult <- useState' ""
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "OCR (Vision)"
      , desc dp "Recognize text in images (VNRecognizeTextRequest)"
      , view { style: tw "flex-row items-center mb-2" }
          [ nativeFilePicker
              { mode: T.openFile
              , allowedTypes: [ "public.image" ]
              , title: "Pick Image"
              , sfSymbol: "photo"
              , onPickFiles: handler
                  (nativeEvent >>> unsafeEventFn \e -> E.getFieldArray "files" e)
                  \paths -> for_ paths \path -> do
                    setResult "Recognizing..."
                    launchAff_ do
                      r <- recognizeText path
                      liftEffect (setResult r)
              , style: Style.style { height: 24.0, width: 140.0 }
              }
          ]
      , if result /= "" then view { style: tw "p-2 rounded mb-4" <> Style.style { backgroundColor: dp.cardBg } }
          [ text { style: tw "text-xs font-mono" <> Style.style { color: dp.fg } } result ]
        else mempty
      ]

speechRecognitionDemo :: DemoProps -> JSX
speechRecognitionDemo = component "SpeechRecognitionDemo" \dp -> React.do
  speech <- useSpeechRecognition
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Speech Recognition"
      , desc dp "Live microphone-to-text (click Start, speak, click Stop)"
      , view { style: tw "flex-row items-center mb-2" }
          [ nativeButton
              { title: if speech.listening then "Listening..." else "Start"
              , bezelStyle: T.push
              , onPress: handler_ speech.start
              , style: Style.style { height: 24.0, width: 130.0 }
              }
          , nativeButton
              { title: "Stop"
              , bezelStyle: T.push
              , onPress: handler_ speech.stop
              , style: Style.style { height: 24.0, width: 80.0, marginLeft: 8.0 }
              }
          ]
      , if speech.transcript /= "" then view { style: tw "p-2 rounded mb-4" <> Style.style { backgroundColor: dp.cardBg } }
          [ text { style: tw "text-xs font-mono" <> Style.style { color: dp.fg } } speech.transcript ]
        else mempty
      ]

naturalLanguageDemo :: DemoProps -> JSX
naturalLanguageDemo = component "NaturalLanguageDemo" \dp -> React.do
  txt /\ setTxt <- useState' "I love this amazing app! C'est magnifique."
  result /\ setResult <- useState' ""
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Natural Language"
      , desc dp "Language detection, sentiment, tokenization (NaturalLanguage.framework)"
      , nativeTextField
          { text: txt
          , placeholder: "Enter text to analyze..."
          , onChangeText: setTxt
          , style: Style.style { height: 24.0 } <> tw "mb-2"
          }
      , view { style: tw "flex-row items-center mb-2" }
          [ nativeButton
              { title: "Language"
              , bezelStyle: T.push
              , onPress: handler_ $ launchAff_ do
                  lang <- detectLanguage txt
                  liftEffect (setResult ("Language: " <> lang))
              , style: Style.style { height: 24.0, width: 110.0 }
              }
          , nativeButton
              { title: "Sentiment"
              , bezelStyle: T.push
              , onPress: handler_ $ launchAff_ do
                  score <- analyzeSentiment txt
                  liftEffect (setResult ("Sentiment: " <> show score))
              , style: Style.style { height: 24.0, width: 110.0, marginLeft: 8.0 }
              }
          , nativeButton
              { title: "Tokenize"
              , bezelStyle: T.push
              , onPress: handler_ $ launchAff_ do
                  tokens <- tokenize txt
                  liftEffect (setResult ("Tokens: " <> joinWith ", " tokens))
              , style: Style.style { height: 24.0, width: 110.0, marginLeft: 8.0 }
              }
          ]
      , if result /= "" then view { style: tw "p-2 rounded mb-4" <> Style.style { backgroundColor: dp.cardBg } }
          [ text { style: tw "text-xs font-mono" <> Style.style { color: dp.fg } } result ]
        else mempty
      ]

cameraDemo :: DemoProps -> JSX
cameraDemo = component "CameraDemo" \dp -> React.do
  on /\ setOn <- useState' false
  pure do
    view { style: tw "flex-1" }
      [ view { style: tw "flex-row items-center px-3 py-2" <> Style.style { backgroundColor: "transparent" } }
          [ text { style: tw "text-sm font-semibold mr-3" <> Style.style { color: dp.fg } } "Camera"
          , nativeButton
              { title: if on then "Stop" else "Start"
              , bezelStyle: T.push
              , onPress: handler_ (setOn (not on))
              , style: Style.style { height: 24.0, width: 100.0 }
              }
          ]
      , if on then nativeCameraView
          { active: true
          , style: tw "flex-1"
          }
        else view { style: tw "flex-1 items-center justify-center" }
          [ text { style: tw "text-sm" <> Style.style { color: dp.dimFg } } "Press Start to activate camera" ]
      ]
