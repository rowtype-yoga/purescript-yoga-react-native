#import <React/RCTViewManager.h>
#import <React/RCTBridge.h>
#import <AppKit/AppKit.h>
#import <WebKit/WebKit.h>
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
}

- (void)viewDidMoveToWindow {
  [super viewDidMoveToWindow];
  if (self.window && !_mouseMonitor) {
    __weak typeof(self) weakSelf = self;
    _mouseMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskMouseMoved handler:^NSEvent *(NSEvent *event) {
      __strong typeof(weakSelf) strongSelf = weakSelf;
      if (!strongSelf || !strongSelf.riveView || !strongSelf.viewModel) return event;
      RiveModel *model = strongSelf.viewModel.riveModel;
      if (!model) return event;
      RiveStateMachineInstance *sm = [model valueForKey:@"stateMachine"];
      RiveArtboard *ab = [model valueForKey:@"artboard"];
      if (!sm || !ab) return event;
      CGPoint loc = [strongSelf.riveView convertPoint:event.locationInWindow fromView:nil];
      loc.y = strongSelf.riveView.bounds.size.height - loc.y;
      CGPoint artLoc = [strongSelf.riveView artboardLocationFromTouchLocation:loc
                                                                   inArtboard:[ab bounds]
                                                                          fit:strongSelf.viewModel.fit
                                                                    alignment:strongSelf.viewModel.alignment];
      [sm touchMovedAtLocation:artLoc];
      return event;
    }];
  } else if (!self.window && _mouseMonitor) {
    [NSEvent removeMonitor:_mouseMonitor];
    _mouseMonitor = nil;
  }
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
