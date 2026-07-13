module Demo.DatingDemo
  ( datingDemo
  ) where

import Prelude

import Data.Array as Array
import Data.Maybe (Maybe(..))
import Effect (Effect)
import React.Basic (JSX)
import React.Basic.Events (handler_)
import React.Basic.Hooks (useState, useState', (/\))
import React.Basic.Hooks as React
import Yoga.React (component)
import Yoga.React.Native (activityIndicator, imageBackground, pressable, text, tw, view)
import Yoga.React.Native.Image (uri)
import Yoga.React.Native.Style as Style
import Yoga.React.Native.Animated (AnimatedValue, Damping(..), Degrees(..), Mass(..), Points(..), Stiffness(..), Velocity(..), animatedView, interpolate, interpolateRotation, physicalSpring, toAnimatedValue)
import Yoga.React.Native.GestureHandler as Gesture

type Profile =
  { name :: String
  , age :: Int
  , location :: String
  , distance :: String
  , photo :: String
  , photoDescription :: String
  , note :: String
  , interests :: Array String
  , verified :: Boolean
  }

data NavTab
  = DiscoverTab
  | SignalsTab
  | ProfileTab

derive instance Eq NavTab

firstProfile :: Profile
firstProfile =
  { name: "Mara"
  , age: 29
  , location: "North Beach"
  , distance: "2 km away"
  , photo: "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=1200&auto=format&fit=crop&q=86"
  , photoDescription: "Portrait of Mara outdoors in warm evening light"
  , note: "Ceramicist, tide-pool regular, and serious about Sunday supper."
  , interests: [ "Clay studio", "Ocean swims", "Natural wine" ]
  , verified: true
  }

profiles :: Array Profile
profiles =
  [ firstProfile
  , { name: "Sol"
    , age: 31
    , location: "Mission District"
    , distance: "4 km away"
    , photo: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=1200&auto=format&fit=crop&q=86"
    , photoDescription: "Portrait of Sol smiling against a soft city background"
    , note: "Architect by day. Building a tiny record collection one perfect album at a time."
    , interests: [ "Modernism", "Vinyl", "Night markets" ]
    , verified: true
    }
  , { name: "Noor"
    , age: 28
    , location: "Lake Merritt"
    , distance: "7 km away"
    , photo: "https://images.unsplash.com/photo-1529139574466-a303027c1d8b?w=1200&auto=format&fit=crop&q=86"
    , photoDescription: "Editorial portrait of Noor in a sunlit garden"
    , note: "Food writer chasing bright flavors, old bookstores, and a very good walk."
    , interests: [ "Cookbooks", "Long walks", "Film photos" ]
    , verified: false
    }
  , { name: "Inez"
    , age: 33
    , location: "Rockridge"
    , distance: "9 km away"
    , photo: "https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=1200&auto=format&fit=crop&q=86"
    , photoDescription: "Portrait of Inez in soft window light"
    , note: "Museum educator with a soft spot for jazz piano and improbable road trips."
    , interests: [ "Gallery days", "Jazz", "Road trips" ]
    , verified: true
    }
  ]

profileCount :: Int
profileCount = Array.length profiles

normalizeIndex :: Int -> Int
normalizeIndex value =
  if profileCount <= 0 then 0
  else ((value `mod` profileCount) + profileCount) `mod` profileCount

profileAt :: Int -> Profile
profileAt value =
  case Array.index profiles (normalizeIndex value) of
    Just found -> found
    Nothing -> firstProfile

swipeConfig :: Gesture.SwipeConfig
swipeConfig =
  { dismissalDistance: Points 110.0
  , dismissalVelocity: Velocity 0.72
  , returnSpring: physicalSpring { stiffness: Stiffness 280.0, damping: Damping 24.0, mass: Mass 0.9 }
  , dismissalSpring: physicalSpring { stiffness: Stiffness 210.0, damping: Damping 22.0, mass: Mass 0.9 }
  }

datingDemo :: JSX -> JSX
datingDemo = component "DatingDemo" \backButton -> React.do
  profileIndex /\ setProfileIndex <- useState' 0
  matchedProfile /\ setMatchedProfile <- useState' (Nothing :: Maybe Profile)
  activeTab /\ setActiveTab <- useState' DiscoverTab
  loadedPhotos /\ setLoadedPhotos <- useState ([] :: Array String)
  let
    currentProfile = profileAt profileIndex
    nextProfile = profileAt (profileIndex + 1)

    moveTo offset = do
      setMatchedProfile Nothing
      setProfileIndex (normalizeIndex (profileIndex + offset))

    likeCurrent = do
      setProfileIndex (normalizeIndex (profileIndex + 1))
      setMatchedProfile (if profileIndex `mod` 2 == 0 then Just currentProfile else Nothing)

    sparkCurrent = do
      setProfileIndex (normalizeIndex (profileIndex + 1))
      setMatchedProfile (if profileIndex `mod` 3 == 1 then Just currentProfile else Nothing)

    markLoaded photo = setLoadedPhotos \loaded ->
      if Array.elem photo loaded then loaded
      else Array.snoc loaded photo

  swipe <- Gesture.useNativeSwipe swipeConfig case _ of
    Gesture.SwipeLeft -> moveTo 1
    Gesture.SwipeRight -> likeCurrent

  let
    swipeX = Gesture.swipePosition swipe
    swipeValue = toAnimatedValue swipeX
    swipeRotation = interpolateRotation swipeX
      { inputRange: [ Points (-320.0), Points 0.0, Points 320.0 ]
      , outputRange: [ Degrees (-13.0), Degrees 0.0, Degrees 13.0 ]
      , extrapolate: "clamp"
      }
    deckProgress = toAnimatedValue (Gesture.swipeProgress swipe)
    nextOpacity = interpolate deckProgress
      { inputRange: [ 0.0, 1.0 ], outputRange: [ 0.58, 1.0 ], extrapolate: "clamp" }
    nextTranslateY = interpolate deckProgress
      { inputRange: [ 0.0, 1.0 ], outputRange: [ 12.0, 0.0 ], extrapolate: "clamp" }
    nextScale = interpolate deckProgress
      { inputRange: [ 0.0, 1.0 ], outputRange: [ 0.94, 1.0 ], extrapolate: "clamp" }
    likeOpacity = interpolate swipeValue
      { inputRange: [ 15.0, 100.0 ], outputRange: [ 0.0, 1.0 ], extrapolate: "clamp" }
    passOpacity = interpolate swipeValue
      { inputRange: [ -100.0, -15.0 ], outputRange: [ 1.0, 0.0 ], extrapolate: "clamp" }

  pure do
    view
      { style: tw "flex-1" <> Style.style { backgroundColor: bone }
      , accessibilityLabel: "Lumen dating discovery"
      }
      [ header backButton
      , progressRail profileIndex
      , view { style: tw "flex-1 px-4" <> Style.style { position: "relative", minHeight: 380.0 } }
          [ animatedView
              { style: Style.style
                  { position: "absolute"
                  , top: 0.0
                  , right: 0.0
                  , bottom: 0.0
                  , left: 0.0
                  , opacity: nextOpacity
                  , transform: [ { translateY: nextTranslateY } ]
                  }
              }
              [ animatedView
                  { style: Style.style
                      { position: "absolute"
                      , top: 0.0
                      , right: 0.0
                      , bottom: 0.0
                      , left: 0.0
                      , transform: [ { scale: nextScale } ]
                      }
                  }
                  [ profileCard nextProfile (Array.elem nextProfile.photo loadedPhotos) (markLoaded nextProfile.photo) ]
              ]
          , Gesture.swipeGestureView swipe $
              animatedView
                { accessible: true
                , accessibilityRole: "adjustable"
                , accessibilityLabel: "Profile card for " <> currentProfile.name
                , accessibilityHint: "Swipe left to pass or right to like"
                , style: Style.style
                    { position: "absolute"
                    , top: 0.0
                    , right: 0.0
                    , bottom: 0.0
                    , left: 0.0
                    , transform: [ { translateX: swipeX } ]
                    }
                }
                [ animatedView
                    { style: Style.style
                        { position: "absolute"
                        , top: 0.0
                        , right: 0.0
                        , bottom: 0.0
                        , left: 0.0
                        , transform: [ { rotate: swipeRotation } ]
                        }
                    }
                    [ profileCard currentProfile (Array.elem currentProfile.photo loadedPhotos) (markLoaded currentProfile.photo)
                    , swipeStampLeft "LIKE" coral (-8.0) likeOpacity
                    , swipeStampRight "PASS" cobalt 8.0 passOpacity
                    ]
                ]
          ]
      , view { style: tw "flex-row items-center justify-center px-5 pt-4 pb-2" }
          [ actionButton "↶" "Undo last choice" "Return to the previous profile" cobalt 52.0 (moveTo (-1))
          , actionButton "×" "Pass on this profile" "Show the next profile" ink 62.0 (moveTo 1)
          , actionButton "✦" "Send a spark" "Show interest with a spark and continue" coral 56.0 sparkCurrent
          , actionButton "♥" "Like this profile" "Like this person and continue" cobalt 62.0 likeCurrent
          ]
      , bottomNavigation activeTab setActiveTab
      , case matchedProfile of
          Nothing -> mempty
          Just matched -> matchOverlay matched (setMatchedProfile Nothing)
      ]

header :: JSX -> JSX
header backButton =
  view { style: tw "flex-row items-center px-4 pt-3 pb-2" }
    [ view { style: Style.style { width: 54.0 } } [ backButton ]
    , view { style: tw "flex-1 items-center" }
        [ view { style: tw "flex-row items-center" }
            [ view { style: tw "rounded-full mr-2" <> Style.style { width: 9.0, height: 9.0, backgroundColor: coral } } []
            , text
                { style: tw "font-semibold" <> Style.style { color: ink, fontSize: 22.0, letterSpacing: 3.4 }
                , accessibilityRole: "header"
                }
                "LUMEN"
            ]
        , text { style: Style.style { color: mutedInk, fontSize: 10.0, letterSpacing: 1.8, marginTop: 1.0 } } "PEOPLE, IN A NEW LIGHT"
        ]
    , view { style: tw "items-end justify-center" <> Style.style { width: 54.0 } }
        [ text { style: tw "font-semibold" <> Style.style { color: cobalt, fontSize: 10.0, letterSpacing: 1.2 } } "ISSUE 08" ]
    ]
swipeStampLeft :: String -> String -> Number -> AnimatedValue -> JSX
swipeStampLeft label color angle opacity =
  animatedView
    { style: Style.style
        { position: "absolute"
        , top: 28.0
        , left: 22.0
        , opacity
        , transform: [ { rotate: show angle <> "deg" } ]
        }
    }
    [ swipeStampContent label color ]

swipeStampRight :: String -> String -> Number -> AnimatedValue -> JSX
swipeStampRight label color angle opacity =
  animatedView
    { style: Style.style
        { position: "absolute"
        , top: 28.0
        , right: 22.0
        , opacity
        , transform: [ { rotate: show angle <> "deg" } ]
        }
    }
    [ swipeStampContent label color ]

swipeStampContent :: String -> String -> JSX
swipeStampContent label color =
  view
    { style: Style.style
        { borderWidth: 3.0
        , borderColor: color
        , borderRadius: 10.0
        , paddingLeft: 13.0
        , paddingRight: 13.0
        , paddingTop: 7.0
        , paddingBottom: 7.0
        , backgroundColor: "rgba(255,255,255,0.86)"
        }
    }
    [ text { style: tw "font-extrabold" <> Style.style { color, fontSize: 22.0, letterSpacing: 2.4 } } label ]


progressRail :: Int -> JSX
progressRail selected =
  view
    { style: tw "flex-row px-5 pb-3"
    , accessibilityLabel: "Profile " <> show (normalizeIndex selected + 1) <> " of " <> show profileCount
    }
    (Array.mapWithIndex progressSegment profiles)
  where
  progressSegment index _ =
    view
      { style: tw "flex-1 rounded-full"
          <> Style.style
            { height: 3.0
            , marginRight: if index == profileCount - 1 then 0.0 else 5.0
            , backgroundColor: if index == normalizeIndex selected then coral else "#D9CEC1"
            }
      }
      []

profileCard :: Profile -> Boolean -> Effect Unit -> JSX
profileCard profile isLoaded onLoaded =
  imageBackground
    { source: uri profile.photo
    , resizeMode: "cover"
    , imageStyle: Style.style { borderRadius: 28.0 }
    , onLoad: handler_ onLoaded
    , onLoadEnd: handler_ (pure unit)
    , onError: handler_ onLoaded
    , accessibilityLabel: profile.photoDescription <> ". " <> profile.name <> ", " <> show profile.age
    , style: tw "overflow-hidden"
        <> Style.style
          { position: "absolute"
          , top: 0.0
          , left: 0.0
          , right: 0.0
          , bottom: 0.0
          , borderRadius: 28.0
          , backgroundColor: "#B7806C"
          , shadowColor: "#251A14"
          , shadowOpacity: 0.23
          , shadowRadius: 18.0
          , shadowOffset: { width: 0.0, height: 9.0 }
          }
    }
    (profileDetails profile <> if isLoaded then [] else [ imageLoadingOverlay ])

imageLoadingOverlay :: JSX
imageLoadingOverlay =
  view
    { style: tw "items-center justify-center"
        <> Style.style
          { position: "absolute"
          , top: 0.0
          , right: 0.0
          , bottom: 0.0
          , left: 0.0
          , backgroundColor: "rgba(45,33,27,0.56)"
          }
    , accessibilityLabel: "Loading profile photo"
    }
    [ activityIndicator { animating: true, size: "large", color: "#FFF8EF", accessibilityLabel: "Loading profile photo" } ]

profileDetails :: Profile -> Array JSX
profileDetails profile =
  [ view
      { style: Style.style
          { position: "absolute"
          , left: 0.0
          , right: 0.0
          , bottom: 0.0
          , height: 250.0
          , backgroundColor: "rgba(20,16,13,0.26)"
          }
      }
      []
  , view
      { style: Style.style
          { position: "absolute"
          , left: 0.0
          , right: 0.0
          , bottom: 0.0
          , height: 175.0
          , backgroundColor: "rgba(17,15,14,0.48)"
          }
      }
      []
  , view
      { style: tw "justify-end px-5 pb-5" <> Style.style { position: "absolute", left: 0.0, right: 0.0, bottom: 0.0 }
      }
      [ view { style: tw "flex-row items-center" }
          [ text { style: tw "font-semibold" <> Style.style { color: "#FFF9F2", fontSize: 30.0, letterSpacing: (-0.6) } } profile.name
          , text { style: Style.style { color: "#FFF9F2", fontSize: 25.0, marginLeft: 8.0 } } (show profile.age)
          , if profile.verified then
              view
                { style: tw "rounded-full items-center justify-center ml-2"
                    <> Style.style { width: 20.0, height: 20.0, backgroundColor: cobalt }
                , accessibilityLabel: "Verified profile"
                }
                [ text { style: tw "font-bold" <> Style.style { color: "#FFFFFF", fontSize: 12.0 } } "✓" ]
            else mempty
          ]
      , view { style: tw "flex-row items-center mt-1" }
          [ text { style: Style.style { color: "#FFF9F2", fontSize: 13.0 } } "⌖  "
          , text { style: Style.style { color: "#FFF9F2", fontSize: 13.0, letterSpacing: 0.2 } }
              (profile.location <> "  ·  " <> profile.distance)
          ]
      , text { style: Style.style { color: "#F4EBE1", fontSize: 13.0, lineHeight: 19.0, marginTop: 8.0 } } profile.note
      , view { style: tw "flex-row mt-3" }
          (profile.interests <#> interestPill)
      ]
  ]

interestPill :: String -> JSX
interestPill label =
  view
    { style: tw "rounded-full px-3 py-1 mr-2"
        <> Style.style { backgroundColor: "rgba(255,249,242,0.18)", borderWidth: 1.0, borderColor: "rgba(255,249,242,0.34)" }
    }
    [ text { style: tw "font-medium" <> Style.style { color: "#FFF9F2", fontSize: 11.0 } } label ]

actionButton :: String -> String -> String -> String -> Number -> Effect Unit -> JSX
actionButton glyph label hint color size action =
  pressable
    { onPress: handler_ action
    , accessibilityRole: "button"
    , accessibilityLabel: label
    , accessibilityHint: hint
    , style: tw "rounded-full items-center justify-center mx-2"
        <> Style.style
          { width: size
          , height: size
          , backgroundColor: "#FFFDFC"
          , borderWidth: 1.0
          , borderColor: "#E6DCD1"
          , shadowColor: "#37291F"
          , shadowOpacity: 0.12
          , shadowRadius: 9.0
          , shadowOffset: { width: 0.0, height: 5.0 }
          }
    }
    [ text { style: tw "font-semibold" <> Style.style { color, fontSize: if glyph == "×" then 32.0 else 22.0 } } glyph ]

bottomNavigation :: NavTab -> (NavTab -> Effect Unit) -> JSX
bottomNavigation activeTab setActiveTab =
  view
    { style: tw "flex-row items-center px-6 pt-2 pb-4"
        <> Style.style { borderTopWidth: 1.0, borderTopColor: "#E8DED4", backgroundColor: bone }
    , accessibilityRole: "tablist"
    }
    [ navItem activeTab DiscoverTab "◉" "Discover" setActiveTab
    , navItem activeTab SignalsTab "✦" "Signals" setActiveTab
    , navItem activeTab ProfileTab "○" "You" setActiveTab
    ]

navItem :: NavTab -> NavTab -> String -> String -> (NavTab -> Effect Unit) -> JSX
navItem activeTab tab glyph label setActiveTab =
  let isActive = activeTab == tab
  in
    pressable
      { onPress: handler_ (setActiveTab tab)
      , accessibilityRole: "tab"
      , accessibilityLabel: if isActive then label <> ", selected" else label
      , accessibilityHint: "Open the " <> label <> " section"
      , style: tw "flex-1 items-center pt-2"
      }
      [ text { style: Style.style { color: if isActive then coral else mutedInk, fontSize: 20.0 } } glyph
      , text
          { style: tw "font-semibold mt-1"
              <> Style.style { color: if isActive then ink else mutedInk, fontSize: 10.0, letterSpacing: 0.8 }
          }
          label
      , view
          { style: tw "rounded-full mt-1"
              <> Style.style { width: 18.0, height: 2.0, backgroundColor: if isActive then coral else "transparent" }
          }
          []
      ]

matchOverlay :: Profile -> Effect Unit -> JSX
matchOverlay profile dismiss =
  view
    { style: tw "items-center justify-center px-7"
        <> Style.style
          { position: "absolute"
          , top: 0.0
          , left: 0.0
          , right: 0.0
          , bottom: 0.0
          , zIndex: 50
          , backgroundColor: "rgba(22,24,30,0.72)"
          }
    , accessibilityLabel: "You and " <> profile.name <> " matched"
    }
    [ view
        { style: tw "items-center px-6 pt-6 pb-5"
            <> Style.style
              { width: "100%"
              , maxWidth: 390.0
              , borderRadius: 28.0
              , backgroundColor: "#FFF9F2"
              , borderWidth: 1.0
              , borderColor: "rgba(255,255,255,0.62)"
              , shadowColor: "#000000"
              , shadowOpacity: 0.28
              , shadowRadius: 24.0
              , shadowOffset: { width: 0.0, height: 14.0 }
              }
        }
        [ pressable
            { onPress: handler_ dismiss
            , accessibilityRole: "button"
            , accessibilityLabel: "Dismiss match"
            , accessibilityHint: "Close this match message"
            , style: tw "rounded-full items-center justify-center"
                <> Style.style { position: "absolute", top: 14.0, right: 14.0, width: 34.0, height: 34.0, backgroundColor: "#EEE4D9", zIndex: 2 }
            }
            [ text { style: Style.style { color: ink, fontSize: 20.0 } } "×" ]
        , view { style: tw "flex-row items-center mb-2" }
            [ view { style: tw "rounded-full" <> Style.style { width: 28.0, height: 2.0, backgroundColor: cobalt } } []
            , text { style: tw "font-semibold mx-3" <> Style.style { color: coral, fontSize: 11.0, letterSpacing: 2.0 } } "A BRIGHT BEGINNING"
            , view { style: tw "rounded-full" <> Style.style { width: 28.0, height: 2.0, backgroundColor: cobalt } } []
            ]
        , text { style: tw "font-semibold text-center" <> Style.style { color: ink, fontSize: 31.0, letterSpacing: (-0.7) } } "The feeling is mutual."
        , text { style: Style.style { color: mutedInk, fontSize: 14.0, lineHeight: 20.0, textAlign: "center", marginTop: 7.0 } }
            (profile.name <> " noticed your light too. Say hello whenever it feels right.")
        , imageBackground
            { source: uri profile.photo
            , resizeMode: "cover"
            , imageStyle: Style.style { borderRadius: 48.0 }
            , accessibilityLabel: profile.photoDescription
            , style: tw "rounded-full overflow-hidden mt-5"
                <> Style.style { width: 96.0, height: 96.0, borderWidth: 4.0, borderColor: "#FFF9F2", shadowColor: coral, shadowOpacity: 0.26, shadowRadius: 14.0 }
            }
            [ view { style: tw "flex-1 rounded-full" <> Style.style { borderWidth: 2.0, borderColor: coral } } [] ]
        , pressable
            { onPress: handler_ dismiss
            , accessibilityRole: "button"
            , accessibilityLabel: "Keep browsing"
            , accessibilityHint: "Dismiss this match and continue discovering profiles"
            , style: tw "rounded-full px-6 py-4 mt-5"
                <> Style.style { width: "100%", backgroundColor: coral }
            }
            [ text { style: tw "font-semibold text-center" <> Style.style { color: "#FFFFFF", fontSize: 14.0, letterSpacing: 0.4 } } "Keep browsing" ]
        ]
    ]

bone :: String
bone = "#F6F0E8"

ink :: String
ink = "#20242B"

mutedInk :: String
mutedInk = "#756D66"

coral :: String
coral = "#F36F62"

cobalt :: String
cobalt = "#3157C8"
