#import <React/RCTViewManager.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTBridge.h>
#import <React/RCTUIManager.h>

#import <AppKit/AppKit.h>
#import <WebKit/WebKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#import <QuartzCore/QuartzCore.h>
#import <UserNotifications/UserNotifications.h>
#import <MapKit/MapKit.h>
#import <Quartz/Quartz.h>
#import <Vision/Vision.h>
#import <Speech/Speech.h>
#import <NaturalLanguage/NaturalLanguage.h>
#import <objc/message.h>
@import RiveRuntime;

// ============================================================
// 1. NSButton
// ============================================================

@interface RCTBorderlessButtonCell : NSButtonCell
@property (nonatomic, assign) BOOL hovered;
@end

@implementation RCTBorderlessButtonCell
- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
  if (_hovered) {
    BOOL isDark = [NSApp.effectiveAppearance bestMatchFromAppearancesWithNames:@[NSAppearanceNameDarkAqua]] != nil;
    NSColor *color = isDark
      ? [NSColor colorWithWhite:1.0 alpha:0.15]
      : [NSColor colorWithWhite:0.0 alpha:0.1];
    [color setFill];
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:cellFrame
      xRadius:cellFrame.size.height / 2.0
      yRadius:cellFrame.size.height / 2.0];
    [path fill];
  }
  [super drawWithFrame:cellFrame inView:controlView];
}
@end

@interface RCTNativeButtonView : NSView <NSTextInputClient>
@property (nonatomic, strong) NSButton *button;
@property (nonatomic, assign) BOOL borderlessHover;
@property (nonatomic, copy) RCTDirectEventBlock onPressButton;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *sfSymbol;
@property (nonatomic, copy) NSString *bezelStyle;
@property (nonatomic, assign) BOOL destructive;
@property (nonatomic, assign) BOOL primary;
@property (nonatomic, assign) BOOL buttonEnabled;
@property (nonatomic, copy) RCTDirectEventBlock onEmojiPick;
@end

@implementation RCTNativeButtonView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _button = [NSButton buttonWithTitle:@"Button" target:self action:@selector(handlePress)];
    _button.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    _buttonEnabled = YES;
    [self addSubview:_button];
  }
  return self;
}

- (BOOL)acceptsFirstResponder { return _onEmojiPick != nil; }

- (void)handlePress {
  if (_onEmojiPick) {
    [self.window makeFirstResponder:self];
    [NSApp orderFrontCharacterPalette:nil];
    return;
  }
  if (_onPressButton) _onPressButton(@{});
}

// NSTextInputClient required methods
- (void)insertText:(id)string replacementRange:(NSRange)replacementRange {
  NSString *text = [string isKindOfClass:[NSAttributedString class]]
    ? [(NSAttributedString *)string string] : string;
  if (_onEmojiPick && text.length > 0) {
    _onEmojiPick(@{@"emoji": text});
  }
}

- (void)doCommandBySelector:(SEL)selector {}
- (void)setMarkedText:(id)string selectedRange:(NSRange)selectedRange replacementRange:(NSRange)replacementRange {}
- (void)unmarkText {}
- (NSRange)selectedRange { return NSMakeRange(NSNotFound, 0); }
- (NSRange)markedRange { return NSMakeRange(NSNotFound, 0); }
- (BOOL)hasMarkedText { return NO; }
- (NSAttributedString *)attributedSubstringForProposedRange:(NSRange)range actualRange:(NSRangePointer)actualRange { return nil; }
- (NSArray<NSAttributedStringKey> *)validAttributesForMarkedText { return @[]; }
- (NSRect)firstRectForCharacterRange:(NSRange)range actualRange:(NSRangePointer)actualRange {
  NSRect r = [self convertRect:self.bounds toView:nil];
  return [self.window convertRectToScreen:r];
}
- (NSUInteger)characterIndexForPoint:(NSPoint)point { return NSNotFound; }

- (void)mouseEntered:(NSEvent *)event {
  if (_borderlessHover) {
    ((RCTBorderlessButtonCell *)_button.cell).hovered = YES;
    [_button setNeedsDisplay:YES];
  }
}

- (void)mouseExited:(NSEvent *)event {
  if (_borderlessHover) {
    ((RCTBorderlessButtonCell *)_button.cell).hovered = NO;
    [_button setNeedsDisplay:YES];
  }
}

- (void)setTitle:(NSString *)title {
  _title = title;
  if (title.length > 0) {
    _button.image = nil;
    _button.title = title;
  } else {
    _button.title = @"";
  }
}

- (void)setSfSymbol:(NSString *)sfSymbol {
  _sfSymbol = sfSymbol;
  if (sfSymbol.length > 0) {
    NSImage *img = [NSImage imageWithSystemSymbolName:sfSymbol accessibilityDescription:sfSymbol];
    if (img) {
      _button.image = img;
      _button.title = @"";
      _button.imagePosition = NSImageOnly;
    }
  } else {
    _button.image = nil;
    _button.title = _title ?: @"";
    _button.imagePosition = NSNoImage;
  }
}

- (void)setBezelStyle:(NSString *)bezelStyle {
  _bezelStyle = bezelStyle;
  if ([bezelStyle isEqualToString:@"toolbar"]) _button.bezelStyle = NSBezelStyleToolbar;
  else if ([bezelStyle isEqualToString:@"texturedSquare"]) _button.bezelStyle = NSBezelStyleTexturedSquare;
  else if ([bezelStyle isEqualToString:@"inline"]) _button.bezelStyle = NSBezelStyleInline;
  else if ([bezelStyle isEqualToString:@"circular"]) _button.bezelStyle = NSBezelStyleCircular;
  else if ([bezelStyle isEqualToString:@"accessoryBarAction"]) _button.bezelStyle = NSBezelStyleAccessoryBarAction;
  else if ([bezelStyle isEqualToString:@"borderless"]) {
    _button.bordered = NO;
    RCTBorderlessButtonCell *cell = [[RCTBorderlessButtonCell alloc] initTextCell:_button.title];
    cell.bordered = NO;
    cell.target = self;
    cell.action = @selector(handlePress);
    _button.cell = cell;
    _borderlessHover = YES;
    NSTrackingArea *ta = [[NSTrackingArea alloc]
      initWithRect:NSZeroRect
      options:NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect
      owner:self
      userInfo:nil];
    [self addTrackingArea:ta];
  }
  else _button.bezelStyle = NSBezelStylePush;
}

- (void)setDestructive:(BOOL)destructive {
  _destructive = destructive;
  _button.hasDestructiveAction = destructive;
}

- (void)setPrimary:(BOOL)primary {
  _primary = primary;
  if (primary) _button.keyEquivalent = @"\r";
  else _button.keyEquivalent = @"";
}

- (void)setButtonEnabled:(BOOL)buttonEnabled {
  _buttonEnabled = buttonEnabled;
  _button.enabled = buttonEnabled;
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
- (void)layout {
  [super layout];
  _button.frame = self.bounds;

}
@end

@interface RCTNativeButtonViewManager : RCTViewManager @end
@implementation RCTNativeButtonViewManager
RCT_EXPORT_MODULE(NativeButton)
- (NSView *)view { return [[RCTNativeButtonView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(title, NSString)
RCT_EXPORT_VIEW_PROPERTY(sfSymbol, NSString)
RCT_EXPORT_VIEW_PROPERTY(bezelStyle, NSString)
RCT_EXPORT_VIEW_PROPERTY(destructive, BOOL)
RCT_EXPORT_VIEW_PROPERTY(primary, BOOL)
RCT_EXPORT_VIEW_PROPERTY(buttonEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onPressButton, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onEmojiPick, RCTDirectEventBlock)
@end

// ============================================================
// 2. NSSegmentedControl
// ============================================================

@interface RCTNativeSegmentedView : NSView
@property (nonatomic, strong) NSSegmentedControl *control;
@property (nonatomic, copy) RCTBubblingEventBlock onChange;
@property (nonatomic, copy) NSArray<NSString *> *labels;
@property (nonatomic, copy) NSArray<NSString *> *sfSymbols;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation RCTNativeSegmentedView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _control = [NSSegmentedControl segmentedControlWithLabels:@[@"One", @"Two"]
                                                 trackingMode:NSSegmentSwitchTrackingSelectOne
                                                       target:self
                                                       action:@selector(handleChange)];
    _control.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self addSubview:_control];
  }
  return self;
}

- (void)handleChange {
  if (_onChange) _onChange(@{@"selectedIndex": @(_control.selectedSegment)});
}

- (void)setLabels:(NSArray<NSString *> *)labels {
  _labels = labels;
  _control.segmentCount = labels.count;
  for (NSUInteger i = 0; i < labels.count; i++) {
    [_control setLabel:labels[i] forSegment:i];
  }
  if (_selectedIndex < (NSInteger)labels.count) _control.selectedSegment = _selectedIndex;
}

- (void)setSfSymbols:(NSArray<NSString *> *)sfSymbols {
  _sfSymbols = sfSymbols;
  _control.segmentCount = sfSymbols.count;
  for (NSUInteger i = 0; i < sfSymbols.count; i++) {
    NSImage *img = [NSImage imageWithSystemSymbolName:sfSymbols[i] accessibilityDescription:sfSymbols[i]];
    if (img) [_control setImage:img forSegment:i];
  }
  if (_selectedIndex < (NSInteger)sfSymbols.count) _control.selectedSegment = _selectedIndex;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
  _selectedIndex = selectedIndex;
  if (selectedIndex < _control.segmentCount) _control.selectedSegment = selectedIndex;
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
- (void)layout {
  [super layout];
  _control.frame = self.bounds;
}
@end

@interface RCTNativeSegmentedViewManager : RCTViewManager @end
@implementation RCTNativeSegmentedViewManager
RCT_EXPORT_MODULE(NativeSegmented)
- (NSView *)view { return [[RCTNativeSegmentedView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(labels, NSArray)
RCT_EXPORT_VIEW_PROPERTY(sfSymbols, NSArray)
RCT_EXPORT_VIEW_PROPERTY(selectedIndex, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(onChange, RCTBubblingEventBlock)
@end

// ============================================================
// 3. NSTextField (native text input)
// ============================================================

@interface RCTNativeTextFieldView : NSView <NSTextFieldDelegate>
@property (nonatomic, strong) NSTextField *textField;
@property (nonatomic, copy) RCTBubblingEventBlock onChangeText;
@property (nonatomic, copy) RCTBubblingEventBlock onSubmit;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) BOOL secure;
@property (nonatomic, assign) BOOL search;
@property (nonatomic, assign) BOOL rounded;
@end

@implementation RCTNativeTextFieldView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _textField = [[NSTextField alloc] initWithFrame:self.bounds];
    _textField.delegate = self;
    _textField.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self addSubview:_textField];
  }
  return self;
}

- (void)setPlaceholder:(NSString *)placeholder {
  _placeholder = placeholder;
  _textField.placeholderString = placeholder;
}

- (void)setText:(NSString *)text {
  _text = text;
  _textField.stringValue = text ?: @"";
}

- (void)setSecure:(BOOL)secure {
  _secure = secure;
  if (secure) {
    NSSecureTextField *sf = [[NSSecureTextField alloc] initWithFrame:self.bounds];
    sf.placeholderString = _placeholder;
    sf.stringValue = _textField.stringValue;
    sf.delegate = self;
    sf.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [_textField removeFromSuperview];
    _textField = sf;
    [self addSubview:sf];
  }
}

- (void)setSearch:(BOOL)search {
  _search = search;
  if (search) {
    NSSearchField *sf = [[NSSearchField alloc] initWithFrame:self.bounds];
    sf.placeholderString = _placeholder;
    sf.stringValue = _textField.stringValue;
    sf.delegate = self;
    sf.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [_textField removeFromSuperview];
    _textField = sf;
    [self addSubview:sf];
  }
}

- (void)setRounded:(BOOL)rounded {
  _rounded = rounded;
  if (rounded) {
    _textField.bezelStyle = NSTextFieldRoundedBezel;
  } else {
    _textField.bezelStyle = NSTextFieldSquareBezel;
  }
}

- (void)controlTextDidChange:(NSNotification *)notification {
  if (_onChangeText) _onChangeText(@{@"text": _textField.stringValue});
}

- (void)controlTextDidEndEditing:(NSNotification *)notification {
  NSNumber *movement = notification.userInfo[@"NSTextMovement"];
  if (movement && movement.integerValue == NSReturnTextMovement) {
    if (_onSubmit) _onSubmit(@{@"text": _textField.stringValue});
  }
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
- (void)layout {
  [super layout];
  _textField.frame = self.bounds;
}
@end

@interface RCTNativeTextFieldViewManager : RCTViewManager @end
@implementation RCTNativeTextFieldViewManager
RCT_EXPORT_MODULE(NativeTextField)
- (NSView *)view { return [[RCTNativeTextFieldView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(text, NSString)
RCT_EXPORT_VIEW_PROPERTY(placeholder, NSString)
RCT_EXPORT_VIEW_PROPERTY(secure, BOOL)
RCT_EXPORT_VIEW_PROPERTY(search, BOOL)
RCT_EXPORT_VIEW_PROPERTY(rounded, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onChangeText, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onSubmit, RCTBubblingEventBlock)
@end

// ============================================================
// 4. NSSlider
// ============================================================

@interface RCTNativeSliderView : NSView
@property (nonatomic, strong) NSSlider *slider;
@property (nonatomic, copy) RCTBubblingEventBlock onChange;
@property (nonatomic, assign) double value;
@property (nonatomic, assign) double minValue;
@property (nonatomic, assign) double maxValue;
@property (nonatomic, assign) NSInteger numberOfTickMarks;
@property (nonatomic, assign) BOOL allowsTickMarkValuesOnly;
@end

@implementation RCTNativeSliderView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _slider = [NSSlider sliderWithValue:50 minValue:0 maxValue:100 target:self action:@selector(handleChange)];
    _slider.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    _minValue = 0;
    _maxValue = 100;
    _value = 50;
    [self addSubview:_slider];
  }
  return self;
}

- (void)handleChange {
  if (_onChange) _onChange(@{@"value": @(_slider.doubleValue)});
}

- (void)setValue:(double)value { _value = value; _slider.doubleValue = value; }
- (void)setMinValue:(double)minValue { _minValue = minValue; _slider.minValue = minValue; }
- (void)setMaxValue:(double)maxValue { _maxValue = maxValue; _slider.maxValue = maxValue; }
- (void)setNumberOfTickMarks:(NSInteger)n { _numberOfTickMarks = n; _slider.numberOfTickMarks = n; }
- (void)setAllowsTickMarkValuesOnly:(BOOL)v { _allowsTickMarkValuesOnly = v; _slider.allowsTickMarkValuesOnly = v; }

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
- (void)layout {
  [super layout];
  _slider.frame = self.bounds;
}
@end

@interface RCTNativeSliderViewManager : RCTViewManager @end
@implementation RCTNativeSliderViewManager
RCT_EXPORT_MODULE(NativeSlider)
- (NSView *)view { return [[RCTNativeSliderView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(value, double)
RCT_EXPORT_VIEW_PROPERTY(minValue, double)
RCT_EXPORT_VIEW_PROPERTY(maxValue, double)
RCT_EXPORT_VIEW_PROPERTY(numberOfTickMarks, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(allowsTickMarkValuesOnly, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onChange, RCTBubblingEventBlock)
@end

// ============================================================
// 5. NSSwitch
// ============================================================

@interface RCTNativeSwitchView : NSView
@property (nonatomic, strong) NSSwitch *toggle;
@property (nonatomic, copy) RCTBubblingEventBlock onChange;
@property (nonatomic, assign) BOOL on;
@end

@implementation RCTNativeSwitchView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _toggle = [[NSSwitch alloc] initWithFrame:self.bounds];
    _toggle.target = self;
    _toggle.action = @selector(handleChange);
    _toggle.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self addSubview:_toggle];
  }
  return self;
}

- (void)handleChange {
  BOOL isOn = (_toggle.state == NSControlStateValueOn);
  if (_onChange) _onChange(@{@"on": @(isOn)});
}

- (void)setOn:(BOOL)on {
  _on = on;
  _toggle.state = on ? NSControlStateValueOn : NSControlStateValueOff;
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
- (void)layout {
  [super layout];
  _toggle.frame = self.bounds;
}
@end

@interface RCTNativeSwitchViewManager : RCTViewManager @end
@implementation RCTNativeSwitchViewManager
RCT_EXPORT_MODULE(NativeSwitch)
- (NSView *)view { return [[RCTNativeSwitchView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(on, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onChange, RCTBubblingEventBlock)
@end

// ============================================================
// 6. NSProgressIndicator
// ============================================================

@interface RCTNativeProgressView : NSView
@property (nonatomic, strong) NSProgressIndicator *indicator;
@property (nonatomic, assign) double value;
@property (nonatomic, assign) BOOL indeterminate;
@property (nonatomic, assign) BOOL spinning;
@end

@implementation RCTNativeProgressView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _indicator = [[NSProgressIndicator alloc] initWithFrame:self.bounds];
    _indicator.style = NSProgressIndicatorStyleBar;
    _indicator.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self addSubview:_indicator];
  }
  return self;
}

- (void)setValue:(double)value { _value = value; _indicator.doubleValue = value; }
- (void)setIndeterminate:(BOOL)indeterminate {
  _indeterminate = indeterminate;
  _indicator.indeterminate = indeterminate;
  if (indeterminate) [_indicator startAnimation:nil];
}
- (void)setSpinning:(BOOL)spinning {
  _spinning = spinning;
  _indicator.style = spinning ? NSProgressIndicatorStyleSpinning : NSProgressIndicatorStyleBar;
  if (_indeterminate) [_indicator startAnimation:nil];
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
- (void)layout {
  [super layout];
  _indicator.frame = self.bounds;
}
@end

@interface RCTNativeProgressViewManager : RCTViewManager @end
@implementation RCTNativeProgressViewManager
RCT_EXPORT_MODULE(NativeProgress)
- (NSView *)view { return [[RCTNativeProgressView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(value, double)
RCT_EXPORT_VIEW_PROPERTY(indeterminate, BOOL)
RCT_EXPORT_VIEW_PROPERTY(spinning, BOOL)
@end

// ============================================================
// 7. NSDatePicker
// ============================================================

@interface RCTNativeDatePickerView : NSView
@property (nonatomic, strong) NSDatePicker *picker;
@property (nonatomic, copy) RCTBubblingEventBlock onChange;
@property (nonatomic, assign) BOOL graphical;
@end

@implementation RCTNativeDatePickerView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _picker = [[NSDatePicker alloc] initWithFrame:self.bounds];
    _picker.datePickerStyle = NSDatePickerStyleTextField;
    _picker.datePickerElements = NSDatePickerElementFlagYearMonthDay;
    _picker.dateValue = [NSDate date];
    _picker.target = self;
    _picker.action = @selector(handleChange);
    _picker.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self addSubview:_picker];
  }
  return self;
}

- (void)handleChange {
  NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
  fmt.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
  if (_onChange) _onChange(@{@"date": [fmt stringFromDate:_picker.dateValue]});
}

- (void)setGraphical:(BOOL)graphical {
  _graphical = graphical;
  _picker.datePickerStyle = graphical ? NSDatePickerStyleClockAndCalendar : NSDatePickerStyleTextField;
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
- (void)layout {
  [super layout];
  _picker.frame = self.bounds;
}
@end

@interface RCTNativeDatePickerViewManager : RCTViewManager @end
@implementation RCTNativeDatePickerViewManager
RCT_EXPORT_MODULE(NativeDatePicker)
- (NSView *)view { return [[RCTNativeDatePickerView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(graphical, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onChange, RCTBubblingEventBlock)
@end

// ============================================================
// 8. NSColorWell
// ============================================================

@interface RCTNativeColorWellView : NSView
@property (nonatomic, strong) NSColorWell *colorWell;
@property (nonatomic, copy) RCTBubblingEventBlock onChange;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, assign) BOOL minimal;
@end

@implementation RCTNativeColorWellView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _colorWell = [[NSColorWell alloc] initWithFrame:self.bounds];
    _colorWell.color = [NSColor controlAccentColor];
    _colorWell.target = self;
    _colorWell.action = @selector(handleChange);
    _colorWell.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self addSubview:_colorWell];
  }
  return self;
}

- (void)handleChange {
  NSColor *c = [_colorWell.color colorUsingColorSpace:[NSColorSpace sRGBColorSpace]];
  if (c && _onChange) {
    NSString *hex = [NSString stringWithFormat:@"#%02X%02X%02X",
                     (int)(c.redComponent * 255), (int)(c.greenComponent * 255), (int)(c.blueComponent * 255)];
    _onChange(@{@"color": hex});
  }
}

- (void)setMinimal:(BOOL)minimal {
  _minimal = minimal;
  if (@available(macOS 13.0, *)) {
    _colorWell.colorWellStyle = minimal ? NSColorWellStyleMinimal : NSColorWellStyleDefault;
  }
}

- (void)setColor:(NSString *)color {
  _color = color;
  if (color.length == 7 && [color hasPrefix:@"#"]) {
    unsigned int hex;
    [[NSScanner scannerWithString:[color substringFromIndex:1]] scanHexInt:&hex];
    _colorWell.color = [NSColor colorWithSRGBRed:((hex >> 16) & 0xFF) / 255.0
                                           green:((hex >> 8) & 0xFF) / 255.0
                                            blue:(hex & 0xFF) / 255.0
                                           alpha:1.0];
  }
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
- (void)layout {
  [super layout];
  _colorWell.frame = self.bounds;
}
@end

@interface RCTNativeColorWellViewManager : RCTViewManager @end
@implementation RCTNativeColorWellViewManager
RCT_EXPORT_MODULE(NativeColorWell)
- (NSView *)view { return [[RCTNativeColorWellView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(color, NSString)
RCT_EXPORT_VIEW_PROPERTY(minimal, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onChange, RCTBubblingEventBlock)
@end

// ============================================================
// 9. NSPopUpButton
// ============================================================

@interface RCTNativePopUpView : NSView
@property (nonatomic, strong) NSPopUpButton *popUp;
@property (nonatomic, copy) RCTBubblingEventBlock onChange;
@property (nonatomic, copy) NSArray<NSString *> *items;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation RCTNativePopUpView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _popUp = [[NSPopUpButton alloc] initWithFrame:self.bounds pullsDown:NO];
    _popUp.target = self;
    _popUp.action = @selector(handleChange);
    _popUp.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self addSubview:_popUp];
  }
  return self;
}

- (void)handleChange {
  if (_onChange) _onChange(@{@"selectedIndex": @(_popUp.indexOfSelectedItem), @"title": _popUp.titleOfSelectedItem ?: @""});
}

- (void)setItems:(NSArray<NSString *> *)items {
  _items = items;
  [_popUp removeAllItems];
  [_popUp addItemsWithTitles:items];
  if (_selectedIndex < (NSInteger)items.count) [_popUp selectItemAtIndex:_selectedIndex];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
  _selectedIndex = selectedIndex;
  if (selectedIndex < _popUp.numberOfItems) [_popUp selectItemAtIndex:selectedIndex];
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
- (void)layout {
  [super layout];
  _popUp.frame = self.bounds;
}
@end

@interface RCTNativePopUpViewManager : RCTViewManager @end
@implementation RCTNativePopUpViewManager
RCT_EXPORT_MODULE(NativePopUp)
- (NSView *)view { return [[RCTNativePopUpView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(items, NSArray)
RCT_EXPORT_VIEW_PROPERTY(selectedIndex, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(onChange, RCTBubblingEventBlock)
@end

// ============================================================
// 10. NSTextView (rich text editor)
// ============================================================

@interface RCTNativeTextEditorView : NSView
@property (nonatomic, strong) NSScrollView *scrollView;
@property (nonatomic, strong) NSTextView *textView;
@property (nonatomic, copy) RCTBubblingEventBlock onChangeText;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) BOOL richText;
@property (nonatomic, assign) BOOL showsRuler;
@end

@implementation RCTNativeTextEditorView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _scrollView = [[NSScrollView alloc] initWithFrame:self.bounds];
    _scrollView.hasVerticalScroller = YES;
    _scrollView.drawsBackground = NO;
    _scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;

    _textView = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, 500, 400)];
    _textView.minSize = NSMakeSize(0, 0);
    _textView.maxSize = NSMakeSize(FLT_MAX, FLT_MAX);
    _textView.verticallyResizable = YES;
    _textView.horizontallyResizable = NO;
    _textView.autoresizingMask = NSViewWidthSizable;
    _textView.textContainer.containerSize = NSMakeSize(FLT_MAX, FLT_MAX);
    _textView.textContainer.widthTracksTextView = YES;
    _textView.allowsUndo = YES;
    _textView.richText = YES;
    _textView.usesFontPanel = YES;
    _textView.font = [NSFont systemFontOfSize:14];

    _scrollView.documentView = _textView;
    [self addSubview:_scrollView];
  }
  return self;
}

- (void)setText:(NSString *)text {
  _text = text;
  _textView.string = text ?: @"";
}

- (void)setRichText:(BOOL)richText {
  _richText = richText;
  _textView.richText = richText;
}

- (void)setShowsRuler:(BOOL)showsRuler {
  _showsRuler = showsRuler;
  _textView.usesRuler = showsRuler;
  _scrollView.rulersVisible = showsRuler;
  _scrollView.hasHorizontalRuler = showsRuler;
}

- (BOOL)wantsUpdateLayer { return YES; }
- (void)updateLayer {
  self.layer.backgroundColor = [NSColor controlBackgroundColor].CGColor;
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
- (void)layout {
  [super layout];
  _scrollView.frame = self.bounds;
}
@end

@interface RCTNativeTextEditorViewManager : RCTViewManager @end
@implementation RCTNativeTextEditorViewManager
RCT_EXPORT_MODULE(NativeTextEditor)
- (NSView *)view { return [[RCTNativeTextEditorView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(text, NSString)
RCT_EXPORT_VIEW_PROPERTY(richText, BOOL)
RCT_EXPORT_VIEW_PROPERTY(showsRuler, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onChangeText, RCTBubblingEventBlock)
@end

// ============================================================
// 11. WKWebView
// ============================================================

@interface RCTNativeWebViewView : NSView <WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) RCTBubblingEventBlock onNavigate;
@property (nonatomic, copy) RCTBubblingEventBlock onFinishLoad;
@property (nonatomic, copy) NSString *url;
@end

@implementation RCTNativeWebViewView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    _webView = [[WKWebView alloc] initWithFrame:self.bounds configuration:config];
    _webView.navigationDelegate = self;
    _webView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    _webView.allowsBackForwardNavigationGestures = YES;
    [self addSubview:_webView];
  }
  return self;
}

- (void)setUrl:(NSString *)url {
  _url = url;
  if (url.length > 0) {
    NSURL *nsurl = [NSURL URLWithString:url];
    if (nsurl) [_webView loadRequest:[NSURLRequest requestWithURL:nsurl]];
  }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
  if (_onFinishLoad) _onFinishLoad(@{@"url": webView.URL.absoluteString ?: @"", @"title": webView.title ?: @""});
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
  if (_onNavigate) _onNavigate(@{@"url": navigationAction.request.URL.absoluteString ?: @""});
  decisionHandler(WKNavigationActionPolicyAllow);
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
- (void)layout {
  [super layout];
  _webView.frame = self.bounds;
}
@end

@interface RCTNativeWebViewViewManager : RCTViewManager @end
@implementation RCTNativeWebViewViewManager
RCT_EXPORT_MODULE(NativeWebView)
- (NSView *)view { return [[RCTNativeWebViewView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(url, NSString)
RCT_EXPORT_VIEW_PROPERTY(onNavigate, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onFinishLoad, RCTBubblingEventBlock)
@end

// ============================================================
// 12. NSLevelIndicator
// ============================================================

@interface RCTNativeLevelIndicatorView : NSView
@property (nonatomic, strong) NSLevelIndicator *indicator;
@property (nonatomic, assign) double value;
@property (nonatomic, assign) double minValue;
@property (nonatomic, assign) double maxValue;
@property (nonatomic, assign) double warningValue;
@property (nonatomic, assign) double criticalValue;
@end

@implementation RCTNativeLevelIndicatorView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _indicator = [[NSLevelIndicator alloc] initWithFrame:self.bounds];
    _indicator.maxValue = 10;
    _indicator.warningValue = 6;
    _indicator.criticalValue = 2;
    _indicator.doubleValue = 7;
    _indicator.levelIndicatorStyle = NSLevelIndicatorStyleContinuousCapacity;
    _indicator.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self addSubview:_indicator];
  }
  return self;
}

- (void)setValue:(double)value { _value = value; _indicator.doubleValue = value; }
- (void)setMinValue:(double)v { _minValue = v; _indicator.minValue = v; }
- (void)setMaxValue:(double)v { _maxValue = v; _indicator.maxValue = v; }
- (void)setWarningValue:(double)v { _warningValue = v; _indicator.warningValue = v; }
- (void)setCriticalValue:(double)v { _criticalValue = v; _indicator.criticalValue = v; }

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
- (void)layout {
  [super layout];
  _indicator.frame = self.bounds;
}
@end

@interface RCTNativeLevelIndicatorViewManager : RCTViewManager @end
@implementation RCTNativeLevelIndicatorViewManager
RCT_EXPORT_MODULE(NativeLevelIndicator)
- (NSView *)view { return [[RCTNativeLevelIndicatorView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(value, double)
RCT_EXPORT_VIEW_PROPERTY(minValue, double)
RCT_EXPORT_VIEW_PROPERTY(maxValue, double)
RCT_EXPORT_VIEW_PROPERTY(warningValue, double)
RCT_EXPORT_VIEW_PROPERTY(criticalValue, double)
@end

// ============================================================
// 13. NSScrollView (container for RN children)
// ============================================================

@interface RCTFlippedDocumentView : NSView
@end
@implementation RCTFlippedDocumentView
- (BOOL)isFlipped { return YES; }
@end

@interface RCTNativeScrollView : NSScrollView
@property (nonatomic, strong) RCTFlippedDocumentView *docView;
@property (nonatomic, assign) NSInteger scrollToBottom;
@property (nonatomic, assign) CGFloat scrollToY;
@property (nonatomic, assign) NSInteger scrollToYTrigger;
@end

@implementation RCTNativeScrollView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _docView = [[RCTFlippedDocumentView alloc] initWithFrame:frame];
    self.documentView = _docView;
    self.hasVerticalScroller = YES;
    self.hasHorizontalScroller = NO;
    self.autohidesScrollers = YES;
    self.drawsBackground = NO;
  }
  return self;
}

- (void)insertReactSubview:(NSView *)subview atIndex:(NSInteger)atIndex {
  [_docView addSubview:subview];
}

- (void)removeReactSubview:(NSView *)subview {
  [subview removeFromSuperview];
}

- (NSArray<NSView *> *)reactSubviews {
  return _docView.subviews;
}

- (void)didUpdateReactSubviews {
  // Called by RN after laying out subviews — schedule a
  // size update on the next run loop so frames are final.
  [self performSelector:@selector(updateDocumentSize) withObject:nil afterDelay:0];
}

- (void)reactSetFrame:(CGRect)frame {
  [super reactSetFrame:frame];
  [self performSelector:@selector(updateDocumentSize) withObject:nil afterDelay:0];
}

- (void)updateDocumentSize {
  CGFloat maxY = 0;
  for (NSView *child in _docView.subviews) {
    CGFloat bottom = CGRectGetMaxY(child.frame);
    if (bottom > maxY) maxY = bottom;
  }
  CGFloat w = self.bounds.size.width;
  if (w <= 0) w = self.frame.size.width;
  CGSize newSize = NSMakeSize(w, MAX(maxY, self.bounds.size.height));
  if (!CGSizeEqualToSize(_docView.frame.size, newSize)) {
    _docView.frame = NSMakeRect(0, 0, newSize.width, newSize.height);
  }
}

- (void)setScrollToBottom:(NSInteger)scrollToBottom {
  if (scrollToBottom == _scrollToBottom) return;
  _scrollToBottom = scrollToBottom;
  [self performSelector:@selector(doScrollToBottom) withObject:nil afterDelay:0.05];
}

- (void)doScrollToBottom {
  [self updateDocumentSize];
  NSPoint bottomPoint = NSMakePoint(0, _docView.frame.size.height - self.bounds.size.height);
  if (bottomPoint.y > 0) {
    [self.contentView scrollToPoint:bottomPoint];
    [self reflectScrolledClipView:self.contentView];
  }
}

- (void)setScrollToYTrigger:(NSInteger)scrollToYTrigger {
  if (scrollToYTrigger == _scrollToYTrigger) return;
  _scrollToYTrigger = scrollToYTrigger;
  [self performSelector:@selector(doScrollToY) withObject:nil afterDelay:0.1];
}

- (void)setScrollToY:(CGFloat)scrollToY {
  _scrollToY = scrollToY;
}

- (void)doScrollToY {
  [self updateDocumentSize];
  CGFloat maxScroll = _docView.frame.size.height - self.bounds.size.height;
  CGFloat y = MIN(MAX(_scrollToY, 0), maxScroll);
  [NSAnimationContext runAnimationGroup:^(NSAnimationContext *ctx) {
    ctx.duration = 0.3;
    ctx.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.contentView.animator setBoundsOrigin:NSMakePoint(0, y)];
  } completionHandler:^{
    [self reflectScrolledClipView:self.contentView];
  }];
}

- (void)layout {
  [super layout];
  [self updateDocumentSize];
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
@end

@interface RCTNativeScrollViewManager : RCTViewManager @end
@implementation RCTNativeScrollViewManager
RCT_EXPORT_MODULE(MacOSScrollView)
- (NSView *)view { return [[RCTNativeScrollView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(scrollToBottom, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(scrollToY, double)
RCT_EXPORT_VIEW_PROPERTY(scrollToYTrigger, NSInteger)
@end

// ============================================================
// 14. RiveView
// ============================================================

@interface RCTNativeRiveView : NSView
@property (nonatomic, strong) RiveViewModel *viewModel;
@property (nonatomic, strong) RiveView *riveView;
@property (nonatomic, strong) id mouseMonitor;
@property (nonatomic, copy) NSString *resourceName;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *stateMachineName;
@property (nonatomic, copy) NSString *artboardName;
@property (nonatomic, copy) NSString *fit;
@property (nonatomic, assign) BOOL autoplay;
@end

@implementation RCTNativeRiveView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _autoplay = YES;
    _fit = @"contain";
  }
  return self;
}

- (enum RiveFit)parseFit {
  if ([_fit isEqualToString:@"cover"]) return cover;
  if ([_fit isEqualToString:@"fill"]) return fill;
  if ([_fit isEqualToString:@"fitWidth"]) return fitWidth;
  if ([_fit isEqualToString:@"fitHeight"]) return fitHeight;
  if ([_fit isEqualToString:@"scaleDown"]) return scaleDown;
  if ([_fit isEqualToString:@"noFit"]) return noFit;
  return contain;
}

- (void)setResourceName:(NSString *)resourceName {
  if ([_resourceName isEqualToString:resourceName]) return;
  _resourceName = resourceName;
  [self loadFromResource];
}

- (void)setUrl:(NSString *)url {
  if ([_url isEqualToString:url]) return;
  _url = url;
  [self loadFromURL];
}

- (void)loadFromResource {
  if (_resourceName.length == 0) return;
  [self clearRiveView];
  NSString *name = [_resourceName copy];
  NSString *sm = [_stateMachineName copy];
  NSString *ab = [_artboardName copy];
  enum RiveFit f = [self parseFit];
  BOOL ap = _autoplay;
  __weak typeof(self) weakSelf = self;
  dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
    RiveViewModel *vm = [[RiveViewModel alloc]
      initWithFileName:name
             extension:@"riv"
                    in:[NSBundle mainBundle]
      stateMachineName:sm
                   fit:f
             alignment:center
              autoPlay:ap
         artboardName:ab
               loadCdn:YES
          customLoader:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
      __strong typeof(weakSelf) strongSelf = weakSelf;
      if (!strongSelf) return;
      strongSelf.viewModel = vm;
      [strongSelf attachRiveView];
    });
  });
}

- (void)loadFromURL {
  if (_url.length == 0) return;
  [self clearRiveView];
  NSString *u = [_url copy];
  NSString *sm = [_stateMachineName copy];
  NSString *ab = [_artboardName copy];
  enum RiveFit f = [self parseFit];
  BOOL ap = _autoplay;
  __weak typeof(self) weakSelf = self;
  dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
    RiveViewModel *vm = [[RiveViewModel alloc]
      initWithWebURL:u
    stateMachineName:sm
                 fit:f
           alignment:center
            autoPlay:ap
             loadCdn:YES
        artboardName:ab];
    dispatch_async(dispatch_get_main_queue(), ^{
      __strong typeof(weakSelf) strongSelf = weakSelf;
      if (!strongSelf) return;
      strongSelf.viewModel = vm;
      [strongSelf attachRiveView];
    });
  });
}

- (void)clearRiveView {
  if (_mouseMonitor) {
    [NSEvent removeMonitor:_mouseMonitor];
    _mouseMonitor = nil;
  }
  if (_riveView) {
    [_riveView removeFromSuperview];
    _riveView = nil;
  }
  _viewModel = nil;
}

- (void)attachRiveView {
  if (!_viewModel) return;
  _riveView = [_viewModel createRiveView];
  _riveView.frame = self.bounds;
  _riveView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
  [self addSubview:_riveView];
  [self installMouseMonitor];
}

- (void)installMouseMonitor {
  if (_mouseMonitor) return;
  __weak typeof(self) weakSelf = self;
  _mouseMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskMouseMoved handler:^NSEvent *(NSEvent *event) {
    __strong typeof(weakSelf) strongSelf = weakSelf;
    if (!strongSelf || !strongSelf.riveView) return event;
    [strongSelf.riveView mouseMoved:event];
    return event;
  }];
}

- (void)dealloc {
  if (_mouseMonitor) {
    [NSEvent removeMonitor:_mouseMonitor];
    _mouseMonitor = nil;
  }
  [self clearRiveView];
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
- (void)layout {
  [super layout];
  _riveView.frame = self.bounds;
}
@end

@interface RCTNativeRiveViewManager : RCTViewManager @end
@implementation RCTNativeRiveViewManager
RCT_EXPORT_MODULE(MacOSRiveView)
- (NSView *)view { return [[RCTNativeRiveView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(resourceName, NSString)
RCT_EXPORT_VIEW_PROPERTY(url, NSString)
RCT_EXPORT_VIEW_PROPERTY(stateMachineName, NSString)
RCT_EXPORT_VIEW_PROPERTY(artboardName, NSString)
RCT_EXPORT_VIEW_PROPERTY(autoplay, BOOL)
RCT_EXPORT_VIEW_PROPERTY(fit, NSString)
@end

// 15. VisualEffectView
// ============================================================

@interface RCTVisualEffectView : NSVisualEffectView
@property (nonatomic, copy) NSString *materialName;
@property (nonatomic, copy) NSString *blendingModeName;
@property (nonatomic, copy) NSString *stateName;
@end

@implementation RCTVisualEffectView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.material = NSVisualEffectMaterialWindowBackground;
    self.blendingMode = NSVisualEffectBlendingModeBehindWindow;
    self.state = NSVisualEffectStateActive;
    self.wantsLayer = YES;
  }
  return self;
}

- (void)setMaterialName:(NSString *)materialName {
  _materialName = materialName;
  if ([materialName isEqualToString:@"sidebar"])           self.material = NSVisualEffectMaterialSidebar;
  else if ([materialName isEqualToString:@"headerView"])   self.material = NSVisualEffectMaterialHeaderView;
  else if ([materialName isEqualToString:@"titlebar"])     self.material = NSVisualEffectMaterialTitlebar;
  else if ([materialName isEqualToString:@"hudWindow"])    self.material = NSVisualEffectMaterialHUDWindow;
  else if ([materialName isEqualToString:@"contentBackground"]) self.material = NSVisualEffectMaterialContentBackground;
  else if ([materialName isEqualToString:@"menu"])         self.material = NSVisualEffectMaterialMenu;
  else if ([materialName isEqualToString:@"popover"])      self.material = NSVisualEffectMaterialPopover;
  else if ([materialName isEqualToString:@"sheet"])        self.material = NSVisualEffectMaterialSheet;
  else if ([materialName isEqualToString:@"underWindowBackground"]) self.material = NSVisualEffectMaterialUnderWindowBackground;
  else self.material = NSVisualEffectMaterialWindowBackground;
}

- (void)setBlendingModeName:(NSString *)blendingModeName {
  _blendingModeName = blendingModeName;
  if ([blendingModeName isEqualToString:@"withinWindow"]) self.blendingMode = NSVisualEffectBlendingModeWithinWindow;
  else self.blendingMode = NSVisualEffectBlendingModeBehindWindow;
}

- (void)setStateName:(NSString *)stateName {
  _stateName = stateName;
  if ([stateName isEqualToString:@"inactive"])       self.state = NSVisualEffectStateInactive;
  else if ([stateName isEqualToString:@"followsWindow"]) self.state = NSVisualEffectStateFollowsWindowActiveState;
  else self.state = NSVisualEffectStateActive;
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
@end

@interface RCTVisualEffectViewManager : RCTViewManager @end
@implementation RCTVisualEffectViewManager
RCT_EXPORT_MODULE(MacOSVisualEffectView)
- (NSView *)view { return [[RCTVisualEffectView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(materialName, NSString)
RCT_EXPORT_VIEW_PROPERTY(blendingModeName, NSString)
RCT_EXPORT_VIEW_PROPERTY(stateName, NSString)
@end

// 16. Toolbar
// ============================================================

@interface RCTToolbarView : NSView <NSToolbarDelegate>
@property (nonatomic, strong) NSToolbar *toolbar;
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, copy) NSString *selectedItem;
@property (nonatomic, copy) NSString *toolbarStyle;
@property (nonatomic, copy) NSString *windowTitle;
@property (nonatomic, copy) RCTBubblingEventBlock onSelectItem;
@end

@implementation RCTToolbarView

- (void)setItems:(NSArray *)items {
  _items = items;
  [self rebuildToolbar];
}

- (void)setSelectedItem:(NSString *)selectedItem {
  if ([_selectedItem isEqualToString:selectedItem]) return;
  _selectedItem = selectedItem;
  if (_toolbar) _toolbar.selectedItemIdentifier = selectedItem;
}

- (void)setToolbarStyle:(NSString *)toolbarStyle {
  _toolbarStyle = toolbarStyle;
  if (self.window) [self applyToolbarStyle];
}

- (void)setWindowTitle:(NSString *)windowTitle {
  _windowTitle = windowTitle;
  if (self.window) self.window.title = windowTitle ?: @"";
}

- (void)viewDidMoveToWindow {
  [super viewDidMoveToWindow];
  if (self.window) {
    [self rebuildToolbar];
  }
}

- (void)rebuildToolbar {
  if (!self.window || !_items || _items.count == 0) return;
  _toolbar = [[NSToolbar alloc] initWithIdentifier:@"MacOSToolbar"];
  _toolbar.delegate = self;
  _toolbar.displayMode = NSToolbarDisplayModeIconAndLabel;
  _toolbar.allowsUserCustomization = NO;
  if (_selectedItem) _toolbar.selectedItemIdentifier = _selectedItem;
  self.window.toolbar = _toolbar;
  [self applyToolbarStyle];
  if (_windowTitle) self.window.title = _windowTitle;
}

- (void)applyToolbarStyle {
  if (!self.window) return;
  NSString *s = _toolbarStyle ?: @"unified";
  if ([s isEqualToString:@"expanded"])       self.window.toolbarStyle = NSWindowToolbarStyleExpanded;
  else if ([s isEqualToString:@"preference"]) self.window.toolbarStyle = NSWindowToolbarStylePreference;
  else if ([s isEqualToString:@"unifiedCompact"]) self.window.toolbarStyle = NSWindowToolbarStyleUnifiedCompact;
  else self.window.toolbarStyle = NSWindowToolbarStyleUnified;
}

- (void)handleItemClick:(NSToolbarItem *)sender {
  if (_selectedItem && [_selectedItem isEqualToString:sender.itemIdentifier]) return;
  _selectedItem = sender.itemIdentifier;
  _toolbar.selectedItemIdentifier = _selectedItem;
  if (_onSelectItem) _onSelectItem(@{@"itemId": sender.itemIdentifier});
}

// NSToolbarDelegate
- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
  NSMutableArray *ids = [NSMutableArray new];
  for (NSDictionary *item in _items) [ids addObject:item[@"id"]];
  return ids;
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
  NSMutableArray *ids = [NSMutableArray new];
  for (NSDictionary *item in _items) [ids addObject:item[@"id"]];
  return ids;
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar {
  NSMutableArray *ids = [NSMutableArray new];
  for (NSDictionary *item in _items) [ids addObject:item[@"id"]];
  return ids;
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
  NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
  for (NSDictionary *d in _items) {
    if ([d[@"id"] isEqualToString:itemIdentifier]) {
      item.label = d[@"label"] ?: itemIdentifier;
      NSString *sfSymbol = d[@"sfSymbol"];
      if (sfSymbol) item.image = [NSImage imageWithSystemSymbolName:sfSymbol accessibilityDescription:item.label];
      break;
    }
  }
  item.target = self;
  item.action = @selector(handleItemClick:);
  return item;
}

- (void)removeFromSuperview {
  if (self.window.toolbar == _toolbar) self.window.toolbar = nil;
  [super removeFromSuperview];
}

- (void)dealloc {
  if (self.window.toolbar == _toolbar) self.window.toolbar = nil;
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
@end

@interface RCTToolbarViewManager : RCTViewManager @end
@implementation RCTToolbarViewManager
RCT_EXPORT_MODULE(MacOSToolbar)
- (NSView *)view { return [[RCTToolbarView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(items, NSArray)
RCT_EXPORT_VIEW_PROPERTY(selectedItem, NSString)
RCT_EXPORT_VIEW_PROPERTY(toolbarStyle, NSString)
RCT_EXPORT_VIEW_PROPERTY(windowTitle, NSString)
RCT_EXPORT_VIEW_PROPERTY(onSelectItem, RCTBubblingEventBlock)
@end

// ============================================================
// 17. Context Menu
// ============================================================

@interface RCTContextMenuView : NSView
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, copy) RCTBubblingEventBlock onSelectItem;
@end

@implementation RCTContextMenuView

- (NSMenu *)menuForEvent:(NSEvent *)event {
  if (!_items || _items.count == 0) return [super menuForEvent:event];
  NSMenu *menu = [[NSMenu alloc] initWithTitle:@""];
  for (NSDictionary *item in _items) {
    NSString *title = item[@"title"] ?: @"";
    if ([title isEqualToString:@"-"]) {
      [menu addItem:[NSMenuItem separatorItem]];
      continue;
    }
    NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:title action:@selector(handleMenuAction:) keyEquivalent:@""];
    menuItem.target = self;
    menuItem.representedObject = item[@"id"] ?: @"";
    NSString *sfSymbol = item[@"sfSymbol"];
    if (sfSymbol.length > 0) {
      NSImage *img = [NSImage imageWithSystemSymbolName:sfSymbol accessibilityDescription:title];
      if (img) menuItem.image = img;
    }
    [menu addItem:menuItem];
  }
  return menu;
}

- (void)handleMenuAction:(NSMenuItem *)sender {
  if (_onSelectItem) _onSelectItem(@{@"itemId": sender.representedObject ?: @""});
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
@end

@interface RCTContextMenuViewManager : RCTViewManager @end
@implementation RCTContextMenuViewManager
RCT_EXPORT_MODULE(MacOSContextMenu)
- (NSView *)view { return [[RCTContextMenuView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(items, NSArray)
RCT_EXPORT_VIEW_PROPERTY(onSelectItem, RCTBubblingEventBlock)
@end

// ============================================================
// 18. Drop Zone
// ============================================================

@interface RCTDropZoneView : NSView
@property (nonatomic, copy) RCTBubblingEventBlock onFileDrop;
@property (nonatomic, copy) RCTBubblingEventBlock onFilesDragEnter;
@property (nonatomic, copy) RCTBubblingEventBlock onFilesDragExit;
@end

@implementation RCTDropZoneView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self registerForDraggedTypes:@[NSPasteboardTypeFileURL, NSPasteboardTypeString]];
  }
  return self;
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
  if (_onFilesDragEnter) _onFilesDragEnter(@{});
  return NSDragOperationCopy;
}

- (void)draggingExited:(id<NSDraggingInfo>)sender {
  if (_onFilesDragExit) _onFilesDragExit(@{});
}

- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender {
  return YES;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
  NSPasteboard *pboard = [sender draggingPasteboard];
  NSMutableArray *files = [NSMutableArray new];
  NSMutableArray *strings = [NSMutableArray new];

  NSArray<NSURL *> *urls = [pboard readObjectsForClasses:@[[NSURL class]] options:@{NSPasteboardURLReadingFileURLsOnlyKey: @YES}];
  for (NSURL *url in urls) {
    [files addObject:@{
      @"path": url.path ?: @"",
      @"name": url.lastPathComponent ?: @""
    }];
  }

  NSArray<NSString *> *strs = [pboard readObjectsForClasses:@[[NSString class]] options:nil];
  for (NSString *s in strs) {
    [strings addObject:s];
  }

  if (_onFileDrop) _onFileDrop(@{@"files": files, @"strings": strings});
  if (_onFilesDragExit) _onFilesDragExit(@{});
  return YES;
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
@end

@interface RCTDropZoneViewManager : RCTViewManager @end
@implementation RCTDropZoneViewManager
RCT_EXPORT_MODULE(MacOSDropZone)
- (NSView *)view { return [[RCTDropZoneView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(onFileDrop, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onFilesDragEnter, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onFilesDragExit, RCTBubblingEventBlock)
@end

// ============================================================
// 19. File Picker
// ============================================================

@interface RCTFilePickerView : NSView
@property (nonatomic, strong) NSButton *button;
@property (nonatomic, copy) NSString *mode;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *sfSymbol;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *defaultName;
@property (nonatomic, copy) NSArray<NSString *> *allowedTypes;
@property (nonatomic, assign) BOOL allowMultiple;
@property (nonatomic, assign) BOOL canChooseDirectories;
@property (nonatomic, copy) RCTBubblingEventBlock onPickFiles;
@property (nonatomic, copy) RCTBubblingEventBlock onCancel;
@end

@implementation RCTFilePickerView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _button = [NSButton buttonWithTitle:@"Choose File..." target:self action:@selector(handlePress)];
    _button.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    _button.bezelStyle = NSBezelStylePush;
    _mode = @"open";
    [self addSubview:_button];
  }
  return self;
}

- (void)setTitle:(NSString *)title {
  _title = title;
  _button.title = title ?: @"Choose File...";
}

- (void)setSfSymbol:(NSString *)sfSymbol {
  _sfSymbol = sfSymbol;
  if (sfSymbol.length > 0) {
    NSImage *img = [NSImage imageWithSystemSymbolName:sfSymbol accessibilityDescription:sfSymbol];
    if (img) _button.image = img;
  }
}

- (NSArray<UTType *> *)resolvedContentTypes {
  if (!_allowedTypes || _allowedTypes.count == 0) return nil;
  NSMutableArray<UTType *> *types = [NSMutableArray new];
  for (NSString *t in _allowedTypes) {
    UTType *ut = [UTType typeWithIdentifier:t];
    if (!ut) ut = [UTType typeWithFilenameExtension:t];
    if (ut) [types addObject:ut];
  }
  return types.count > 0 ? types : nil;
}

- (void)handlePress {
  if (!self.window) return;

  if ([_mode isEqualToString:@"save"]) {
    NSSavePanel *panel = [NSSavePanel savePanel];
    if (_message) panel.message = _message;
    if (_defaultName) panel.nameFieldStringValue = _defaultName;
    NSArray<UTType *> *types = [self resolvedContentTypes];
    if (types) panel.allowedContentTypes = types;
    panel.canCreateDirectories = YES;
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse result) {
      if (result == NSModalResponseOK && panel.URL) {
        if (self.onPickFiles) self.onPickFiles(@{
          @"files": @[@{@"path": panel.URL.path ?: @"", @"name": panel.URL.lastPathComponent ?: @""}]
        });
      } else {
        if (self.onCancel) self.onCancel(@{});
      }
    }];
  } else {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.canChooseFiles = !_canChooseDirectories;
    panel.canChooseDirectories = _canChooseDirectories;
    panel.allowsMultipleSelection = _allowMultiple;
    if (_message) panel.message = _message;
    NSArray<UTType *> *types = [self resolvedContentTypes];
    if (types) panel.allowedContentTypes = types;
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse result) {
      if (result == NSModalResponseOK) {
        NSMutableArray *files = [NSMutableArray new];
        for (NSURL *url in panel.URLs) {
          [files addObject:@{@"path": url.path ?: @"", @"name": url.lastPathComponent ?: @""}];
        }
        if (self.onPickFiles) self.onPickFiles(@{@"files": files});
      } else {
        if (self.onCancel) self.onCancel(@{});
      }
    }];
  }
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
- (void)layout {
  [super layout];
  _button.frame = self.bounds;
}
@end

@interface RCTFilePickerViewManager : RCTViewManager @end
@implementation RCTFilePickerViewManager
RCT_EXPORT_MODULE(MacOSFilePicker)
- (NSView *)view { return [[RCTFilePickerView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(mode, NSString)
RCT_EXPORT_VIEW_PROPERTY(title, NSString)
RCT_EXPORT_VIEW_PROPERTY(sfSymbol, NSString)
RCT_EXPORT_VIEW_PROPERTY(message, NSString)
RCT_EXPORT_VIEW_PROPERTY(defaultName, NSString)
RCT_EXPORT_VIEW_PROPERTY(allowedTypes, NSArray)
RCT_EXPORT_VIEW_PROPERTY(allowMultiple, BOOL)
RCT_EXPORT_VIEW_PROPERTY(canChooseDirectories, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onPickFiles, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onCancel, RCTBubblingEventBlock)
@end

// ============================================================
// 20. AVPlayerView (video player)
// ============================================================

@interface RCTVideoPlayerView : NSView
@property (nonatomic, strong) AVPlayerView *playerView;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, assign) BOOL playing;
@property (nonatomic, assign) BOOL looping;
@property (nonatomic, assign) BOOL muted;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, copy) NSString *controlsStyle;
@end

@implementation RCTVideoPlayerView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.wantsLayer = YES;
    self.layer.masksToBounds = YES;
    _player = [[AVPlayer alloc] init];
    _playerView = [[AVPlayerView alloc] initWithFrame:self.bounds];
    _playerView.player = _player;
    _playerView.controlsStyle = AVPlayerViewControlsStyleFloating;
    _playerView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self addSubview:_playerView];
    [[NSNotificationCenter defaultCenter] addObserver:self
      selector:@selector(playerDidFinish:)
      name:AVPlayerItemDidPlayToEndTimeNotification
      object:nil];
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setSource:(NSString *)source {
  if ([_source isEqualToString:source]) return;
  _source = [source copy];
  NSURL *url;
  if ([source hasPrefix:@"http://"] || [source hasPrefix:@"https://"]) {
    url = [NSURL URLWithString:source];
  } else {
    url = [NSURL fileURLWithPath:source];
  }
  AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
  [_player replaceCurrentItemWithPlayerItem:item];
  if (_playing) [_player play];
}

- (void)setPlaying:(BOOL)playing {
  _playing = playing;
  if (playing) [_player play]; else [_player pause];
}

- (void)setLooping:(BOOL)looping {
  _looping = looping;
}

- (void)setMuted:(BOOL)muted {
  _muted = muted;
  _player.muted = muted;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
  _cornerRadius = cornerRadius;
  self.layer.cornerRadius = cornerRadius;
}

- (void)setControlsStyle:(NSString *)controlsStyle {
  _controlsStyle = controlsStyle;
  if ([controlsStyle isEqualToString:@"none"]) _playerView.controlsStyle = AVPlayerViewControlsStyleNone;
  else if ([controlsStyle isEqualToString:@"inline"]) _playerView.controlsStyle = AVPlayerViewControlsStyleInline;
  else if ([controlsStyle isEqualToString:@"minimal"]) _playerView.controlsStyle = AVPlayerViewControlsStyleMinimal;
  else if ([controlsStyle isEqualToString:@"floating"]) _playerView.controlsStyle = AVPlayerViewControlsStyleFloating;
  else _playerView.controlsStyle = AVPlayerViewControlsStyleDefault;
}

- (void)playerDidFinish:(NSNotification *)note {
  if (_looping && note.object == _player.currentItem) {
    [_player seekToTime:kCMTimeZero];
    [_player play];
  }
}

- (void)scrollWheel:(NSEvent *)event {
  [self.nextResponder scrollWheel:event];
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
- (void)layout {
  [super layout];
  _playerView.frame = self.bounds;
}
@end

@interface RCTVideoPlayerViewManager : RCTViewManager @end
@implementation RCTVideoPlayerViewManager
RCT_EXPORT_MODULE(MacOSVideoPlayer)
- (NSView *)view { return [[RCTVideoPlayerView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(source, NSString)
RCT_EXPORT_VIEW_PROPERTY(playing, BOOL)
RCT_EXPORT_VIEW_PROPERTY(looping, BOOL)
RCT_EXPORT_VIEW_PROPERTY(muted, BOOL)
RCT_EXPORT_VIEW_PROPERTY(cornerRadius, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(controlsStyle, NSString)
@end

// ===========================================================================
// MARK: - NSAlert (Native Module)
// ===========================================================================

@interface MacOSAlertModule : NSObject <RCTBridgeModule>
@end

@implementation MacOSAlertModule

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup { return NO; }

RCT_EXPORT_METHOD(show:(NSString *)style
                  title:(NSString *)title
                  message:(NSString *)message
                  buttons:(NSArray<NSString *> *)buttons
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = title ?: @"";
    alert.informativeText = message ?: @"";

    if ([style isEqualToString:@"warning"]) alert.alertStyle = NSAlertStyleWarning;
    else if ([style isEqualToString:@"critical"]) alert.alertStyle = NSAlertStyleCritical;
    else alert.alertStyle = NSAlertStyleInformational;

    for (NSString *btn in buttons) {
      [alert addButtonWithTitle:btn];
    }
    if (buttons.count == 0) [alert addButtonWithTitle:@"OK"];

    NSWindow *keyWindow = [NSApp keyWindow];
    if (keyWindow) {
      [alert beginSheetModalForWindow:keyWindow completionHandler:^(NSModalResponse response) {
        NSInteger idx = response - NSAlertFirstButtonReturn;
        resolve(@(idx));
      }];
    } else {
      NSModalResponse response = [alert runModal];
      NSInteger idx = response - NSAlertFirstButtonReturn;
      resolve(@(idx));
    }
  });
}

@end

// ============================================================
// 21. NSImageView (animated GIF / static image)
// ============================================================

@interface RCTAnimatedImageView : NSView
@property (nonatomic, strong) NSImage *image;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, assign) BOOL animating;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, strong) NSTimer *animTimer;
@property (nonatomic, assign) NSInteger currentFrame;
@property (nonatomic, assign) NSInteger frameCount;
@end

@implementation RCTAnimatedImageView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _animating = YES;
    _cornerRadius = 0;
    _currentFrame = 0;
    self.wantsLayer = YES;
    self.layer.contentsGravity = kCAGravityResizeAspect;
    self.layer.masksToBounds = YES;
  }
  return self;
}

- (BOOL)isFlipped { return YES; }

- (void)dealloc {
  [_animTimer invalidate];
}

- (void)setSource:(NSString *)source {
  if ([_source isEqualToString:source]) return;
  _source = [source copy];
  [_animTimer invalidate];
  _animTimer = nil;

  if ([source hasPrefix:@"http://"] || [source hasPrefix:@"https://"]) {
    __weak typeof(self) weakSelf = self;
    NSURL *url = [NSURL URLWithString:source];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url
      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!data || error) return;
        NSImage *image = [[NSImage alloc] initWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
          __strong typeof(weakSelf) strongSelf = weakSelf;
          if (!strongSelf || ![strongSelf->_source isEqualToString:source]) return;
          strongSelf.image = image;
          [strongSelf setupAnimation];
          [strongSelf updateLayerContents];
        });
      }];
    [task resume];
  } else {
    NSString *filePath = source;
    if (![source hasPrefix:@"/"]) {
      NSString *ext = [source pathExtension];
      NSString *name = [source stringByDeletingPathExtension];
      NSString *bundlePath = [[NSBundle mainBundle] pathForResource:name ofType:ext];
      if (bundlePath) filePath = bundlePath;
    }
    _image = [[NSImage alloc] initByReferencingFile:filePath];
    [self setupAnimation];
    [self updateLayerContents];
  }
}

- (void)setupAnimation {
  _currentFrame = 0;
  _frameCount = 0;
  for (NSImageRep *rep in [_image representations]) {
    if ([rep isKindOfClass:[NSBitmapImageRep class]]) {
      NSBitmapImageRep *bmp = (NSBitmapImageRep *)rep;
      NSNumber *count = [bmp valueForProperty:NSImageFrameCount];
      if (count && [count integerValue] > 1) {
        _frameCount = [count integerValue];
        break;
      }
    }
  }
  if (_frameCount > 1 && _animating) {
    NSBitmapImageRep *rep = (NSBitmapImageRep *)[[_image representations] firstObject];
    [rep setProperty:NSImageCurrentFrame withValue:@(0)];
    NSNumber *delay = [rep valueForProperty:NSImageCurrentFrameDuration];
    CGFloat interval = delay ? [delay doubleValue] : 0.05;
    if (interval < 0.02) interval = 0.05;
    _animTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(advanceFrame) userInfo:nil repeats:YES];
  }
}

- (void)advanceFrame {
  _currentFrame = (_currentFrame + 1) % _frameCount;
  for (NSImageRep *rep in [_image representations]) {
    if ([rep isKindOfClass:[NSBitmapImageRep class]]) {
      [(NSBitmapImageRep *)rep setProperty:NSImageCurrentFrame withValue:@(_currentFrame)];
      break;
    }
  }
  [self updateLayerContents];
}

- (void)updateLayerContents {
  if (!_image) { self.layer.contents = nil; return; }
  NSSize size = _image.size;
  if (size.width <= 0 || size.height <= 0) return;
  CGImageRef cgImage = [_image CGImageForProposedRect:NULL context:nil hints:nil];
  if (cgImage) {
    self.layer.contents = (__bridge id)cgImage;
  }
}

- (void)setAnimating:(BOOL)animating {
  _animating = animating;
  if (!animating) {
    [_animTimer invalidate];
    _animTimer = nil;
  } else if (_frameCount > 1 && !_animTimer) {
    [self setupAnimation];
  }
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
  _cornerRadius = cornerRadius;
  self.layer.cornerRadius = cornerRadius;
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
@end

@interface RCTAnimatedImageViewManager : RCTViewManager @end
@implementation RCTAnimatedImageViewManager
RCT_EXPORT_MODULE(MacOSAnimatedImage)
- (NSView *)view { return [[RCTAnimatedImageView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(source, NSString)
RCT_EXPORT_VIEW_PROPERTY(animating, BOOL)
RCT_EXPORT_VIEW_PROPERTY(cornerRadius, CGFloat)
@end

// ── Section 22: Pattern Background ──────────────────────────────────────────
// A tiled pattern background using Core Graphics — Telegram-style chat wallpaper

@interface RCTPatternBackgroundView : NSView
@property (nonatomic, copy) NSString *patternColor;
@property (nonatomic, copy) NSString *background;
@property (nonatomic, assign) CGFloat patternOpacity;
@property (nonatomic, assign) CGFloat patternScale;
@end

@implementation RCTPatternBackgroundView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _patternColor = @"#FFFFFF";
    _background = @"#17212B";
    _patternOpacity = 0.06;
    _patternScale = 1.0;
  }
  return self;
}

- (NSSize)intrinsicContentSize {
  return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric);
}

- (void)setPatternColor:(NSString *)patternColor {
  _patternColor = patternColor;
  [self setNeedsDisplay:YES];
}

- (void)setBackground:(NSString *)background {
  _background = background;
  [self setNeedsDisplay:YES];
}

- (void)setPatternOpacity:(CGFloat)patternOpacity {
  _patternOpacity = patternOpacity;
  [self setNeedsDisplay:YES];
}

- (void)setPatternScale:(CGFloat)patternScale {
  _patternScale = patternScale;
  [self setNeedsDisplay:YES];
}

- (NSColor *)colorFromHex:(NSString *)hex {
  hex = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];
  unsigned int val = 0;
  [[NSScanner scannerWithString:hex] scanHexInt:&val];
  return [NSColor colorWithRed:((val >> 16) & 0xFF) / 255.0
                         green:((val >> 8) & 0xFF) / 255.0
                          blue:(val & 0xFF) / 255.0
                         alpha:1.0];
}

- (BOOL)isFlipped { return YES; }

- (void)drawRect:(NSRect)dirtyRect {
  NSRect bounds = self.bounds;
  NSRect clip = NSIntersectionRect(dirtyRect, bounds);
  if (NSIsEmptyRect(clip)) return;

  NSColor *bgColor = [self colorFromHex:_background];
  [bgColor setFill];
  NSRectFill(clip);

  NSColor *pColor = [[self colorFromHex:_patternColor] colorWithAlphaComponent:_patternOpacity];
  CGFloat s = _patternScale;
  CGFloat tile = 24.0 * s;

  [pColor setStroke];

  // Draw a subtle geometric pattern — diagonal crosses on a grid
  CGFloat startX = floor(clip.origin.x / tile) * tile;
  CGFloat startY = floor(clip.origin.y / tile) * tile;
  CGFloat endX = NSMaxX(clip);
  CGFloat endY = NSMaxY(clip);

  NSBezierPath *path = [NSBezierPath bezierPath];
  [path setLineWidth:0.5 * s];

  for (CGFloat x = startX; x < endX; x += tile) {
    for (CGFloat y = startY; y < endY; y += tile) {
      CGFloat cx = x + tile / 2.0;
      CGFloat cy = y + tile / 2.0;
      CGFloat arm = 3.0 * s;

      // Small cross
      [path moveToPoint:NSMakePoint(cx - arm, cy)];
      [path lineToPoint:NSMakePoint(cx + arm, cy)];
      [path moveToPoint:NSMakePoint(cx, cy - arm)];
      [path lineToPoint:NSMakePoint(cx, cy + arm)];

      // Small diamond at offset
      CGFloat dx = x + tile * 0.15;
      CGFloat dy = y + tile * 0.65;
      CGFloat dm = 1.5 * s;
      [path moveToPoint:NSMakePoint(dx, dy - dm)];
      [path lineToPoint:NSMakePoint(dx + dm, dy)];
      [path lineToPoint:NSMakePoint(dx, dy + dm)];
      [path lineToPoint:NSMakePoint(dx - dm, dy)];
      [path closePath];
    }
  }
  [path stroke];
}

- (void)insertReactSubview:(NSView *)subview atIndex:(NSInteger)atIndex {
  [super insertReactSubview:subview atIndex:atIndex];
}

- (void)layout {
  [super layout];
  [self setNeedsDisplay:YES];
}

@end

@interface RCTPatternBackgroundViewManager : RCTViewManager @end
@implementation RCTPatternBackgroundViewManager
RCT_EXPORT_MODULE(MacOSPatternBackground)
- (NSView *)view { return [[RCTPatternBackgroundView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(patternColor, NSString)
RCT_EXPORT_VIEW_PROPERTY(background, NSString)
RCT_EXPORT_VIEW_PROPERTY(patternOpacity, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(patternScale, CGFloat)
@end

// ===========================================================================
// MARK: - NSSplitView
// ===========================================================================

@interface RCTSplitPaneWrapper : NSView
@property (nonatomic, strong) NSView *reactChild;
@end

@implementation RCTSplitPaneWrapper
- (void)layout {
  [super layout];
  if (_reactChild) _reactChild.frame = self.bounds;
}
- (void)setFrameSize:(NSSize)newSize {
  [super setFrameSize:newSize];
  if (_reactChild) _reactChild.frame = self.bounds;
}
@end

@interface RCTSplitView : NSView <NSSplitViewDelegate>
@property (nonatomic, strong) NSSplitView *splitView;
@property (nonatomic, assign) BOOL isVertical;
@property (nonatomic, assign) CGFloat dividerThicknessValue;
@property (nonatomic, strong) NSMutableArray<NSView *> *reactChildren;
@property (nonatomic, strong) NSMutableArray<RCTSplitPaneWrapper *> *wrappers;
@end

@implementation RCTSplitView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _splitView = [[NSSplitView alloc] initWithFrame:self.bounds];
    _splitView.delegate = self;
    _splitView.dividerStyle = NSSplitViewDividerStyleThin;
    _splitView.vertical = YES;
    _splitView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    _reactChildren = [NSMutableArray new];
    _wrappers = [NSMutableArray new];
    _isVertical = YES;
    [self addSubview:_splitView];
  }
  return self;
}

- (void)setIsVertical:(BOOL)isVertical {
  _isVertical = isVertical;
  _splitView.vertical = isVertical;
  [_splitView adjustSubviews];
}

- (void)setDividerThicknessValue:(CGFloat)dividerThicknessValue {
  _dividerThicknessValue = dividerThicknessValue;
}

- (void)insertReactSubview:(NSView *)subview atIndex:(NSInteger)atIndex {
  NSInteger idx = MIN(atIndex, (NSInteger)_reactChildren.count);
  [_reactChildren insertObject:subview atIndex:idx];

  // Wrap the React child in a plain NSView so NSSplitView controls the wrapper's frame,
  // and we relay the size to the React child, triggering Yoga re-layout at the correct size.
  RCTSplitPaneWrapper *wrapper = [[RCTSplitPaneWrapper alloc] initWithFrame:NSZeroRect];
  wrapper.autoresizesSubviews = YES;
  wrapper.reactChild = subview;
  [wrapper addSubview:subview];
  [_wrappers insertObject:wrapper atIndex:idx];
  [_splitView addSubview:wrapper];
}

- (void)removeReactSubview:(NSView *)subview {
  NSUInteger idx = [_reactChildren indexOfObject:subview];
  if (idx != NSNotFound) {
    RCTSplitPaneWrapper *wrapper = _wrappers[idx];
    [subview removeFromSuperview];  // Remove child from wrapper so superview == nil
    [wrapper removeFromSuperview];  // Remove wrapper from splitView
    [_wrappers removeObjectAtIndex:idx];
    [_reactChildren removeObjectAtIndex:idx];
  }
}

- (NSArray<NSView *> *)reactSubviews {
  return [_reactChildren copy];
}

- (void)didUpdateReactSubviews {
  [self performSelector:@selector(doLayout) withObject:nil afterDelay:0];
}

- (void)doLayout {
  _splitView.frame = self.bounds;
  [_splitView adjustSubviews];
}

- (void)reactSetFrame:(CGRect)frame {
  [super reactSetFrame:frame];
  _splitView.frame = self.bounds;
  [_splitView adjustSubviews];
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex {
  return proposedMinimumPosition + 50;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex {
  return proposedMaximumPosition - 50;
}

- (void)layout {
  [super layout];
  _splitView.frame = self.bounds;
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
@end

@interface RCTSplitViewManager : RCTViewManager @end
@implementation RCTSplitViewManager
RCT_EXPORT_MODULE(MacOSSplitView)
- (NSView *)view { return [[RCTSplitView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(isVertical, BOOL)
RCT_EXPORT_VIEW_PROPERTY(dividerThicknessValue, CGFloat)
@end

// ===========================================================================
// MARK: - NSTabView
// ===========================================================================

@interface RCTTabView : NSView
@property (nonatomic, strong) NSSegmentedControl *tabBar;
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, copy) NSString *selectedItem;
@property (nonatomic, copy) NSString *tabPosition;
@property (nonatomic, copy) RCTBubblingEventBlock onSelectTab;
@end

@implementation RCTTabView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _tabBar = [NSSegmentedControl segmentedControlWithLabels:@[@"Tab"]
                                                trackingMode:NSSegmentSwitchTrackingSelectOne
                                                      target:self
                                                      action:@selector(handleTabChange)];
    _tabBar.segmentStyle = NSSegmentStyleAutomatic;
    _tabBar.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self addSubview:_tabBar];
  }
  return self;
}

- (void)setItems:(NSArray *)items {
  _items = items;
  _tabBar.segmentCount = items.count;
  for (NSUInteger i = 0; i < items.count; i++) {
    NSDictionary *item = items[i];
    [_tabBar setLabel:item[@"label"] ?: @"" forSegment:i];
  }
  [self updateSelectedSegment];
}

- (void)setSelectedItem:(NSString *)selectedItem {
  _selectedItem = selectedItem;
  [self updateSelectedSegment];
}

- (void)updateSelectedSegment {
  if (!_items || !_selectedItem) return;
  for (NSUInteger i = 0; i < _items.count; i++) {
    if ([_items[i][@"id"] isEqualToString:_selectedItem]) {
      _tabBar.selectedSegment = i;
      break;
    }
  }
}

- (void)handleTabChange {
  NSInteger idx = _tabBar.selectedSegment;
  if (idx >= 0 && idx < (NSInteger)_items.count && _onSelectTab) {
    _onSelectTab(@{@"tabId": _items[idx][@"id"] ?: @""});
  }
}

- (void)layout {
  [super layout];
  _tabBar.frame = self.bounds;
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
@end

@interface RCTTabViewManager : RCTViewManager @end
@implementation RCTTabViewManager
RCT_EXPORT_MODULE(MacOSTabView)
- (NSView *)view { return [[RCTTabView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(items, NSArray)
RCT_EXPORT_VIEW_PROPERTY(selectedItem, NSString)
RCT_EXPORT_VIEW_PROPERTY(onSelectTab, RCTBubblingEventBlock)
@end

// ===========================================================================
// MARK: - NSComboBox
// ===========================================================================

@interface RCTComboBoxView : NSView <NSComboBoxDelegate, NSComboBoxDataSource>
@property (nonatomic, strong) NSComboBox *comboBox;
@property (nonatomic, copy) NSArray<NSString *> *items;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) RCTBubblingEventBlock onChangeText;
@property (nonatomic, copy) RCTBubblingEventBlock onSelectItem;
@end

@implementation RCTComboBoxView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _comboBox = [[NSComboBox alloc] initWithFrame:self.bounds];
    _comboBox.usesDataSource = YES;
    _comboBox.dataSource = self;
    _comboBox.delegate = self;
    _comboBox.completes = YES;
    _comboBox.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self addSubview:_comboBox];
  }
  return self;
}

- (void)setItems:(NSArray<NSString *> *)items {
  _items = items;
  [_comboBox reloadData];
}

- (void)setText:(NSString *)text {
  _text = text;
  if (![_comboBox.stringValue isEqualToString:text]) {
    _comboBox.stringValue = text ?: @"";
  }
}

- (void)setPlaceholder:(NSString *)placeholder {
  _placeholder = placeholder;
  _comboBox.placeholderString = placeholder;
}

// NSComboBoxDataSource
- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)comboBox {
  return _items.count;
}

- (id)comboBox:(NSComboBox *)comboBox objectValueForItemAtIndex:(NSInteger)index {
  return index < (NSInteger)_items.count ? _items[index] : @"";
}

// NSComboBoxDelegate
- (void)comboBoxSelectionDidChange:(NSNotification *)notification {
  NSInteger idx = _comboBox.indexOfSelectedItem;
  if (idx >= 0 && idx < (NSInteger)_items.count && _onSelectItem) {
    _onSelectItem(@{@"selectedIndex": @(idx), @"text": _items[idx]});
  }
}

- (void)controlTextDidChange:(NSNotification *)obj {
  if (_onChangeText) {
    _onChangeText(@{@"text": _comboBox.stringValue ?: @""});
  }
}

- (void)layout {
  [super layout];
  _comboBox.frame = self.bounds;
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
@end

@interface RCTComboBoxViewManager : RCTViewManager @end
@implementation RCTComboBoxViewManager
RCT_EXPORT_MODULE(MacOSComboBox)
- (NSView *)view { return [[RCTComboBoxView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(items, NSArray)
RCT_EXPORT_VIEW_PROPERTY(text, NSString)
RCT_EXPORT_VIEW_PROPERTY(placeholder, NSString)
RCT_EXPORT_VIEW_PROPERTY(onChangeText, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onSelectItem, RCTBubblingEventBlock)
@end

// ===========================================================================
// MARK: - NSStepper
// ===========================================================================

@interface RCTStepperView : NSView
@property (nonatomic, strong) NSStepper *stepper;
@property (nonatomic, strong) NSTextField *label;
@property (nonatomic, assign) double value;
@property (nonatomic, assign) double minValue;
@property (nonatomic, assign) double maxValue;
@property (nonatomic, assign) double increment;
@property (nonatomic, copy) RCTBubblingEventBlock onChange;
@end

@implementation RCTStepperView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _stepper = [[NSStepper alloc] initWithFrame:NSMakeRect(0, 0, 19, 27)];
    _stepper.target = self;
    _stepper.action = @selector(handleChange);
    _stepper.minValue = 0;
    _stepper.maxValue = 100;
    _stepper.increment = 1;
    _stepper.valueWraps = NO;

    _label = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 50, 22)];
    _label.editable = NO;
    _label.bordered = NO;
    _label.drawsBackground = NO;
    _label.alignment = NSTextAlignmentRight;
    _label.textColor = NSColor.labelColor;
    _label.font = [NSFont monospacedDigitSystemFontOfSize:13 weight:NSFontWeightRegular];
    _label.stringValue = @"0";

    [self addSubview:_label];
    [self addSubview:_stepper];
  }
  return self;
}

- (void)handleChange {
  _value = _stepper.doubleValue;
  _label.stringValue = [NSString stringWithFormat:@"%g", _value];
  if (_onChange) _onChange(@{@"value": @(_value)});
}

- (void)setValue:(double)value {
  _value = value;
  _stepper.doubleValue = value;
  _label.stringValue = [NSString stringWithFormat:@"%g", value];
}

- (void)setMinValue:(double)minValue { _minValue = minValue; _stepper.minValue = minValue; }
- (void)setMaxValue:(double)maxValue { _maxValue = maxValue; _stepper.maxValue = maxValue; }
- (void)setIncrement:(double)increment { _increment = increment; _stepper.increment = increment; }

- (void)layout {
  [super layout];
  CGFloat stepperW = 19;
  CGFloat stepperH = MIN(self.bounds.size.height, 27);
  CGFloat h = self.bounds.size.height;
  CGFloat w = self.bounds.size.width;
  CGFloat yOff = (h - stepperH) / 2;
  _stepper.frame = NSMakeRect(w - stepperW, yOff, stepperW, stepperH);
  _label.frame = NSMakeRect(0, (h - 22) / 2, w - stepperW - 4, 22);
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
@end

@interface RCTStepperViewManager : RCTViewManager @end
@implementation RCTStepperViewManager
RCT_EXPORT_MODULE(MacOSStepper)
- (NSView *)view { return [[RCTStepperView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(value, double)
RCT_EXPORT_VIEW_PROPERTY(minValue, double)
RCT_EXPORT_VIEW_PROPERTY(maxValue, double)
RCT_EXPORT_VIEW_PROPERTY(increment, double)
RCT_EXPORT_VIEW_PROPERTY(onChange, RCTBubblingEventBlock)
@end

// ===========================================================================
// MARK: - NSBox
// ===========================================================================

@interface RCTBoxView : NSBox
@property (nonatomic, copy) NSString *boxTitle;
@property (nonatomic, copy) NSString *fillColor2;
@property (nonatomic, copy) NSString *borderColor2;
@property (nonatomic, assign) CGFloat radius;
@end

@implementation RCTBoxView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.titlePosition = NSNoTitle;
    self.boxType = NSBoxCustom;
    self.borderWidth = 1.0;
    self.cornerRadius = 8.0;
    self.contentViewMargins = NSMakeSize(8, 8);
  }
  return self;
}

- (void)setBoxTitle:(NSString *)boxTitle {
  _boxTitle = boxTitle;
  if (boxTitle.length > 0) {
    self.title = boxTitle;
    self.titlePosition = NSAtTop;
  } else {
    self.title = @"";
    self.titlePosition = NSNoTitle;
  }
}

- (void)setFillColor2:(NSString *)fillColor2 {
  _fillColor2 = fillColor2;
  self.fillColor = [RCTBoxView colorFromHex:fillColor2];
}

- (void)setBorderColor2:(NSString *)borderColor2 {
  _borderColor2 = borderColor2;
  self.borderColor = [RCTBoxView colorFromHex:borderColor2];
}

- (void)setRadius:(CGFloat)radius {
  _radius = radius;
  self.cornerRadius = radius;
}

+ (NSColor *)colorFromHex:(NSString *)hex {
  if (!hex || hex.length < 7) return NSColor.separatorColor;
  unsigned int rgb = 0;
  [[NSScanner scannerWithString:[hex substringFromIndex:1]] scanHexInt:&rgb];
  return [NSColor colorWithRed:((rgb >> 16) & 0xFF) / 255.0
                         green:((rgb >> 8) & 0xFF) / 255.0
                          blue:(rgb & 0xFF) / 255.0
                         alpha:1.0];
}

- (void)insertReactSubview:(NSView *)subview atIndex:(NSInteger)atIndex {
  [self.contentView addSubview:subview];
}

- (void)removeReactSubview:(NSView *)subview {
  [subview removeFromSuperview];
}

- (NSArray<NSView *> *)reactSubviews {
  return self.contentView.subviews;
}

- (void)didUpdateReactSubviews {
  [self performSelector:@selector(layoutContentSubviews) withObject:nil afterDelay:0];
}

- (void)layoutContentSubviews {
  for (NSView *child in self.contentView.subviews) {
    child.frame = self.contentView.bounds;
  }
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
@end

@interface RCTBoxViewManager : RCTViewManager @end
@implementation RCTBoxViewManager
RCT_EXPORT_MODULE(MacOSBox)
- (NSView *)view { return [[RCTBoxView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(boxTitle, NSString)
RCT_EXPORT_VIEW_PROPERTY(fillColor2, NSString)
RCT_EXPORT_VIEW_PROPERTY(borderColor2, NSString)
RCT_EXPORT_VIEW_PROPERTY(radius, CGFloat)
@end

// ===========================================================================
// MARK: - NSPopover
// ===========================================================================

@interface RCTFlippedPopoverContentView : NSView
@end
@implementation RCTFlippedPopoverContentView
- (BOOL)isFlipped { return YES; }
@end

@interface RCTPopoverView : NSView <NSPopoverDelegate>
@property (nonatomic, strong) NSPopover *popover;
@property (nonatomic, strong) NSViewController *popoverVC;
@property (nonatomic, strong) NSView *contentContainer;

@property (nonatomic, strong) NSMutableArray<NSView *> *reactChildren;
@property (nonatomic, assign) BOOL visible;
@property (nonatomic, copy) NSString *preferredEdge;
@property (nonatomic, copy) NSString *behavior;
@property (nonatomic, assign) CGFloat popoverWidth;
@property (nonatomic, assign) CGFloat popoverHeight;
@property (nonatomic, assign) CGFloat popoverPadding;
@property (nonatomic, copy) RCTBubblingEventBlock onClose;
@end

@implementation RCTPopoverView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _reactChildren = [NSMutableArray new];
    _contentContainer = [[NSView alloc] initWithFrame:NSZeroRect];
    _popoverVC = [[NSViewController alloc] init];
    _popoverVC.view = _contentContainer;

    _popover = [[NSPopover alloc] init];
    _popover.contentViewController = _popoverVC;
    _popover.behavior = NSPopoverBehaviorTransient;
    _popover.animates = YES;
    _popover.delegate = self;
    _preferredEdge = @"bottom";

  }
  return self;
}

- (void)setVisible:(BOOL)visible {
  _visible = visible;
  if (visible) {
    if (!_popover.isShown && self.window) {
      // Reset children to origin before measuring (centerContent may have shifted them)
      for (NSView *child in _contentContainer.subviews) {
        CGRect cf = child.frame;
        child.frame = CGRectMake(cf.origin.x, 0, cf.size.width, cf.size.height);
      }
      // Measure RN content that Yoga has already laid out
      CGFloat w = _popoverWidth;
      CGFloat h = _popoverHeight;
      if (w <= 0 || h <= 0) {
        CGRect contentRect = CGRectZero;
        for (NSView *child in _contentContainer.subviews) {
          contentRect = CGRectUnion(contentRect, child.frame);
        }
        if (w <= 0) w = contentRect.size.width;
        if (h <= 0) h = contentRect.size.height - _popoverPadding;
      }
      if (w < 20) w = 20;
      if (h < 10) h = 10;
      _popover.contentSize = NSMakeSize(w, h);
      NSRectEdge edge = [self edgeFromString:_preferredEdge];
      NSView *anchor = _reactChildren.count > 0 ? _reactChildren[0] : self;
      [_popover showRelativeToRect:anchor.bounds ofView:anchor preferredEdge:edge];
      // Center content vertically after the container is sized
      [self performSelector:@selector(centerContent) withObject:nil afterDelay:0.01];
    }
  } else {
    if (_popover.isShown) [_popover close];
  }
}

- (void)setBehavior:(NSString *)behavior {
  _behavior = behavior;
  if ([behavior isEqualToString:@"transient"]) _popover.behavior = NSPopoverBehaviorTransient;
  else if ([behavior isEqualToString:@"semitransient"]) _popover.behavior = NSPopoverBehaviorSemitransient;
  else _popover.behavior = NSPopoverBehaviorApplicationDefined;
}

- (NSRectEdge)edgeFromString:(NSString *)str {
  if ([str isEqualToString:@"top"]) return NSRectEdgeMaxY;
  if ([str isEqualToString:@"left"]) return NSRectEdgeMinX;
  if ([str isEqualToString:@"right"]) return NSRectEdgeMaxX;
  return NSRectEdgeMinY; // bottom
}

// First child = anchor (rendered inline in self)
// Subsequent children = popover content
- (void)insertReactSubview:(NSView *)subview atIndex:(NSInteger)atIndex {
  [_reactChildren insertObject:subview atIndex:MIN(atIndex, (NSInteger)_reactChildren.count)];
  if (_reactChildren.count == 1) {
    // First child → render inline as the anchor
    [self addSubview:subview];
  } else {
    // Subsequent children → popover content
    [_contentContainer addSubview:subview];
  }
}

- (void)removeReactSubview:(NSView *)subview {
  [_reactChildren removeObject:subview];
  [subview removeFromSuperview];
}

- (NSArray<NSView *> *)reactSubviews {
  return [_reactChildren copy];
}

- (void)setPopoverWidth:(CGFloat)popoverWidth {
  _popoverWidth = popoverWidth;
  [self updatePopoverSize];
}

- (void)setPopoverHeight:(CGFloat)popoverHeight {
  _popoverHeight = popoverHeight;
  [self updatePopoverSize];
}

- (void)updatePopoverSize {
  if (_popoverWidth > 0 && _popoverHeight > 0) {
    _popover.contentSize = NSMakeSize(_popoverWidth, _popoverHeight);
  }
}

- (void)centerContent {
  CGFloat containerH = _contentContainer.bounds.size.height;
  for (NSView *child in _contentContainer.subviews) {
    CGRect cf = child.frame;
    CGFloat y = (containerH - cf.size.height) / 2.0;
    if (y < 0) y = 0;
    child.frame = CGRectMake(cf.origin.x, y, cf.size.width, cf.size.height);
  }
}

- (void)didUpdateReactSubviews {
}

- (void)popoverDidClose:(NSNotification *)notification {
  _visible = NO;
  if (_onClose) _onClose(@{});
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
@end

@interface RCTPopoverViewManager : RCTViewManager @end
@implementation RCTPopoverViewManager
RCT_EXPORT_MODULE(MacOSPopover)
- (NSView *)view { return [[RCTPopoverView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(visible, BOOL)
RCT_EXPORT_VIEW_PROPERTY(preferredEdge, NSString)
RCT_EXPORT_VIEW_PROPERTY(behavior, NSString)
RCT_EXPORT_VIEW_PROPERTY(popoverWidth, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(popoverHeight, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(popoverPadding, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(onClose, RCTBubblingEventBlock)
@end

// ===========================================================================
// MARK: - NSImageView (static)
// ===========================================================================

@interface RCTStaticImageView : NSView
@property (nonatomic, strong) NSImageView *imageView;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *contentMode;
@property (nonatomic, assign) CGFloat cornerRadius;
@end

@implementation RCTStaticImageView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _imageView = [[NSImageView alloc] initWithFrame:self.bounds];
    _imageView.imageScaling = NSImageScaleProportionallyUpOrDown;
    _imageView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    _imageView.wantsLayer = YES;
    [self addSubview:_imageView];
  }
  return self;
}

- (void)setSource:(NSString *)source {
  _source = source;
  if ([source hasPrefix:@"http://"] || [source hasPrefix:@"https://"]) {
    NSURL *url = [NSURL URLWithString:source];
    if (!url) return;
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url
      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data && !error) {
          NSImage *image = [[NSImage alloc] initWithData:data];
          dispatch_async(dispatch_get_main_queue(), ^{
            if ([self->_source isEqualToString:source]) {
              self->_imageView.image = image;
            }
          });
        }
      }];
    [task resume];
  } else {
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:source];
    if (image) _imageView.image = image;
  }
}

- (void)setContentMode:(NSString *)contentMode {
  _contentMode = contentMode;
  if ([contentMode isEqualToString:@"scaleToFit"]) _imageView.imageScaling = NSImageScaleAxesIndependently;
  else if ([contentMode isEqualToString:@"center"]) _imageView.imageScaling = NSImageScaleNone;
  else _imageView.imageScaling = NSImageScaleProportionallyUpOrDown;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
  _cornerRadius = cornerRadius;
  _imageView.wantsLayer = YES;
  _imageView.layer.cornerRadius = cornerRadius;
  _imageView.layer.masksToBounds = YES;
}

- (void)layout {
  [super layout];
  _imageView.frame = self.bounds;
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
@end

@interface RCTStaticImageViewManager : RCTViewManager @end
@implementation RCTStaticImageViewManager
RCT_EXPORT_MODULE(MacOSImage)
- (NSView *)view { return [[RCTStaticImageView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(source, NSString)
RCT_EXPORT_VIEW_PROPERTY(contentMode, NSString)
RCT_EXPORT_VIEW_PROPERTY(cornerRadius, CGFloat)
@end

// ============================================================
// 30. NSButton (Checkbox) — MacOSCheckbox
// ============================================================

@interface RCTCheckboxView : NSView
@property (nonatomic, strong) NSButton *button;
@property (nonatomic, copy) RCTBubblingEventBlock onChange;
@property (nonatomic, assign) BOOL checked;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL enabled;
@end

@implementation RCTCheckboxView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _button = [NSButton checkboxWithTitle:@"" target:self action:@selector(toggled:)];
    [self addSubview:_button];
  }
  return self;
}

- (void)toggled:(id)sender {
  if (_onChange) _onChange(@{ @"checked": @(_button.state == NSControlStateValueOn) });
}

- (void)setChecked:(BOOL)checked {
  _checked = checked;
  _button.state = checked ? NSControlStateValueOn : NSControlStateValueOff;
}

- (void)setTitle:(NSString *)title {
  _title = title;
  _button.title = title ?: @"";
}

- (void)setEnabled:(BOOL)enabled {
  _enabled = enabled;
  _button.enabled = enabled;
}

- (void)layout {
  [super layout];
  _button.frame = self.bounds;
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
@end

@interface RCTCheckboxViewManager : RCTViewManager @end
@implementation RCTCheckboxViewManager
RCT_EXPORT_MODULE(MacOSCheckbox)
- (NSView *)view { return [[RCTCheckboxView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(checked, BOOL)
RCT_EXPORT_VIEW_PROPERTY(title, NSString)
RCT_EXPORT_VIEW_PROPERTY(enabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onChange, RCTBubblingEventBlock)
@end

// ============================================================
// 31. NSButton (RadioButton) — MacOSRadioButton
// ============================================================

@interface RCTRadioButtonView : NSView
@property (nonatomic, strong) NSButton *button;
@property (nonatomic, copy) RCTBubblingEventBlock onChange;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL enabled;
@end

@implementation RCTRadioButtonView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _button = [NSButton radioButtonWithTitle:@"" target:self action:@selector(toggled:)];
    [self addSubview:_button];
  }
  return self;
}

- (void)toggled:(id)sender {
  if (_onChange) _onChange(@{ @"selected": @(_button.state == NSControlStateValueOn) });
}

- (void)setSelected:(BOOL)selected {
  _selected = selected;
  _button.state = selected ? NSControlStateValueOn : NSControlStateValueOff;
}

- (void)setTitle:(NSString *)title {
  _title = title;
  _button.title = title ?: @"";
}

- (void)setEnabled:(BOOL)enabled {
  _enabled = enabled;
  _button.enabled = enabled;
}

- (void)layout {
  [super layout];
  _button.frame = self.bounds;
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
@end

@interface RCTRadioButtonViewManager : RCTViewManager @end
@implementation RCTRadioButtonViewManager
RCT_EXPORT_MODULE(MacOSRadioButton)
- (NSView *)view { return [[RCTRadioButtonView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(selected, BOOL)
RCT_EXPORT_VIEW_PROPERTY(title, NSString)
RCT_EXPORT_VIEW_PROPERTY(enabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onChange, RCTBubblingEventBlock)
@end

// ============================================================
// 32. NSSearchField — MacOSSearchField
// ============================================================

@interface RCTSearchFieldView : NSView <NSSearchFieldDelegate>
@property (nonatomic, strong) NSSearchField *searchField;
@property (nonatomic, copy) RCTBubblingEventBlock onChangeText;
@property (nonatomic, copy) RCTBubblingEventBlock onSearch;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *placeholder;
@end

@implementation RCTSearchFieldView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _searchField = [[NSSearchField alloc] initWithFrame:CGRectZero];
    _searchField.delegate = self;
    _searchField.target = self;
    _searchField.action = @selector(searchAction:);
    [self addSubview:_searchField];
  }
  return self;
}

- (void)searchAction:(id)sender {
  if (_onSearch) _onSearch(@{ @"text": _searchField.stringValue ?: @"" });
}

- (void)controlTextDidChange:(NSNotification *)notification {
  if (_onChangeText) _onChangeText(@{ @"text": _searchField.stringValue ?: @"" });
}

- (void)setText:(NSString *)text {
  _text = text;
  _searchField.stringValue = text ?: @"";
}

- (void)setPlaceholder:(NSString *)placeholder {
  _placeholder = placeholder;
  _searchField.placeholderString = placeholder;
}

- (void)layout {
  [super layout];
  _searchField.frame = self.bounds;
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
@end

@interface RCTSearchFieldViewManager : RCTViewManager @end
@implementation RCTSearchFieldViewManager
RCT_EXPORT_MODULE(MacOSSearchField)
- (NSView *)view { return [[RCTSearchFieldView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(text, NSString)
RCT_EXPORT_VIEW_PROPERTY(placeholder, NSString)
RCT_EXPORT_VIEW_PROPERTY(onChangeText, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onSearch, RCTBubblingEventBlock)
@end

// ============================================================
// 33. NSTokenField — MacOSTokenField
// ============================================================

@interface RCTTokenFieldView : NSView <NSTokenFieldDelegate>
@property (nonatomic, strong) NSTokenField *tokenField;
@property (nonatomic, copy) RCTBubblingEventBlock onChangeTokens;
@property (nonatomic, strong) NSArray<NSString *> *tokens;
@property (nonatomic, copy) NSString *placeholder;
@end

@implementation RCTTokenFieldView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _tokenField = [[NSTokenField alloc] initWithFrame:CGRectZero];
    _tokenField.delegate = self;
    [self addSubview:_tokenField];
  }
  return self;
}

- (void)controlTextDidChange:(NSNotification *)notification {
  [self reportTokens];
}

- (NSArray *)tokenField:(NSTokenField *)tokenField shouldAddObjects:(NSArray *)tokens atIndex:(NSUInteger)index {
  dispatch_async(dispatch_get_main_queue(), ^{ [self reportTokens]; });
  return tokens;
}

- (void)reportTokens {
  if (_onChangeTokens) {
    NSArray *objs = _tokenField.objectValue;
    NSMutableArray *strs = [NSMutableArray array];
    for (id obj in objs) {
      [strs addObject:[obj description]];
    }
    _onChangeTokens(@{ @"tokens": strs });
  }
}

- (void)setTokens:(NSArray<NSString *> *)tokens {
  _tokens = tokens;
  _tokenField.objectValue = tokens ?: @[];
}

- (void)setPlaceholder:(NSString *)placeholder {
  _placeholder = placeholder;
  _tokenField.placeholderString = placeholder;
}

- (void)layout {
  [super layout];
  _tokenField.frame = self.bounds;
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
@end

@interface RCTTokenFieldViewManager : RCTViewManager @end
@implementation RCTTokenFieldViewManager
RCT_EXPORT_MODULE(MacOSTokenField)
- (NSView *)view { return [[RCTTokenFieldView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(tokens, NSArray)
RCT_EXPORT_VIEW_PROPERTY(placeholder, NSString)
RCT_EXPORT_VIEW_PROPERTY(onChangeTokens, RCTBubblingEventBlock)
@end

// ============================================================
// 34. NSBox (Separator) — MacOSSeparator
// ============================================================

@interface RCTSeparatorView : NSView
@property (nonatomic, strong) NSBox *box;
@property (nonatomic, assign) BOOL vertical;
@end

@implementation RCTSeparatorView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _box = [[NSBox alloc] initWithFrame:CGRectZero];
    _box.boxType = NSBoxSeparator;
    [self addSubview:_box];
  }
  return self;
}

- (void)layout {
  [super layout];
  _box.frame = self.bounds;
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
@end

@interface RCTSeparatorViewManager : RCTViewManager @end
@implementation RCTSeparatorViewManager
RCT_EXPORT_MODULE(MacOSSeparator)
- (NSView *)view { return [[RCTSeparatorView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(vertical, BOOL)
@end

// ============================================================
// 35. NSButton (HelpButton) — MacOSHelpButton
// ============================================================

@interface RCTHelpButtonView : NSView
@property (nonatomic, strong) NSButton *button;
@property (nonatomic, copy) RCTBubblingEventBlock onPress;
@end

@implementation RCTHelpButtonView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _button = [[NSButton alloc] initWithFrame:CGRectZero];
    _button.bezelStyle = NSBezelStyleHelpButton;
    _button.title = @"";
    _button.target = self;
    _button.action = @selector(pressed:);
    [self addSubview:_button];
  }
  return self;
}

- (void)pressed:(id)sender {
  if (_onPress) _onPress(@{});
}

- (void)layout {
  [super layout];
  _button.frame = self.bounds;
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
@end

@interface RCTHelpButtonViewManager : RCTViewManager @end
@implementation RCTHelpButtonViewManager
RCT_EXPORT_MODULE(MacOSHelpButton)
- (NSView *)view { return [[RCTHelpButtonView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(onPress, RCTBubblingEventBlock)
@end

// ============================================================
// 36. NSPathControl — MacOSPathControl
// ============================================================

@interface RCTPathControlView : NSView
@property (nonatomic, strong) NSPathControl *pathControl;
@property (nonatomic, copy) RCTBubblingEventBlock onSelectPath;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *pathStyle;
@end

@implementation RCTPathControlView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _pathControl = [[NSPathControl alloc] initWithFrame:CGRectZero];
    _pathControl.pathStyle = NSPathStyleStandard;
    _pathControl.target = self;
    _pathControl.action = @selector(pathClicked:);
    _pathControl.backgroundColor = [NSColor clearColor];
    [self addSubview:_pathControl];
  }
  return self;
}

- (void)pathClicked:(id)sender {
  if (_onSelectPath) {
    NSPathControlItem *item = _pathControl.clickedPathItem;
    NSString *urlStr = item.URL.absoluteString ?: _pathControl.URL.absoluteString ?: @"";
    _onSelectPath(@{ @"url": urlStr });
  }
}

- (void)setUrl:(NSString *)url {
  _url = url;
  if (url) {
    NSURL *u = [NSURL URLWithString:url];
    if (!u) u = [NSURL fileURLWithPath:url];
    _pathControl.URL = u;
  }
}

- (void)setPathStyle:(NSString *)pathStyle {
  _pathStyle = pathStyle;
  if ([pathStyle isEqualToString:@"popup"]) _pathControl.pathStyle = NSPathStylePopUp;
  else if ([pathStyle isEqualToString:@"none"]) _pathControl.pathStyle = NSPathStyleStandard;
  else _pathControl.pathStyle = NSPathStyleStandard;
}

- (void)layout {
  [super layout];
  _pathControl.frame = self.bounds;
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
@end

@interface RCTPathControlViewManager : RCTViewManager @end
@implementation RCTPathControlViewManager
RCT_EXPORT_MODULE(MacOSPathControl)
- (NSView *)view { return [[RCTPathControlView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(url, NSString)
RCT_EXPORT_VIEW_PROPERTY(pathStyle, NSString)
RCT_EXPORT_VIEW_PROPERTY(onSelectPath, RCTBubblingEventBlock)
@end

// ============================================================
// 37. Sheet — MacOSSheet
// ============================================================

@interface RCTSheetView : NSView
@property (nonatomic, assign) BOOL visible;
@property (nonatomic, copy) RCTBubblingEventBlock onDismiss;
@property (nonatomic, strong) NSWindow *sheetWindow;
@property (nonatomic, strong) NSView *contentHolder;
@property (nonatomic, assign) BOOL sheetPresented;
@end

@implementation RCTSheetView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _contentHolder = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 400, 300)];
    _sheetWindow = [[NSWindow alloc] initWithContentRect:CGRectMake(0, 0, 400, 300)
                                               styleMask:NSWindowStyleMaskTitled
                                                 backing:NSBackingStoreBuffered
                                                   defer:YES];
    _sheetWindow.contentView = _contentHolder;
  }
  return self;
}

// Keep React children in self (so Fabric can track them).
// Mirror them into the sheet's content holder when the sheet is shown.
- (void)_mirrorChildrenToSheet {
  // Remove old mirrors
  for (NSView *v in [_contentHolder.subviews copy]) {
    [v removeFromSuperview];
  }
  // Add subviews of self (the React children) to contentHolder
  for (NSView *child in self.subviews) {
    [_contentHolder addSubview:child];
  }
  CGFloat maxW = 400, maxH = 300;
  for (NSView *child in _contentHolder.subviews) {
    CGRect f = child.frame;
    if (CGRectGetMaxX(f) > maxW) maxW = CGRectGetMaxX(f);
    if (CGRectGetMaxY(f) > maxH) maxH = CGRectGetMaxY(f);
  }
  _contentHolder.frame = CGRectMake(0, 0, maxW, maxH);
  [_sheetWindow setContentSize:NSMakeSize(maxW, maxH)];
}

- (void)_returnChildrenFromSheet {
  for (NSView *child in [_contentHolder.subviews copy]) {
    [self addSubview:child];
  }
}

- (void)setVisible:(BOOL)visible {
  _visible = visible;
  if (visible && !_sheetPresented) {
    NSWindow *parent = [NSApp keyWindow];
    if (parent) {
      _sheetPresented = YES;
      [self _mirrorChildrenToSheet];
      [parent beginSheet:_sheetWindow completionHandler:^(NSModalResponse returnCode) {
        [self _returnChildrenFromSheet];
        self->_sheetPresented = NO;
        if (self->_onDismiss) self->_onDismiss(@{});
      }];
    }
  } else if (!visible && _sheetPresented) {
    [NSApp endSheet:_sheetWindow];
    [_sheetWindow orderOut:nil];
    [self _returnChildrenFromSheet];
    _sheetPresented = NO;
  }
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
@end

@interface RCTSheetViewManager : RCTViewManager @end
@implementation RCTSheetViewManager
RCT_EXPORT_MODULE(MacOSSheet)
- (NSView *)view { return [[RCTSheetView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(visible, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onDismiss, RCTBubblingEventBlock)
@end

// ============================================================
// 38. NSMenu — MacOSMenuModule (imperative)
// ============================================================

@interface MacOSMenuModule : NSObject <RCTBridgeModule>
@end

@implementation MacOSMenuModule

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup { return NO; }

RCT_EXPORT_METHOD(show:(NSArray<NSDictionary *> *)items
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@""];
    menu.autoenablesItems = NO;
    for (NSUInteger i = 0; i < items.count; i++) {
      NSDictionary *item = items[i];
      NSString *title = item[@"title"] ?: @"";
      NSString *itemId = item[@"id"] ?: @"";
      if ([title isEqualToString:@"-"]) {
        [menu addItem:[NSMenuItem separatorItem]];
      } else {
        NSMenuItem *mi = [[NSMenuItem alloc] initWithTitle:title action:@selector(menuItemSelected:) keyEquivalent:@""];
        mi.representedObject = itemId;
        mi.target = self;
        mi.tag = (NSInteger)i;
        mi.enabled = YES;
        [menu addItem:mi];
      }
    }

    __block NSString *selectedId = @"";
    __block BOOL wasSelected = NO;

    // Use a temporary target to capture selection
    NSWindow *keyWin = [NSApp keyWindow];
    NSView *targetView = keyWin.contentView;
    NSPoint loc = targetView ? [targetView convertPoint:NSMakePoint(0, 0) toView:nil] : NSZeroPoint;

    // popUpMenuPositioningItem is synchronous
    [menu popUpMenuPositioningItem:nil atLocation:[NSEvent mouseLocation] inView:nil];

    // After menu closes, check which item was highlighted/selected
    for (NSMenuItem *mi in menu.itemArray) {
      if (mi.state == NSControlStateValueOn || mi == menu.highlightedItem) {
        selectedId = mi.representedObject ?: @"";
        wasSelected = YES;
        break;
      }
    }

    resolve(selectedId);
  });
}

- (void)menuItemSelected:(NSMenuItem *)sender {
  // Action target — makes the item selectable
}

@end

// ============================================================
// 39. NSTableView — MacOSTableView
// ============================================================

@interface RCTTableViewWrapper : NSView <NSTableViewDataSource, NSTableViewDelegate>
@property (nonatomic, strong) NSScrollView *scrollView;
@property (nonatomic, strong) NSTableView *tableView;
@property (nonatomic, strong) NSArray<NSDictionary *> *columns;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *rows;
@property (nonatomic, assign) BOOL headerVisible;
@property (nonatomic, assign) BOOL alternatingRows;
@property (nonatomic, copy) RCTBubblingEventBlock onSelectRow;
@property (nonatomic, copy) RCTBubblingEventBlock onDoubleClickRow;
@end

@implementation RCTTableViewWrapper

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _tableView = [[NSTableView alloc] initWithFrame:CGRectZero];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.usesAlternatingRowBackgroundColors = YES;
    _tableView.headerView = [[NSTableHeaderView alloc] init];
    _tableView.target = self;
    _tableView.doubleAction = @selector(doubleClicked:);

    _scrollView = [[NSScrollView alloc] initWithFrame:CGRectZero];
    _scrollView.documentView = _tableView;
    _scrollView.hasVerticalScroller = YES;
    _scrollView.hasHorizontalScroller = YES;
    _scrollView.autohidesScrollers = YES;
    [self addSubview:_scrollView];
  }
  return self;
}

- (void)doubleClicked:(id)sender {
  NSInteger row = _tableView.clickedRow;
  if (row >= 0 && _onDoubleClickRow) _onDoubleClickRow(@{ @"rowIndex": @(row) });
}

- (void)setColumns:(NSArray<NSDictionary *> *)columns {
  _columns = columns;
  // Remove old columns
  while (_tableView.tableColumns.count > 0) {
    [_tableView removeTableColumn:_tableView.tableColumns.lastObject];
  }
  for (NSDictionary *col in columns) {
    NSString *colId = col[@"id"] ?: @"";
    NSString *title = col[@"title"] ?: colId;
    NSNumber *width = col[@"width"];
    NSTableColumn *tc = [[NSTableColumn alloc] initWithIdentifier:colId];
    tc.headerCell.stringValue = title;
    if (width) tc.width = width.doubleValue;
    [_tableView addTableColumn:tc];
  }
  [_tableView reloadData];
}

- (void)setRows:(NSArray<NSArray<NSString *> *> *)rows {
  _rows = rows;
  [_tableView reloadData];
}

- (void)setHeaderVisible:(BOOL)headerVisible {
  _headerVisible = headerVisible;
  _tableView.headerView = headerVisible ? [[NSTableHeaderView alloc] init] : nil;
}

- (void)setAlternatingRows:(BOOL)alternatingRows {
  _alternatingRows = alternatingRows;
  _tableView.usesAlternatingRowBackgroundColors = alternatingRows;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  return _rows.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  NSTextField *cell = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
  if (!cell) {
    cell = [NSTextField labelWithString:@""];
    cell.identifier = tableColumn.identifier;
  }
  NSUInteger colIdx = [_tableView.tableColumns indexOfObject:tableColumn];
  NSArray *rowData = (row < (NSInteger)_rows.count) ? _rows[row] : @[];
  cell.stringValue = (colIdx < rowData.count) ? rowData[colIdx] : @"";
  return cell;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
  NSInteger row = _tableView.selectedRow;
  if (row >= 0 && _onSelectRow) _onSelectRow(@{ @"rowIndex": @(row) });
}

- (void)layout {
  [super layout];
  _scrollView.frame = self.bounds;
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
@end

@interface RCTTableViewManager : RCTViewManager @end
@implementation RCTTableViewManager
RCT_EXPORT_MODULE(MacOSTableView)
- (NSView *)view { return [[RCTTableViewWrapper alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(columns, NSArray)
RCT_EXPORT_VIEW_PROPERTY(rows, NSArray)
RCT_EXPORT_VIEW_PROPERTY(headerVisible, BOOL)
RCT_EXPORT_VIEW_PROPERTY(alternatingRows, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onSelectRow, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onDoubleClickRow, RCTBubblingEventBlock)
@end

// ============================================================
// 40. NSOutlineView — MacOSOutlineView
// ============================================================

@interface RCTOutlineViewWrapper : NSView <NSOutlineViewDataSource, NSOutlineViewDelegate>
@property (nonatomic, strong) NSScrollView *scrollView;
@property (nonatomic, strong) NSOutlineView *outlineView;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) BOOL headerVisible;
@property (nonatomic, copy) RCTBubblingEventBlock onSelectItem;
@end

@implementation RCTOutlineViewWrapper

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _outlineView = [[NSOutlineView alloc] initWithFrame:CGRectZero];
    _outlineView.dataSource = self;
    _outlineView.delegate = self;
    _outlineView.usesAlternatingRowBackgroundColors = YES;
    _outlineView.headerView = nil;
    _outlineView.floatsGroupRows = NO;
    _outlineView.indentationPerLevel = 16;

    NSTableColumn *col = [[NSTableColumn alloc] initWithIdentifier:@"title"];
    col.headerCell.stringValue = @"Title";
    [_outlineView addTableColumn:col];
    _outlineView.outlineTableColumn = col;

    _scrollView = [[NSScrollView alloc] initWithFrame:CGRectZero];
    _scrollView.documentView = _outlineView;
    _scrollView.hasVerticalScroller = YES;
    _scrollView.autohidesScrollers = YES;
    [self addSubview:_scrollView];
  }
  return self;
}

- (void)setItems:(NSArray *)items {
  _items = items ?: @[];
  [_outlineView reloadData];
  [_outlineView expandItem:nil expandChildren:YES];
}

- (void)setHeaderVisible:(BOOL)headerVisible {
  _headerVisible = headerVisible;
  _outlineView.headerView = headerVisible ? [[NSTableHeaderView alloc] init] : nil;
}

// --- NSOutlineViewDataSource ---

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
  NSArray *children = item ? [item objectForKey:@"children"] : _items;
  return children.count;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
  NSArray *children = item ? [item objectForKey:@"children"] : _items;
  return (index < (NSInteger)children.count) ? children[index] : nil;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
  NSArray *children = [item objectForKey:@"children"];
  return children && children.count > 0;
}

// --- NSOutlineViewDelegate ---

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
  NSTableCellView *cell = [outlineView makeViewWithIdentifier:@"cell" owner:self];
  if (!cell) {
    cell = [[NSTableCellView alloc] initWithFrame:CGRectZero];
    cell.identifier = @"cell";
    NSTextField *tf = [NSTextField labelWithString:@""];
    tf.translatesAutoresizingMaskIntoConstraints = NO;
    cell.textField = tf;
    [cell addSubview:tf];

    NSImageView *iv = [[NSImageView alloc] init];
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    cell.imageView = iv;
    [cell addSubview:iv];

    [NSLayoutConstraint activateConstraints:@[
      [iv.leadingAnchor constraintEqualToAnchor:cell.leadingAnchor constant:2],
      [iv.centerYAnchor constraintEqualToAnchor:cell.centerYAnchor],
      [iv.widthAnchor constraintEqualToConstant:16],
      [iv.heightAnchor constraintEqualToConstant:16],
      [tf.leadingAnchor constraintEqualToAnchor:iv.trailingAnchor constant:4],
      [tf.trailingAnchor constraintEqualToAnchor:cell.trailingAnchor constant:-2],
      [tf.centerYAnchor constraintEqualToAnchor:cell.centerYAnchor],
    ]];
  }

  NSString *title = [item objectForKey:@"title"] ?: @"";
  NSString *sfSymbol = [item objectForKey:@"sfSymbol"];
  cell.textField.stringValue = title;

  if (sfSymbol.length > 0) {
    cell.imageView.image = [NSImage imageWithSystemSymbolName:sfSymbol accessibilityDescription:title];
    cell.imageView.hidden = NO;
  } else {
    cell.imageView.image = nil;
    cell.imageView.hidden = YES;
  }

  return cell;
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
  NSInteger row = _outlineView.selectedRow;
  if (row >= 0 && _onSelectItem) {
    id item = [_outlineView itemAtRow:row];
    NSString *itemId = [item objectForKey:@"id"] ?: @"";
    NSString *title = [item objectForKey:@"title"] ?: @"";
    _onSelectItem(@{ @"id": itemId, @"title": title });
  }
}

- (void)layout {
  [super layout];
  _scrollView.frame = self.bounds;
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
@end

@interface RCTOutlineViewManager : RCTViewManager @end
@implementation RCTOutlineViewManager
RCT_EXPORT_MODULE(MacOSOutlineView)
- (NSView *)view { return [[RCTOutlineViewWrapper alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(items, NSArray)
RCT_EXPORT_VIEW_PROPERTY(headerVisible, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onSelectItem, RCTBubblingEventBlock)
@end

// ============================================================
// 41. NSSharingService — MacOSShareModule (imperative)
// ============================================================

@interface MacOSShareModule : NSObject <RCTBridgeModule>
@end

@implementation MacOSShareModule

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup { return NO; }

RCT_EXPORT_METHOD(share:(NSArray<NSString *> *)items
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    NSMutableArray *shareItems = [NSMutableArray array];
    for (NSString *item in items) {
      NSURL *url = [NSURL URLWithString:item];
      if (url && url.scheme.length > 0) {
        [shareItems addObject:url];
      } else {
        [shareItems addObject:item];
      }
    }
    if (shareItems.count == 0) {
      reject(@"EMPTY", @"No items to share", nil);
      return;
    }
    NSSharingServicePicker *picker = [[NSSharingServicePicker alloc] initWithItems:shareItems];
    NSWindow *win = [NSApp keyWindow];
    NSView *anchor = win.contentView;
    if (anchor) {
      NSRect rect = NSMakeRect(NSMidX(anchor.bounds), NSMidY(anchor.bounds), 1, 1);
      [picker showRelativeToRect:rect ofView:anchor preferredEdge:NSRectEdgeMinY];
    }
    resolve(@(YES));
  });
}

@end

// ============================================================
// 42. UNUserNotificationCenter — MacOSNotificationModule (imperative)
// ============================================================

@interface MacOSNotificationModule : NSObject <RCTBridgeModule>
@end

@implementation MacOSNotificationModule

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup { return NO; }

RCT_EXPORT_METHOD(notify:(NSString *)title
                  body:(NSString *)body
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
  [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound)
                        completionHandler:^(BOOL granted, NSError *error) {
    if (!granted) {
      reject(@"DENIED", @"Notification permission denied", error);
      return;
    }
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title ?: @"";
    content.body = body ?: @"";
    content.sound = [UNNotificationSound defaultSound];

    NSString *reqId = [[NSUUID UUID] UUIDString];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:reqId
                                                                          content:content
                                                                          trigger:nil];
    [center addNotificationRequest:request withCompletionHandler:^(NSError *err) {
      if (err) reject(@"FAIL", err.localizedDescription, err);
      else resolve(@(YES));
    }];
  }];
}

@end

// ============================================================
// 43. NSSound — MacOSSoundModule (imperative)
// ============================================================

@interface MacOSSoundModule : NSObject <RCTBridgeModule>
@end

@implementation MacOSSoundModule

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup { return NO; }

RCT_EXPORT_METHOD(play:(NSString *)name
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    NSSound *sound = [NSSound soundNamed:name];
    if (sound) {
      [sound play];
      resolve(@(YES));
    } else {
      reject(@"NOT_FOUND", [NSString stringWithFormat:@"Sound '%@' not found", name], nil);
    }
  });
}

RCT_EXPORT_METHOD(beep:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    NSBeep();
    resolve(@(YES));
  });
}

@end

// ============================================================
// 44. NSStatusBar — MacOSStatusBarModule (imperative)
// ============================================================

@interface MacOSStatusBarModule : NSObject <RCTBridgeModule>
@property (nonatomic, strong) NSStatusItem *statusItem;
@end

@implementation MacOSStatusBarModule

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup { return NO; }

RCT_EXPORT_METHOD(set:(NSDictionary *)config
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    if (!self.statusItem) {
      self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    }
    NSString *title = config[@"title"];
    NSString *sfSymbol = config[@"sfSymbol"];
    NSArray<NSDictionary *> *menuItems = config[@"menuItems"];

    if (sfSymbol.length > 0) {
      self.statusItem.button.image = [NSImage imageWithSystemSymbolName:sfSymbol accessibilityDescription:title ?: @""];
    }
    if (title.length > 0) {
      self.statusItem.button.title = title;
    }

    if (menuItems.count > 0) {
      NSMenu *menu = [[NSMenu alloc] initWithTitle:@""];
      for (NSDictionary *mi in menuItems) {
        NSString *miTitle = mi[@"title"] ?: @"";
        NSString *miId = mi[@"id"] ?: @"";
        if ([miTitle isEqualToString:@"-"]) {
          [menu addItem:[NSMenuItem separatorItem]];
        } else {
          NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:miTitle action:@selector(statusMenuClicked:) keyEquivalent:@""];
          item.representedObject = miId;
          item.target = self;
          [menu addItem:item];
        }
      }
      self.statusItem.menu = menu;
    }
    resolve(@(YES));
  });
}

- (void)statusMenuClicked:(NSMenuItem *)sender {
  NSString *itemId = sender.representedObject ?: @"";
  // Emit event via bridge notification
  [[NSNotificationCenter defaultCenter] postNotificationName:@"MacOSStatusBarItemClicked"
                                                      object:nil
                                                    userInfo:@{ @"id": itemId }];
}

RCT_EXPORT_METHOD(remove:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self.statusItem) {
      [[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
      self.statusItem = nil;
    }
    resolve(@(YES));
  });
}

@end

// ============================================================
// 45. MKMapView — MacOSMapView
// ============================================================

@interface RCTMapViewWrapper : NSView <MKMapViewDelegate>
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;
@property (nonatomic, assign) CLLocationDegrees latitudeDelta;
@property (nonatomic, assign) CLLocationDegrees longitudeDelta;
@property (nonatomic, copy) NSString *mapType;
@property (nonatomic, assign) BOOL showsUserLocation;
@property (nonatomic, strong) NSArray<NSDictionary *> *annotations;
@property (nonatomic, copy) RCTBubblingEventBlock onRegionChange;
@property (nonatomic, copy) RCTBubblingEventBlock onSelectAnnotation;
@property (nonatomic, assign) BOOL suppressRegionChange;
@end

@implementation RCTMapViewWrapper

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _mapView = [[MKMapView alloc] initWithFrame:self.bounds];
    _mapView.delegate = self;
    _mapView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    _latitude = 37.7749;
    _longitude = -122.4194;
    _latitudeDelta = 0.05;
    _longitudeDelta = 0.05;
    [self addSubview:_mapView];
  }
  return self;
}

- (void)updateRegion {
  _suppressRegionChange = YES;
  MKCoordinateRegion region = MKCoordinateRegionMake(
    CLLocationCoordinate2DMake(_latitude, _longitude),
    MKCoordinateSpanMake(_latitudeDelta, _longitudeDelta)
  );
  [_mapView setRegion:region animated:YES];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    self->_suppressRegionChange = NO;
  });
}

- (void)setLatitude:(CLLocationDegrees)latitude {
  _latitude = latitude;
  [self updateRegion];
}

- (void)setLongitude:(CLLocationDegrees)longitude {
  _longitude = longitude;
  [self updateRegion];
}

- (void)setLatitudeDelta:(CLLocationDegrees)latitudeDelta {
  _latitudeDelta = latitudeDelta;
  [self updateRegion];
}

- (void)setLongitudeDelta:(CLLocationDegrees)longitudeDelta {
  _longitudeDelta = longitudeDelta;
  [self updateRegion];
}

- (void)setMapType:(NSString *)mapType {
  _mapType = mapType;
  if ([mapType isEqualToString:@"satellite"]) _mapView.mapType = MKMapTypeSatellite;
  else if ([mapType isEqualToString:@"hybrid"]) _mapView.mapType = MKMapTypeHybrid;
  else _mapView.mapType = MKMapTypeStandard;
}

- (void)setShowsUserLocation:(BOOL)showsUserLocation {
  _showsUserLocation = showsUserLocation;
  _mapView.showsUserLocation = showsUserLocation;
}

- (void)setAnnotations:(NSArray<NSDictionary *> *)annotations {
  _annotations = annotations;
  [_mapView removeAnnotations:_mapView.annotations];
  for (NSDictionary *ann in annotations) {
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(
      [ann[@"latitude"] doubleValue],
      [ann[@"longitude"] doubleValue]
    );
    point.title = ann[@"title"] ?: @"";
    point.subtitle = ann[@"subtitle"] ?: @"";
    [_mapView addAnnotation:point];
  }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
  if (_suppressRegionChange) return;
  if (_onRegionChange) {
    MKCoordinateRegion r = mapView.region;
    _onRegionChange(@{
      @"latitude": @(r.center.latitude),
      @"longitude": @(r.center.longitude),
      @"latitudeDelta": @(r.span.latitudeDelta),
      @"longitudeDelta": @(r.span.longitudeDelta),
    });
  }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
  if (_onSelectAnnotation && view.annotation) {
    id<MKAnnotation> ann = view.annotation;
    _onSelectAnnotation(@{
      @"title": ann.title ?: @"",
      @"latitude": @(ann.coordinate.latitude),
      @"longitude": @(ann.coordinate.longitude),
    });
  }
}

- (void)layout {
  [super layout];
  _mapView.frame = self.bounds;
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
@end

@interface RCTMapViewManager : RCTViewManager @end
@implementation RCTMapViewManager
RCT_EXPORT_MODULE(MacOSMapView)
- (NSView *)view { return [[RCTMapViewWrapper alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(latitude, double)
RCT_EXPORT_VIEW_PROPERTY(longitude, double)
RCT_EXPORT_VIEW_PROPERTY(latitudeDelta, double)
RCT_EXPORT_VIEW_PROPERTY(longitudeDelta, double)
RCT_EXPORT_VIEW_PROPERTY(mapType, NSString)
RCT_EXPORT_VIEW_PROPERTY(showsUserLocation, BOOL)
RCT_EXPORT_VIEW_PROPERTY(annotations, NSArray)
RCT_EXPORT_VIEW_PROPERTY(onRegionChange, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onSelectAnnotation, RCTBubblingEventBlock)
@end

// ============================================================
// 46. PDFView — MacOSPDFView
// ============================================================

@interface RCTPDFViewWrapper : NSView
@property (nonatomic, strong) PDFView *pdfView;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, assign) BOOL autoScales;
@property (nonatomic, copy) NSString *displayMode;
@property (nonatomic, copy) RCTBubblingEventBlock onPageChange;
@end

@implementation RCTPDFViewWrapper

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _pdfView = [[PDFView alloc] initWithFrame:self.bounds];
    _pdfView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    _pdfView.autoScales = YES;
    [self addSubview:_pdfView];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pageChanged:)
                                                 name:PDFViewPageChangedNotification
                                               object:_pdfView];
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)pageChanged:(NSNotification *)note {
  if (_onPageChange && _pdfView.document) {
    PDFPage *page = _pdfView.currentPage;
    NSUInteger idx = page ? [_pdfView.document indexForPage:page] : 0;
    NSUInteger total = _pdfView.document.pageCount;
    _onPageChange(@{ @"pageIndex": @(idx), @"pageCount": @(total) });
  }
}

- (void)setSource:(NSString *)source {
  _source = source;
  if (source.length == 0) { _pdfView.document = nil; return; }
  NSURL *url;
  if ([source hasPrefix:@"/"]) {
    url = [NSURL fileURLWithPath:source];
  } else {
    url = [NSURL URLWithString:source];
  }
  if (url) {
    PDFDocument *doc = [[PDFDocument alloc] initWithURL:url];
    _pdfView.document = doc;
  }
}

- (void)setAutoScales:(BOOL)autoScales {
  _autoScales = autoScales;
  _pdfView.autoScales = autoScales;
}

- (void)setDisplayMode:(NSString *)displayMode {
  _displayMode = displayMode;
  if ([displayMode isEqualToString:@"singlePage"]) _pdfView.displayMode = kPDFDisplaySinglePage;
  else if ([displayMode isEqualToString:@"twoUp"]) _pdfView.displayMode = kPDFDisplayTwoUp;
  else if ([displayMode isEqualToString:@"singlePageContinuous"]) _pdfView.displayMode = kPDFDisplaySinglePageContinuous;
  else _pdfView.displayMode = kPDFDisplaySinglePageContinuous;
}

- (void)layout {
  [super layout];
  _pdfView.frame = self.bounds;
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
@end

@interface RCTPDFViewManager : RCTViewManager @end
@implementation RCTPDFViewManager
RCT_EXPORT_MODULE(MacOSPDFView)
- (NSView *)view { return [[RCTPDFViewWrapper alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(source, NSString)
RCT_EXPORT_VIEW_PROPERTY(autoScales, BOOL)
RCT_EXPORT_VIEW_PROPERTY(displayMode, NSString)
RCT_EXPORT_VIEW_PROPERTY(onPageChange, RCTBubblingEventBlock)
@end

// ============================================================
// 47. QLPreviewPanel — MacOSQuickLookModule (imperative)
// ============================================================

@interface MacOSQuickLookModule : NSObject <RCTBridgeModule, QLPreviewPanelDataSource, QLPreviewPanelDelegate>
@property (nonatomic, copy) NSString *filePath;
@end

@implementation MacOSQuickLookModule

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup { return NO; }

- (BOOL)acceptsPreviewPanelControl:(QLPreviewPanel *)panel { return YES; }
- (void)beginPreviewPanelControl:(QLPreviewPanel *)panel {
  panel.dataSource = self;
  panel.delegate = self;
}
- (void)endPreviewPanelControl:(QLPreviewPanel *)panel {}

- (NSInteger)numberOfPreviewItemsInPreviewPanel:(QLPreviewPanel *)panel { return 1; }

- (id<QLPreviewItem>)previewPanel:(QLPreviewPanel *)panel previewItemAtIndex:(NSInteger)index {
  if (_filePath.length > 0) {
    return [NSURL fileURLWithPath:_filePath];
  }
  return nil;
}

RCT_EXPORT_METHOD(preview:(NSString *)path
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    self.filePath = path;
    QLPreviewPanel *panel = [QLPreviewPanel sharedPreviewPanel];
    panel.dataSource = self;
    panel.delegate = self;
    if (panel.isVisible) {
      [panel reloadData];
    } else {
      [panel makeKeyAndOrderFront:nil];
    }
    resolve(@(YES));
  });
}

@end

// ============================================================
// 48. NSSpeechSynthesizer — MacOSSpeechModule (imperative)
// ============================================================

@interface MacOSSpeechModule : NSObject <RCTBridgeModule>
@property (nonatomic, strong) NSSpeechSynthesizer *synth;
@end

@implementation MacOSSpeechModule

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup { return NO; }

RCT_EXPORT_METHOD(say:(NSString *)text
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    if (!self.synth) self.synth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
    [self.synth stopSpeaking];
    [self.synth startSpeakingString:text ?: @""];
    resolve(@(YES));
  });
}

RCT_EXPORT_METHOD(sayWithVoice:(NSString *)text
                  voice:(NSString *)voice
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    if (!self.synth) self.synth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
    [self.synth setVoice:voice];
    [self.synth stopSpeaking];
    [self.synth startSpeakingString:text ?: @""];
    resolve(@(YES));
  });
}

RCT_EXPORT_METHOD(stop:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.synth stopSpeaking];
    resolve(@(YES));
  });
}

@end

// ============================================================
// 49. NSColorPanel — MacOSColorPanelModule (imperative)
// ============================================================

@interface MacOSColorPanelModule : NSObject <RCTBridgeModule>
@end

@implementation MacOSColorPanelModule

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup { return NO; }

RCT_EXPORT_METHOD(show:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    [[NSColorPanel sharedColorPanel] orderFront:nil];
    resolve(@(YES));
  });
}

RCT_EXPORT_METHOD(hide:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    [[NSColorPanel sharedColorPanel] close];
    resolve(@(YES));
  });
}

@end

// ============================================================
// 50. NSFontPanel — MacOSFontPanelModule (imperative)
// ============================================================

@interface MacOSFontPanelModule : NSObject <RCTBridgeModule>
@end

@implementation MacOSFontPanelModule

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup { return NO; }

RCT_EXPORT_METHOD(show:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    [[NSFontManager sharedFontManager] orderFrontFontPanel:nil];
    resolve(@(YES));
  });
}

RCT_EXPORT_METHOD(hide:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    [[NSFontPanel sharedFontPanel] close];
    resolve(@(YES));
  });
}

@end

// ============================================================
// 51. Vision OCR — MacOSOCRModule (imperative)
// ============================================================

@interface MacOSOCRModule : NSObject <RCTBridgeModule>
@end

@implementation MacOSOCRModule

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup { return NO; }

RCT_EXPORT_METHOD(recognize:(NSString *)imagePath
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:imagePath];
    if (!image) {
      reject(@"NOT_FOUND", [NSString stringWithFormat:@"Image not found: %@", imagePath], nil);
      return;
    }

    NSBitmapImageRep *rep = nil;
    for (NSImageRep *r in image.representations) {
      if ([r isKindOfClass:[NSBitmapImageRep class]]) {
        rep = (NSBitmapImageRep *)r;
        break;
      }
    }
    if (!rep) {
      // Create bitmap rep from image
      CGImageRef cgRef = [image CGImageForProposedRect:NULL context:nil hints:nil];
      if (!cgRef) {
        reject(@"INVALID", @"Cannot create CGImage from file", nil);
        return;
      }
      rep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
    }

    CGImageRef cgImage = rep.CGImage;
    if (!cgImage) {
      reject(@"INVALID", @"Cannot get CGImage from bitmap", nil);
      return;
    }

    VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:cgImage options:@{}];

    VNRecognizeTextRequest *request = [[VNRecognizeTextRequest alloc] initWithCompletionHandler:^(VNRequest *req, NSError *error) {
      if (error) {
        reject(@"OCR_FAIL", error.localizedDescription, error);
        return;
      }
      NSMutableArray<NSString *> *lines = [NSMutableArray array];
      for (VNRecognizedTextObservation *obs in req.results) {
        VNRecognizedText *candidate = [[obs topCandidates:1] firstObject];
        if (candidate.string.length > 0) {
          [lines addObject:candidate.string];
        }
      }
      resolve([lines componentsJoinedByString:@"\n"]);
    }];
    request.recognitionLevel = VNRequestTextRecognitionLevelAccurate;

    NSError *err = nil;
    [handler performRequests:@[request] error:&err];
    if (err) {
      reject(@"OCR_FAIL", err.localizedDescription, err);
    }
  });
}

@end

// ============================================================
// 52. SFSpeechRecognizer — MacOSSpeechRecognitionModule (imperative)
// ============================================================

@interface MacOSSpeechRecognitionModule : NSObject <RCTBridgeModule>
@property (nonatomic, strong) SFSpeechRecognizer *recognizer;
@property (nonatomic, strong) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
@property (nonatomic, strong) SFSpeechRecognitionTask *recognitionTask;
@property (nonatomic, strong) AVAudioEngine *audioEngine;
@property (nonatomic, copy) NSString *latestTranscript;
@end

@implementation MacOSSpeechRecognitionModule

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup { return NO; }

RCT_EXPORT_METHOD(start:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  NSLog(@"[SpeechRecognition] Requesting authorization...");
  [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
    NSLog(@"[SpeechRecognition] Authorization status: %ld", (long)status);
    if (status != SFSpeechRecognizerAuthorizationStatusAuthorized) {
      reject(@"DENIED", @"Speech recognition permission denied", nil);
      return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
      // Stop any existing session
      if (self.audioEngine.isRunning) {
        [self.audioEngine stop];
        [self.recognitionRequest endAudio];
      }

      self.latestTranscript = @"";
      // Use en-US explicitly — currentLocale can return region-specific locales that
      // on-device speech recognition doesn't support
      NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
      self.recognizer = [[SFSpeechRecognizer alloc] initWithLocale:locale];
      NSLog(@"[SpeechRecognition] Recognizer available: %d, supportsOnDevice: %d, locale: %@",
            self.recognizer.isAvailable,
            self.recognizer.supportsOnDeviceRecognition,
            self.recognizer.locale.localeIdentifier);

      if (!self.recognizer.isAvailable) {
        reject(@"UNAVAILABLE", @"Speech recognizer is not available for this locale", nil);
        return;
      }

      self.audioEngine = [[AVAudioEngine alloc] init];
      self.recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
      self.recognitionRequest.shouldReportPartialResults = YES;
      // Do NOT require on-device — let it use server-based recognition
      // On-device may not have the language model downloaded
      self.recognitionRequest.requiresOnDeviceRecognition = NO;

      AVAudioInputNode *inputNode = self.audioEngine.inputNode;
      // Use nil format — let the system pick the right format for the input node
      AVAudioFormat *format = [inputNode outputFormatForBus:0];
      NSLog(@"[SpeechRecognition] Audio format: sampleRate=%f channels=%u", format.sampleRate, format.channelCount);

      [inputNode installTapOnBus:0 bufferSize:4096 format:format block:^(AVAudioPCMBuffer *buffer, AVAudioTime *when) {
        [self.recognitionRequest appendAudioPCMBuffer:buffer];
      }];

      self.recognitionTask = [self.recognizer recognitionTaskWithRequest:self.recognitionRequest
                                                          resultHandler:^(SFSpeechRecognitionResult *result, NSError *error) {
        if (error) {
          NSLog(@"[SpeechRecognition] Error: %@ (code: %ld, domain: %@)",
                error.localizedDescription, (long)error.code, error.domain);
        }
        if (result) {
          self.latestTranscript = result.bestTranscription.formattedString;
          NSLog(@"[SpeechRecognition] Transcript: %@", self.latestTranscript);
        }
        if (error || result.isFinal) {
          [self.audioEngine stop];
          [inputNode removeTapOnBus:0];
          self.recognitionRequest = nil;
          self.recognitionTask = nil;
        }
      }];

      [self.audioEngine prepare];
      NSError *err = nil;
      [self.audioEngine startAndReturnError:&err];
      if (err) {
        NSLog(@"[SpeechRecognition] Engine start error: %@", err.localizedDescription);
        reject(@"ENGINE_FAIL", err.localizedDescription, err);
        return;
      }
      NSLog(@"[SpeechRecognition] Engine started successfully");
      resolve(@"started");
    });
  }];
}

RCT_EXPORT_METHOD(stop:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self.audioEngine.isRunning) {
      [self.audioEngine stop];
      [self.recognitionRequest endAudio];
    }
    resolve(self.latestTranscript ?: @"");
  });
}

RCT_EXPORT_METHOD(getTranscript:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  resolve(self.latestTranscript ?: @"");
}

@end

// ============================================================
// 53. NaturalLanguage — MacOSNLModule (imperative)
// ============================================================

@interface MacOSNLModule : NSObject <RCTBridgeModule>
@end

@implementation MacOSNLModule

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup { return NO; }

RCT_EXPORT_METHOD(detectLanguage:(NSString *)text
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  NLLanguageRecognizer *recognizer = [[NLLanguageRecognizer alloc] init];
  [recognizer processString:text ?: @""];
  NLLanguage lang = recognizer.dominantLanguage;
  resolve(lang ?: @"unknown");
}

RCT_EXPORT_METHOD(sentiment:(NSString *)text
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  NLTagger *tagger = [[NLTagger alloc] initWithTagSchemes:@[NLTagSchemeSentimentScore]];
  tagger.string = text ?: @"";
  NSRange tokenRange;
  NLTag tag = [tagger tagAtIndex:0 unit:NLTokenUnitParagraph scheme:NLTagSchemeSentimentScore tokenRange:&tokenRange];
  double score = tag ? tag.doubleValue : 0.0;
  resolve(@(score));
}

RCT_EXPORT_METHOD(tokenize:(NSString *)text
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  NLTokenizer *tokenizer = [[NLTokenizer alloc] initWithUnit:NLTokenUnitWord];
  tokenizer.string = text ?: @"";
  NSMutableArray<NSString *> *tokens = [NSMutableArray array];
  [tokenizer enumerateTokensInRange:NSMakeRange(0, text.length)
                         usingBlock:^(NSRange tokenRange, NLTokenizerAttributes attributes, BOOL *stop) {
    [tokens addObject:[text substringWithRange:tokenRange]];
  }];
  resolve(tokens);
}

@end

// ── Section 54: Camera View ─────────────────────────────────────────────────
// Live camera preview using AVCaptureVideoPreviewLayer

@interface RCTCameraView : NSView
@property (nonatomic, assign) BOOL active;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@end

@implementation RCTCameraView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.wantsLayer = YES;
    _active = NO;
  }
  return self;
}

- (NSSize)intrinsicContentSize {
  return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric);
}

- (void)setActive:(BOOL)active {
  _active = active;
  if (active) {
    [self startCapture];
  } else {
    [self stopCapture];
  }
}

- (void)startCapture {
  if (_session) return;

  AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  if (!device) {
    NSLog(@"[CameraView] No video device found");
    return;
  }

  NSError *error = nil;
  AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
  if (error) {
    NSLog(@"[CameraView] Input error: %@", error);
    return;
  }

  _session = [[AVCaptureSession alloc] init];
  _session.sessionPreset = AVCaptureSessionPresetMedium;
  [_session addInput:input];

  _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
  _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
  _previewLayer.frame = self.bounds;
  [self.layer addSublayer:_previewLayer];

  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [self->_session startRunning];
  });
}

- (void)stopCapture {
  if (!_session) return;
  [_session stopRunning];
  [_previewLayer removeFromSuperlayer];
  _previewLayer = nil;
  _session = nil;
}

- (void)layout {
  [super layout];
  _previewLayer.frame = self.bounds;
}

- (void)dealloc {
  [self stopCapture];
}

@end

@interface RCTCameraViewManager : RCTViewManager @end
@implementation RCTCameraViewManager
RCT_EXPORT_MODULE(MacOSCameraView)
- (NSView *)view { return [[RCTCameraView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(active, BOOL)
@end

// ============================================================
// Rich Text Label — read-only NSTextView with inline emoji images
// ============================================================

// Holds pre-rendered frames for one animated GIF
@interface RCTGifAnimation : NSObject
@property (nonatomic, strong) NSArray<id> *cgFrames; // array of CGImageRef (bridged as id)
@property (nonatomic, strong) CALayer *layer;
@property (nonatomic, assign) NSUInteger charIndex;  // position in attributed string
@property (nonatomic, assign) NSUInteger currentFrame;
@end

@implementation RCTGifAnimation
@end

@interface RCTNativeRichTextLabelView : NSView
@property (nonatomic, strong) NSTextStorage *textStorage;
@property (nonatomic, strong) NSLayoutManager *layoutManager;
@property (nonatomic, strong) NSTextContainer *textContainer;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSDictionary *emojiMap;
@property (nonatomic, copy) NSString *textColor;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat emojiSize;
@property (nonatomic, strong) NSTimer *gifTimer;
@property (nonatomic, strong) NSMutableArray<RCTGifAnimation *> *gifAnimations;
@property (nonatomic, weak) RCTBridge *bridge;
@property (nonatomic, assign) CGSize measuredContentSize;
@end

@implementation RCTNativeRichTextLabelView

- (BOOL)isFlipped { return YES; }

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _fontSize = 14.0;
    _emojiSize = 0;
    _textColor = @"#FFFFFF";

    _textStorage = [[NSTextStorage alloc] init];
    _layoutManager = [[NSLayoutManager alloc] init];
    _textContainer = [[NSTextContainer alloc] initWithContainerSize:NSMakeSize(frame.size.width, FLT_MAX)];
    _textContainer.lineFragmentPadding = 0;
    [_layoutManager addTextContainer:_textContainer];
    [_textStorage addLayoutManager:_layoutManager];

    // Layer-back self for GIF animation sublayers only
    self.wantsLayer = YES;
    self.layer.contentsScale = [[NSScreen mainScreen] backingScaleFactor] ?: 2.0;
  }
  return self;
}

- (void)dealloc {
  [_gifTimer invalidate];
}

- (void)drawRect:(NSRect)dirtyRect {
  NSRange glyphRange = [_layoutManager glyphRangeForTextContainer:_textContainer];
  [_layoutManager drawBackgroundForGlyphRange:glyphRange atPoint:NSZeroPoint];
  [_layoutManager drawGlyphsForGlyphRange:glyphRange atPoint:NSZeroPoint];
}

- (void)stopGifAnimation {
  [_gifTimer invalidate];
  _gifTimer = nil;
  for (RCTGifAnimation *anim in _gifAnimations) {
    [anim.layer removeFromSuperlayer];
  }
  _gifAnimations = nil;
}

- (void)startGifAnimationIfNeeded {
  if (_gifAnimations.count == 0) return;
  if (_gifTimer) return;
  [self positionGifLayers];
  _gifTimer = [NSTimer scheduledTimerWithTimeInterval:0.06
                                               target:self
                                             selector:@selector(advanceGifFrames)
                                             userInfo:nil
                                              repeats:YES];
}

- (void)positionGifLayers {
  CGFloat viewHeight = self.frame.size.height;
  CGFloat es = _emojiSize > 0 ? _emojiSize : (_fontSize > 0 ? _fontSize : 14.0) * 1.3;

  for (RCTGifAnimation *anim in _gifAnimations) {
    NSUInteger charIdx = anim.charIndex;
    if (charIdx >= _textStorage.length) continue;
    NSRange glyphRange = [_layoutManager glyphRangeForCharacterRange:NSMakeRange(charIdx, 1) actualCharacterRange:NULL];
    NSRect glyphRect = [_layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:_textContainer];
    // Flip Y for CALayer (CALayer origin is bottom-left, view is flipped)
    CGFloat layerY = viewHeight - glyphRect.origin.y - es;
    anim.layer.frame = CGRectMake(glyphRect.origin.x, layerY, es, es);
  }
}

- (void)advanceGifFrames {
  for (RCTGifAnimation *anim in _gifAnimations) {
    anim.currentFrame = (anim.currentFrame + 1) % anim.cgFrames.count;
    anim.layer.contents = anim.cgFrames[anim.currentFrame];
  }
}

- (void)setText:(NSString *)text {
  _text = text;
  [self rebuildAttributedString];
}

- (void)setEmojiMap:(NSDictionary *)emojiMap {
  _emojiMap = emojiMap;
  [self rebuildAttributedString];
}

- (void)setTextColor:(NSString *)textColor {
  _textColor = textColor;
  [self rebuildAttributedString];
}

- (void)setFontSize:(CGFloat)fontSize {
  _fontSize = fontSize;
  [self rebuildAttributedString];
}

- (void)setEmojiSize:(CGFloat)emojiSize {
  _emojiSize = emojiSize;
  [self rebuildAttributedString];
}

- (NSColor *)parsedTextColor {
  NSString *hex = _textColor ?: @"#FFFFFF";
  if ([hex hasPrefix:@"#"]) hex = [hex substringFromIndex:1];
  unsigned int rgb = 0;
  [[NSScanner scannerWithString:hex] scanHexInt:&rgb];
  return [NSColor colorWithSRGBRed:((rgb >> 16) & 0xFF) / 255.0
                             green:((rgb >> 8) & 0xFF) / 255.0
                              blue:(rgb & 0xFF) / 255.0
                             alpha:1.0];
}

- (void)rebuildAttributedString {
  if (!_text) return;

  [self stopGifAnimation];
  _gifAnimations = [NSMutableArray new];

  CGFloat fs = _fontSize > 0 ? _fontSize : 14.0;
  NSFont *font = [NSFont systemFontOfSize:fs];
  CGFloat es = _emojiSize > 0 ? _emojiSize : (font.ascender - font.descender);
  NSColor *color = [self parsedTextColor];
  NSDictionary *textAttrs = @{
    NSFontAttributeName: font,
    NSForegroundColorAttributeName: color,
  };

  NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];

  NSRegularExpression *regex = [NSRegularExpression
    regularExpressionWithPattern:@":([a-zA-Z0-9_]+):"
    options:0 error:nil];

  NSUInteger pos = 0;
  NSArray *matches = [regex matchesInString:_text options:0 range:NSMakeRange(0, _text.length)];

  for (NSTextCheckingResult *match in matches) {
    NSRange fullRange = [match range];
    if (fullRange.location > pos) {
      NSString *before = [_text substringWithRange:NSMakeRange(pos, fullRange.location - pos)];
      [result appendAttributedString:[[NSAttributedString alloc] initWithString:before attributes:textAttrs]];
    }

    NSString *emojiName = [_text substringWithRange:[match rangeAtIndex:1]];
    NSString *imagePath = _emojiMap[emojiName];
    NSImage *image = nil;
    NSArray *gifFrames = nil;
    NSInteger gifFrameCount = 0;

    if (imagePath) {
      NSString *bundlePath = nil;
      if ([imagePath hasPrefix:@"/"]) {
        bundlePath = imagePath;
      } else if ([imagePath hasPrefix:@"http"]) {
        NSURL *url = [NSURL URLWithString:imagePath];
        image = [[NSImage alloc] initWithContentsOfURL:url];
      } else {
        bundlePath = [[NSBundle mainBundle] pathForResource:[imagePath stringByDeletingPathExtension]
                                                     ofType:[imagePath pathExtension]];
      }

      if (bundlePath) {
        if ([[imagePath pathExtension] caseInsensitiveCompare:@"gif"] == NSOrderedSame) {
          NSData *data = [NSData dataWithContentsOfFile:bundlePath];
          if (data) {
            NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithData:data];
            NSNumber *frameCountNum = [rep valueForProperty:NSImageFrameCount];
            if (frameCountNum && [frameCountNum integerValue] > 1) {
              gifFrameCount = [frameCountNum integerValue];
              NSMutableArray *frames = [NSMutableArray arrayWithCapacity:gifFrameCount];
              for (NSInteger f = 0; f < gifFrameCount; f++) {
                [rep setProperty:NSImageCurrentFrame withValue:@(f)];
                CGImageRef cgImg = [rep CGImageForProposedRect:NULL context:nil hints:nil];
                if (cgImg) [frames addObject:(__bridge id)cgImg];
              }
              if (frames.count > 0) {
                gifFrames = frames;
                image = [[NSImage alloc] initWithSize:NSMakeSize(es, es)];
              }
            } else {
              image = [[NSImage alloc] initWithContentsOfFile:bundlePath];
            }
          }
        } else {
          image = [[NSImage alloc] initWithContentsOfFile:bundlePath];
        }
      }
    }

    if (image) {
      NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
      CGFloat yOffset = font.descender;
      attachment.bounds = CGRectMake(0, yOffset, es, es);
      attachment.image = image;
      NSAttributedString *emojiStr = [NSAttributedString attributedStringWithAttachment:attachment];
      [result appendAttributedString:emojiStr];

      if (gifFrames && gifFrames.count > 1) {
        RCTGifAnimation *anim = [[RCTGifAnimation alloc] init];
        anim.cgFrames = gifFrames;
        anim.charIndex = result.length - 1;
        anim.currentFrame = 0;
        anim.layer = [CALayer layer];
        anim.layer.contentsGravity = kCAGravityResizeAspect;
        anim.layer.contents = gifFrames[0];
        [self.layer addSublayer:anim.layer];
        [_gifAnimations addObject:anim];
      }
    } else {
      NSString *fallback = [_text substringWithRange:fullRange];
      [result appendAttributedString:[[NSAttributedString alloc] initWithString:fallback attributes:textAttrs]];
    }

    pos = NSMaxRange(fullRange);
  }

  if (pos < _text.length) {
    NSString *tail = [_text substringFromIndex:pos];
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:tail attributes:textAttrs]];
  }

  [_textStorage setAttributedString:result];
  [self startGifAnimationIfNeeded];
  [self setNeedsDisplay:YES];

  // Measure the content size using a temp layout manager (unbounded width)
  NSTextContainer *tempContainer = [[NSTextContainer alloc] initWithContainerSize:NSMakeSize(CGFLOAT_MAX, CGFLOAT_MAX)];
  tempContainer.lineFragmentPadding = 0;
  NSLayoutManager *tempLayoutManager = [[NSLayoutManager alloc] init];
  [tempLayoutManager addTextContainer:tempContainer];
  NSTextStorage *tempStorage = [[NSTextStorage alloc] initWithAttributedString:result];
  [tempStorage addLayoutManager:tempLayoutManager];
  [tempLayoutManager ensureLayoutForTextContainer:tempContainer];
  NSRect usedRect = [tempLayoutManager usedRectForTextContainer:tempContainer];
  _measuredContentSize = CGSizeMake(ceil(usedRect.size.width), ceil(usedRect.size.height));
  NSLog(@"[RichTextLabel] rebuildAttributedString: text=%@ measuredSize=%@", _text, NSStringFromSize(_measuredContentSize));
}

- (void)didSetProps:(NSArray<NSString *> *)changedProps
{
  if (_bridge && !CGSizeEqualToSize(_measuredContentSize, CGSizeZero)) {
    CGSize size = _measuredContentSize;
    RCTUIManager *uiManager = [_bridge moduleForClass:[RCTUIManager class]];
    [uiManager setIntrinsicContentSize:size forView:self];
  }
}

- (NSSize)intrinsicContentSize {
  if (!CGSizeEqualToSize(_measuredContentSize, CGSizeZero)) {
    return _measuredContentSize;
  }
  return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric);
}


- (void)reactSetFrame:(CGRect)frame {
  [super reactSetFrame:frame];
  _textContainer.containerSize = NSMakeSize(frame.size.width, FLT_MAX);
  [_layoutManager ensureLayoutForTextContainer:_textContainer];
  [self positionGifLayers];
  [self setNeedsDisplay:YES];
}

- (void)layout {
  [super layout];
  _textContainer.containerSize = NSMakeSize(self.bounds.size.width, FLT_MAX);
  [_layoutManager ensureLayoutForTextContainer:_textContainer];
  [self positionGifLayers];
  [self setNeedsDisplay:YES];
}

@end

@interface RCTNativeRichTextLabelViewManager : RCTViewManager @end
@implementation RCTNativeRichTextLabelViewManager
RCT_EXPORT_MODULE(NativeRichTextLabel)
- (NSView *)view {
  RCTNativeRichTextLabelView *view = [[RCTNativeRichTextLabelView alloc] initWithFrame:CGRectZero];
  view.bridge = self.bridge;
  return view;
}
RCT_EXPORT_VIEW_PROPERTY(text, NSString)
RCT_EXPORT_VIEW_PROPERTY(emojiMap, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(textColor, NSString)
RCT_EXPORT_VIEW_PROPERTY(fontSize, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(emojiSize, CGFloat)
@end

// ============================================================
// Hover View — container with NSTrackingArea for hover detection
// ============================================================

@interface RCTHoverView : NSView
@property (nonatomic, copy) RCTBubblingEventBlock onHoverChange;
@property (nonatomic, copy) RCTBubblingEventBlock onPress;
@property (nonatomic, strong) NSTrackingArea *trackingArea;
@end

@implementation RCTHoverView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self setupTracking];
  }
  return self;
}

- (void)setupTracking {
  if (_trackingArea) [self removeTrackingArea:_trackingArea];
  _trackingArea = [[NSTrackingArea alloc]
    initWithRect:self.bounds
         options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow | NSTrackingInVisibleRect)
           owner:self
        userInfo:nil];
  [self addTrackingArea:_trackingArea];
}

- (void)updateTrackingAreas {
  [super updateTrackingAreas];
  [self setupTracking];
}

- (void)mouseEntered:(NSEvent *)event {
  if (_onHoverChange) _onHoverChange(@{@"hovered": @(YES)});
}

- (void)mouseExited:(NSEvent *)event {
  if (_onHoverChange) _onHoverChange(@{@"hovered": @(NO)});
}

- (void)mouseDown:(NSEvent *)event {
  if (_onPress) _onPress(@{});
  else [super mouseDown:event];
}

- (NSSize)intrinsicContentSize { return NSMakeSize(NSViewNoIntrinsicMetric, NSViewNoIntrinsicMetric); }
@end

@interface RCTHoverViewManager : RCTViewManager @end
@implementation RCTHoverViewManager
RCT_EXPORT_MODULE(MacOSHoverView)
- (NSView *)view { return [[RCTHoverView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(onHoverChange, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onPress, RCTBubblingEventBlock)
@end
