module Yoga.React.Native.MacOS.Types where

-- All enum types are newtypes over String for zero-overhead FFI compatibility.
-- Use the provided smart constructors; the newtype is not exported.

newtype BezelStyle = BezelStyle String

push :: BezelStyle
push = BezelStyle "push"

toolbar :: BezelStyle
toolbar = BezelStyle "toolbar"

texturedSquare :: BezelStyle
texturedSquare = BezelStyle "texturedSquare"

inline :: BezelStyle
inline = BezelStyle "inline"

newtype VisualEffectMaterial = VisualEffectMaterial String

sidebar :: VisualEffectMaterial
sidebar = VisualEffectMaterial "sidebar"

headerView :: VisualEffectMaterial
headerView = VisualEffectMaterial "headerView"

titlebar :: VisualEffectMaterial
titlebar = VisualEffectMaterial "titlebar"

hudWindow :: VisualEffectMaterial
hudWindow = VisualEffectMaterial "hudWindow"

contentBackground :: VisualEffectMaterial
contentBackground = VisualEffectMaterial "contentBackground"

menu :: VisualEffectMaterial
menu = VisualEffectMaterial "menu"

popoverMaterial :: VisualEffectMaterial
popoverMaterial = VisualEffectMaterial "popover"

sheet :: VisualEffectMaterial
sheet = VisualEffectMaterial "sheet"

underWindowBackground :: VisualEffectMaterial
underWindowBackground = VisualEffectMaterial "underWindowBackground"

windowBackground :: VisualEffectMaterial
windowBackground = VisualEffectMaterial "windowBackground"

newtype BlendingMode = BlendingMode String

withinWindow :: BlendingMode
withinWindow = BlendingMode "withinWindow"

behindWindow :: BlendingMode
behindWindow = BlendingMode "behindWindow"

newtype VisualEffectState = VisualEffectState String

active :: VisualEffectState
active = VisualEffectState "active"

inactive :: VisualEffectState
inactive = VisualEffectState "inactive"

followsWindow :: VisualEffectState
followsWindow = VisualEffectState "followsWindow"

newtype ToolbarStyle = ToolbarStyle String

unified :: ToolbarStyle
unified = ToolbarStyle "unified"

expanded :: ToolbarStyle
expanded = ToolbarStyle "expanded"

preference :: ToolbarStyle
preference = ToolbarStyle "preference"

unifiedCompact :: ToolbarStyle
unifiedCompact = ToolbarStyle "unifiedCompact"

newtype RiveFit = RiveFit String

contain :: RiveFit
contain = RiveFit "contain"

cover :: RiveFit
cover = RiveFit "cover"

fill :: RiveFit
fill = RiveFit "fill"

fitWidth :: RiveFit
fitWidth = RiveFit "fitWidth"

fitHeight :: RiveFit
fitHeight = RiveFit "fitHeight"

scaleDown :: RiveFit
scaleDown = RiveFit "scaleDown"

noFit :: RiveFit
noFit = RiveFit "noFit"

newtype FilePickerMode = FilePickerMode String

openFile :: FilePickerMode
openFile = FilePickerMode "open"

saveFile :: FilePickerMode
saveFile = FilePickerMode "save"

newtype ControlsStyle = ControlsStyle String

noControls :: ControlsStyle
noControls = ControlsStyle "none"

inlineControls :: ControlsStyle
inlineControls = ControlsStyle "inline"

minimalControls :: ControlsStyle
minimalControls = ControlsStyle "minimal"

floatingControls :: ControlsStyle
floatingControls = ControlsStyle "floating"

defaultControls :: ControlsStyle
defaultControls = ControlsStyle "default"

newtype ImageContentMode = ImageContentMode String

scaleToFit :: ImageContentMode
scaleToFit = ImageContentMode "scaleToFit"

center :: ImageContentMode
center = ImageContentMode "center"

scaleProportionally :: ImageContentMode
scaleProportionally = ImageContentMode "scaleProportionally"

newtype PopoverEdge = PopoverEdge String

bottom :: PopoverEdge
bottom = PopoverEdge "bottom"

top :: PopoverEdge
top = PopoverEdge "top"

left :: PopoverEdge
left = PopoverEdge "left"

right :: PopoverEdge
right = PopoverEdge "right"

newtype PopoverBehavior = PopoverBehavior String

transient :: PopoverBehavior
transient = PopoverBehavior "transient"

semitransient :: PopoverBehavior
semitransient = PopoverBehavior "semitransient"

applicationDefined :: PopoverBehavior
applicationDefined = PopoverBehavior "applicationDefined"

newtype AlertStyle = AlertStyle String

warning :: AlertStyle
warning = AlertStyle "warning"

critical :: AlertStyle
critical = AlertStyle "critical"

informational :: AlertStyle
informational = AlertStyle "informational"
