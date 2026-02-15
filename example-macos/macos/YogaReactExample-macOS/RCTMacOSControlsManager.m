#import <React/RCTViewManager.h>
#import <React/RCTBridge.h>
#import <AppKit/AppKit.h>
#import <WebKit/WebKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#import <QuartzCore/QuartzCore.h>
@import RiveRuntime;

// ============================================================
// 1. NSButton
// ============================================================

@interface RCTNativeButtonView : NSView
@property (nonatomic, strong) NSButton *button;
@property (nonatomic, copy) RCTBubblingEventBlock onPress;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *sfSymbol;
@property (nonatomic, copy) NSString *bezelStyle;
@property (nonatomic, assign) BOOL destructive;
@property (nonatomic, assign) BOOL primary;
@property (nonatomic, assign) BOOL buttonEnabled;
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

- (void)handlePress {
  if (_onPress) _onPress(@{});
}

- (void)setTitle:(NSString *)title {
  _title = title;
  _button.title = title ?: @"";
}

- (void)setSfSymbol:(NSString *)sfSymbol {
  _sfSymbol = sfSymbol;
  if (sfSymbol.length > 0) {
    NSImage *img = [NSImage imageWithSystemSymbolName:sfSymbol accessibilityDescription:sfSymbol];
    if (img) _button.image = img;
  }
}

- (void)setBezelStyle:(NSString *)bezelStyle {
  _bezelStyle = bezelStyle;
  if ([bezelStyle isEqualToString:@"toolbar"]) _button.bezelStyle = NSBezelStyleToolbar;
  else if ([bezelStyle isEqualToString:@"texturedSquare"]) _button.bezelStyle = NSBezelStyleTexturedSquare;
  else if ([bezelStyle isEqualToString:@"inline"]) _button.bezelStyle = NSBezelStyleInline;
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
RCT_EXPORT_VIEW_PROPERTY(onPress, RCTBubblingEventBlock)
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

- (void)playerDidFinish:(NSNotification *)note {
  if (_looping && note.object == _player.currentItem) {
    [_player seekToTime:kCMTimeZero];
    [_player play];
  }
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
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
      NSData *data = [NSData dataWithContentsOfURL:url];
      if (!data) return;
      NSImage *image = [[NSImage alloc] initWithData:data];
      dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        strongSelf.image = image;
        [strongSelf setupAnimation];
        [strongSelf setNeedsDisplay:YES];
      });
    });
  } else {
    _image = [[NSImage alloc] initByReferencingFile:source];
    [self setupAnimation];
    [self setNeedsDisplay:YES];
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
  [self setNeedsDisplay:YES];
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
  [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
  if (!_image) return;
  NSGraphicsContext *ctx = [NSGraphicsContext currentContext];
  [ctx saveGraphicsState];

  if (_cornerRadius > 0) {
    NSBezierPath *clip = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:_cornerRadius yRadius:_cornerRadius];
    [clip addClip];
  }

  [_image drawInRect:self.bounds fromRect:NSZeroRect operation:NSCompositingOperationSourceOver fraction:1.0 respectFlipped:YES hints:nil];
  [ctx restoreGraphicsState];
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
@property (nonatomic, copy) NSString *backgroundColor2;
@property (nonatomic, assign) CGFloat patternOpacity;
@property (nonatomic, assign) CGFloat patternScale;
@end

@implementation RCTPatternBackgroundView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _patternColor = @"#FFFFFF";
    _backgroundColor2 = @"#17212B";
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

- (void)setBackgroundColor2:(NSString *)backgroundColor2 {
  _backgroundColor2 = backgroundColor2;
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

  NSColor *bgColor = [self colorFromHex:_backgroundColor2];
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
RCT_EXPORT_VIEW_PROPERTY(backgroundColor2, NSString)
RCT_EXPORT_VIEW_PROPERTY(patternOpacity, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(patternScale, CGFloat)
@end

// ===========================================================================
// MARK: - NSSplitView
// ===========================================================================

@interface RCTSplitView : NSView <NSSplitViewDelegate>
@property (nonatomic, strong) NSSplitView *splitView;
@property (nonatomic, assign) BOOL isVertical;
@property (nonatomic, assign) CGFloat dividerThicknessValue;
@property (nonatomic, strong) NSMutableArray<NSView *> *panes;
@end

@implementation RCTSplitView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _splitView = [[NSSplitView alloc] initWithFrame:self.bounds];
    _splitView.delegate = self;
    _splitView.dividerStyle = NSSplitViewDividerStyleThin;
    _splitView.vertical = YES;
    _splitView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    _panes = [NSMutableArray new];
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
  [_panes insertObject:subview atIndex:MIN(atIndex, (NSInteger)_panes.count)];
  [_splitView addSubview:subview];
}

- (void)removeReactSubview:(NSView *)subview {
  [_panes removeObject:subview];
  [subview removeFromSuperview];
}

- (NSArray<NSView *> *)reactSubviews {
  return [_panes copy];
}

- (void)didUpdateReactSubviews {
  [self performSelector:@selector(doLayout) withObject:nil afterDelay:0];
}

- (void)doLayout {
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
@property (nonatomic, copy) NSString *fillColorStr;
@property (nonatomic, copy) NSString *borderColorStr;
@property (nonatomic, assign) CGFloat cornerRadiusValue;
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

- (void)setFillColorStr:(NSString *)fillColorStr {
  _fillColorStr = fillColorStr;
  self.fillColor = [RCTBoxView colorFromHex:fillColorStr];
}

- (void)setBorderColorStr:(NSString *)borderColorStr {
  _borderColorStr = borderColorStr;
  self.borderColor = [RCTBoxView colorFromHex:borderColorStr];
}

- (void)setCornerRadiusValue:(CGFloat)cornerRadiusValue {
  _cornerRadiusValue = cornerRadiusValue;
  self.cornerRadius = cornerRadiusValue;
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
RCT_EXPORT_VIEW_PROPERTY(fillColorStr, NSString)
RCT_EXPORT_VIEW_PROPERTY(borderColorStr, NSString)
RCT_EXPORT_VIEW_PROPERTY(cornerRadiusValue, CGFloat)
@end

// ===========================================================================
// MARK: - NSPopover
// ===========================================================================

@interface RCTPopoverView : NSView
@property (nonatomic, strong) NSPopover *popover;
@property (nonatomic, strong) NSViewController *popoverVC;
@property (nonatomic, strong) NSView *contentContainer;
@property (nonatomic, assign) BOOL visible;
@property (nonatomic, copy) NSString *preferredEdge;
@property (nonatomic, copy) NSString *behavior;
@property (nonatomic, copy) RCTBubblingEventBlock onClose;
@end

@implementation RCTPopoverView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _contentContainer = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 200, 200)];
    _popoverVC = [[NSViewController alloc] init];
    _popoverVC.view = _contentContainer;

    _popover = [[NSPopover alloc] init];
    _popover.contentViewController = _popoverVC;
    _popover.behavior = NSPopoverBehaviorTransient;
    _popover.delegate = (id)self;
    _preferredEdge = @"bottom";
  }
  return self;
}

- (void)setVisible:(BOOL)visible {
  _visible = visible;
  if (visible) {
    if (!_popover.isShown && self.window) {
      NSRectEdge edge = [self edgeFromString:_preferredEdge];
      [_popover showRelativeToRect:self.bounds ofView:self preferredEdge:edge];
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

- (void)insertReactSubview:(NSView *)subview atIndex:(NSInteger)atIndex {
  [_contentContainer addSubview:subview];
}

- (void)removeReactSubview:(NSView *)subview {
  [subview removeFromSuperview];
}

- (NSArray<NSView *> *)reactSubviews {
  return _contentContainer.subviews;
}

- (void)didUpdateReactSubviews {
  [self performSelector:@selector(layoutPopoverContent) withObject:nil afterDelay:0];
}

- (void)layoutPopoverContent {
  CGFloat maxW = 0, maxH = 0;
  for (NSView *child in _contentContainer.subviews) {
    CGFloat r = CGRectGetMaxX(child.frame);
    CGFloat b = CGRectGetMaxY(child.frame);
    if (r > maxW) maxW = r;
    if (b > maxH) maxH = b;
  }
  if (maxW > 0 && maxH > 0) {
    _popover.contentSize = NSMakeSize(maxW, maxH);
    _contentContainer.frame = NSMakeRect(0, 0, maxW, maxH);
  }
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:source]];
      if (data) {
        NSImage *image = [[NSImage alloc] initWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
          if ([self->_source isEqualToString:source]) {
            self->_imageView.image = image;
          }
        });
      }
    });
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
