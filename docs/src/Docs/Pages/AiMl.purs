module Docs.Pages.AiMl where

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Attributes as DA
import Docs.Components.Layout as L
import Docs.Components.PropsTable (propsTable)

page :: Nut
page =
  D.div_
    [ L.section "AI & ML" [ D.p_ [ D.text_ "On-device machine learning powered by Apple's native frameworks." ] ]
    , ocr
    , speechRecognition
    , languageDetection
    , sentimentAnalysis
    , tokenization
    ]

ocr :: Nut
ocr = L.componentDoc "recognizeText" "Yoga.React.Native.MacOS.OCR (recognizeText)"
  """-- Aff-based, returns recognized text
result <- recognizeText "/path/to/image.png" # liftAff"""
  [ D.p [ DA.klass_ "text-sm text-gray-400 mt-2" ]
      [ D.text_ "Signature: String -> Aff String" ]
  , D.p [ DA.klass_ "text-sm text-gray-400" ]
      [ D.text_ "Uses Apple Vision framework for optical character recognition." ]
  ]

speechRecognition :: Nut
speechRecognition = L.componentDoc "useSpeechRecognition" "Yoga.React.Native.MacOS.SpeechRecognition (useSpeechRecognition)"
  """-- React hook for live speech-to-text
{ listening, transcript, start, stop } <- useSpeechRecognition"""
  [ D.p [ DA.klass_ "text-sm text-gray-400 mt-2" ]
      [ D.text_ "Hook UseSpeechRecognition SpeechRecognition" ]
  , propsTable
      [ { name: "listening", type_: "Boolean", description: "Whether recognition is active" }
      , { name: "transcript", type_: "String", description: "Live transcription text" }
      , { name: "start", type_: "Effect Unit", description: "Start recognition" }
      , { name: "stop", type_: "Effect Unit", description: "Stop recognition" }
      ]
  , D.p [ DA.klass_ "text-sm text-gray-400" ]
      [ D.text_ "Uses Apple Speech framework. Requires microphone permission." ]
  ]

languageDetection :: Nut
languageDetection = L.componentDoc "detectLanguage" "Yoga.React.Native.MacOS.NaturalLanguage (detectLanguage)"
  """-- Aff-based, returns ISO language code
lang <- detectLanguage "Bonjour le monde" # liftAff
-- lang :: String  (e.g. "fr")"""
  [ D.p [ DA.klass_ "text-sm text-gray-400 mt-2" ]
      [ D.text_ "Signature: String -> Aff String" ]
  , D.p [ DA.klass_ "text-sm text-gray-400" ]
      [ D.text_ "Detects the dominant language using NLLanguageRecognizer." ]
  ]

sentimentAnalysis :: Nut
sentimentAnalysis = L.componentDoc "analyzeSentiment" "Yoga.React.Native.MacOS.NaturalLanguage (analyzeSentiment)"
  """-- Aff-based, returns sentiment score
score <- analyzeSentiment "This is great!" # liftAff
-- score :: Number  (-1.0 to 1.0)"""
  [ D.p [ DA.klass_ "text-sm text-gray-400 mt-2" ]
      [ D.text_ "Signature: String -> Aff Number" ]
  , D.p [ DA.klass_ "text-sm text-gray-400" ]
      [ D.text_ "Returns a sentiment score from -1.0 (negative) to 1.0 (positive)." ]
  ]

tokenization :: Nut
tokenization = L.componentDoc "tokenize" "Yoga.React.Native.MacOS.NaturalLanguage (tokenize)"
  """-- Aff-based, returns array of tokens
tokens <- tokenize "Hello world" # liftAff
-- tokens :: Array String"""
  [ D.p [ DA.klass_ "text-sm text-gray-400 mt-2" ]
      [ D.text_ "Signature: String -> Aff (Array String)" ]
  , D.p [ DA.klass_ "text-sm text-gray-400" ]
      [ D.text_ "Splits text into linguistic tokens using NLTokenizer." ]
  ]
