#import <React/RCTViewManager.h>
#import <React/RCTBridge.h>
#import <AppKit/AppKit.h>
#import <WebKit/WebKit.h>

// ============================================================
// 1. Preferences-style view
// ============================================================

@interface RCTPreferencesView : NSView <NSToolbarDelegate>
@property (nonatomic, strong) NSTabView *tabView;
@property (nonatomic, strong) NSToolbar *prefsToolbar;
@property (nonatomic, copy) RCTBubblingEventBlock onTabChange;
@end

@implementation RCTPreferencesView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.wantsLayer = YES;

    _tabView = [[NSTabView alloc] initWithFrame:self.bounds];
    _tabView.tabViewType = NSNoTabsNoBorder;
    _tabView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self addSubview:_tabView];

    [self addPaneWithTitle:@"General" content:[self generalPane]];
    [self addPaneWithTitle:@"Appearance" content:[self appearancePane]];
    [self addPaneWithTitle:@"Notifications" content:[self notificationsPane]];
    [self addPaneWithTitle:@"Privacy" content:[self privacyPane]];
  }
  return self;
}

- (void)viewDidMoveToWindow {
  [super viewDidMoveToWindow];
  if (self.window && !_prefsToolbar) {
    _prefsToolbar = [[NSToolbar alloc] initWithIdentifier:@"PrefsToolbar"];
    _prefsToolbar.delegate = self;
    _prefsToolbar.displayMode = NSToolbarDisplayModeIconAndLabel;
    _prefsToolbar.selectedItemIdentifier = @"General";
    _prefsToolbar.allowsUserCustomization = NO;
    self.window.toolbar = _prefsToolbar;
    self.window.toolbarStyle = NSWindowToolbarStylePreference;
    self.window.title = @"Settings";
  }
}

- (void)addPaneWithTitle:(NSString *)title content:(NSView *)content {
  NSTabViewItem *item = [[NSTabViewItem alloc] initWithIdentifier:title];
  item.label = title;
  item.view = content;
  [_tabView addTabViewItem:item];
}

- (NSView *)generalPane {
  NSView *pane = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 500, 400)];
  NSTextField *header = [NSTextField labelWithString:@"General"];
  header.font = [NSFont systemFontOfSize:20 weight:NSFontWeightSemibold];
  header.frame = NSMakeRect(30, 350, 200, 30);
  [pane addSubview:header];

  NSButton *c1 = [NSButton checkboxWithTitle:@"Open at login" target:nil action:nil];
  c1.frame = NSMakeRect(30, 310, 250, 20);
  [pane addSubview:c1];

  NSButton *c2 = [NSButton checkboxWithTitle:@"Check for updates automatically" target:nil action:nil];
  c2.state = NSControlStateValueOn;
  c2.frame = NSMakeRect(30, 280, 280, 20);
  [pane addSubview:c2];

  NSButton *c3 = [NSButton checkboxWithTitle:@"Show in menu bar" target:nil action:nil];
  c3.state = NSControlStateValueOn;
  c3.frame = NSMakeRect(30, 250, 250, 20);
  [pane addSubview:c3];

  NSTextField *l1 = [NSTextField labelWithString:@"Default browser:"];
  l1.frame = NSMakeRect(30, 210, 120, 20);
  [pane addSubview:l1];

  NSPopUpButton *pop = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(155, 207, 200, 25) pullsDown:NO];
  [pop addItemsWithTitles:@[@"Safari", @"Chrome", @"Firefox", @"Arc"]];
  [pane addSubview:pop];

  NSTextField *l2 = [NSTextField labelWithString:@"Font size:"];
  l2.frame = NSMakeRect(30, 170, 120, 20);
  [pane addSubview:l2];

  NSSlider *sl = [NSSlider sliderWithValue:13 minValue:9 maxValue:24 target:nil action:nil];
  sl.frame = NSMakeRect(155, 170, 200, 20);
  [pane addSubview:sl];
  return pane;
}

- (NSView *)appearancePane {
  NSView *pane = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 500, 400)];
  NSTextField *header = [NSTextField labelWithString:@"Appearance"];
  header.font = [NSFont systemFontOfSize:20 weight:NSFontWeightSemibold];
  header.frame = NSMakeRect(30, 350, 200, 30);
  [pane addSubview:header];

  NSTextField *l1 = [NSTextField labelWithString:@"Theme:"];
  l1.frame = NSMakeRect(30, 310, 60, 20);
  [pane addSubview:l1];

  NSSegmentedControl *seg = [NSSegmentedControl segmentedControlWithLabels:@[@"Light", @"Dark", @"Auto"]
                                                              trackingMode:NSSegmentSwitchTrackingSelectOne target:nil action:nil];
  seg.selectedSegment = 2;
  seg.frame = NSMakeRect(95, 307, 250, 24);
  [pane addSubview:seg];

  NSTextField *l2 = [NSTextField labelWithString:@"Accent:"];
  l2.frame = NSMakeRect(30, 270, 60, 20);
  [pane addSubview:l2];

  NSColorWell *cw = [[NSColorWell alloc] initWithFrame:NSMakeRect(95, 265, 44, 30)];
  cw.color = [NSColor controlAccentColor];
  if (@available(macOS 13.0, *)) { cw.colorWellStyle = NSColorWellStyleMinimal; }
  [pane addSubview:cw];

  NSTextField *l3 = [NSTextField labelWithString:@"Sidebar size:"];
  l3.frame = NSMakeRect(30, 220, 100, 20);
  [pane addSubview:l3];

  NSButton *r1 = [NSButton radioButtonWithTitle:@"Small" target:nil action:nil];
  r1.frame = NSMakeRect(30, 195, 100, 20);
  [pane addSubview:r1];
  NSButton *r2 = [NSButton radioButtonWithTitle:@"Medium" target:nil action:nil];
  r2.state = NSControlStateValueOn;
  r2.frame = NSMakeRect(30, 170, 100, 20);
  [pane addSubview:r2];
  NSButton *r3 = [NSButton radioButtonWithTitle:@"Large" target:nil action:nil];
  r3.frame = NSMakeRect(30, 145, 100, 20);
  [pane addSubview:r3];
  return pane;
}

- (NSView *)notificationsPane {
  NSView *pane = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 500, 400)];
  NSTextField *header = [NSTextField labelWithString:@"Notifications"];
  header.font = [NSFont systemFontOfSize:20 weight:NSFontWeightSemibold];
  header.frame = NSMakeRect(30, 350, 200, 30);
  [pane addSubview:header];

  NSButton *c1 = [NSButton checkboxWithTitle:@"Show notifications" target:nil action:nil];
  c1.state = NSControlStateValueOn;
  c1.frame = NSMakeRect(30, 310, 250, 20);
  [pane addSubview:c1];
  NSButton *c2 = [NSButton checkboxWithTitle:@"Play sound for notifications" target:nil action:nil];
  c2.state = NSControlStateValueOn;
  c2.frame = NSMakeRect(30, 280, 280, 20);
  [pane addSubview:c2];
  NSButton *c3 = [NSButton checkboxWithTitle:@"Show badge on dock icon" target:nil action:nil];
  c3.frame = NSMakeRect(30, 250, 250, 20);
  [pane addSubview:c3];

  NSTextField *l1 = [NSTextField labelWithString:@"Notification style:"];
  l1.frame = NSMakeRect(30, 210, 130, 20);
  [pane addSubview:l1];
  NSPopUpButton *pop = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(165, 207, 200, 25) pullsDown:NO];
  [pop addItemsWithTitles:@[@"Banners", @"Alerts", @"None"]];
  [pane addSubview:pop];
  return pane;
}

- (NSView *)privacyPane {
  NSView *pane = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 500, 400)];
  NSTextField *header = [NSTextField labelWithString:@"Privacy & Security"];
  header.font = [NSFont systemFontOfSize:20 weight:NSFontWeightSemibold];
  header.frame = NSMakeRect(30, 350, 250, 30);
  [pane addSubview:header];

  NSProgressIndicator *prog = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(30, 310, 300, 20)];
  prog.style = NSProgressIndicatorStyleBar;
  prog.indeterminate = NO;
  prog.doubleValue = 75.0;
  [pane addSubview:prog];

  NSTextField *pl = [NSTextField labelWithString:@"Security scan: 75% complete"];
  pl.font = [NSFont systemFontOfSize:11];
  pl.textColor = [NSColor secondaryLabelColor];
  pl.frame = NSMakeRect(30, 288, 300, 16);
  [pane addSubview:pl];

  NSButton *c1 = [NSButton checkboxWithTitle:@"Require password after sleep" target:nil action:nil];
  c1.state = NSControlStateValueOn;
  c1.frame = NSMakeRect(30, 250, 250, 20);
  [pane addSubview:c1];

  NSLevelIndicator *level = [[NSLevelIndicator alloc] initWithFrame:NSMakeRect(30, 210, 200, 18)];
  level.maxValue = 5;
  level.warningValue = 3;
  level.criticalValue = 1;
  level.doubleValue = 4;
  level.levelIndicatorStyle = NSLevelIndicatorStyleContinuousCapacity;
  [pane addSubview:level];

  NSTextField *ll = [NSTextField labelWithString:@"Password strength: Strong"];
  ll.font = [NSFont systemFontOfSize:11];
  ll.textColor = [NSColor secondaryLabelColor];
  ll.frame = NSMakeRect(30, 190, 200, 16);
  [pane addSubview:ll];
  return pane;
}

- (BOOL)isOpaque { return YES; }
- (void)drawRect:(NSRect)dirtyRect {
  [[NSColor windowBackgroundColor] setFill];
  NSRectFill(dirtyRect);
}
- (void)layout { [super layout]; _tabView.frame = self.bounds; }

- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
  return @[@"General", @"Appearance", @"Notifications", @"Privacy"];
}
- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
  return @[@"General", @"Appearance", @"Notifications", @"Privacy"];
}
- (NSArray<NSToolbarItemIdentifier> *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar {
  return @[@"General", @"Appearance", @"Notifications", @"Privacy"];
}
- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
  NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
  item.label = itemIdentifier;
  item.action = @selector(switchTab:);
  item.target = self;
  NSDictionary *icons = @{@"General":@"gearshape.fill", @"Appearance":@"paintbrush.fill",
                           @"Notifications":@"bell.badge.fill", @"Privacy":@"lock.shield.fill"};
  NSString *iconName = icons[itemIdentifier];
  if (iconName) item.image = [NSImage imageWithSystemSymbolName:iconName accessibilityDescription:itemIdentifier];
  return item;
}
- (void)switchTab:(NSToolbarItem *)sender {
  NSInteger idx = [_tabView indexOfTabViewItemWithIdentifier:sender.itemIdentifier];
  if (idx != NSNotFound) {
    [_tabView selectTabViewItemAtIndex:idx];
    if (_onTabChange) _onTabChange(@{@"tab": sender.itemIdentifier});
  }
}
@end

// ============================================================
// 2. Text Editor (NSTextView with ruler)
// ============================================================

@interface RCTTextEditorView : NSView
@property (nonatomic, strong) NSScrollView *scrollView;
@property (nonatomic, strong) NSTextView *textView;
@end

@implementation RCTTextEditorView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.wantsLayer = YES;

    _scrollView = [[NSScrollView alloc] initWithFrame:self.bounds];
    _scrollView.hasVerticalScroller = YES;
    _scrollView.hasHorizontalScroller = NO;
    _scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    _scrollView.rulersVisible = YES;
    _scrollView.hasVerticalRuler = NO;
    _scrollView.hasHorizontalRuler = YES;

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
    _textView.usesRuler = YES;
    _textView.usesFontPanel = YES;
    _textView.usesInspectorBar = YES;
    _textView.font = [NSFont systemFontOfSize:14];

    // Sample rich text
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] init];
    NSDictionary *titleAttrs = @{NSFontAttributeName: [NSFont systemFontOfSize:24 weight:NSFontWeightBold],
                                  NSForegroundColorAttributeName: [NSColor labelColor]};
    NSDictionary *bodyAttrs = @{NSFontAttributeName: [NSFont systemFontOfSize:14],
                                 NSForegroundColorAttributeName: [NSColor labelColor]};
    NSDictionary *codeAttrs = @{NSFontAttributeName: [NSFont monospacedSystemFontOfSize:12 weight:NSFontWeightRegular],
                                 NSForegroundColorAttributeName: [NSColor systemPurpleColor],
                                 NSBackgroundColorAttributeName: [NSColor quaternaryLabelColor]};
    NSDictionary *boldAttrs = @{NSFontAttributeName: [NSFont systemFontOfSize:14 weight:NSFontWeightBold],
                                 NSForegroundColorAttributeName: [NSColor labelColor]};

    [content appendAttributedString:[[NSAttributedString alloc] initWithString:@"Rich Text Editor\n\n" attributes:titleAttrs]];
    [content appendAttributedString:[[NSAttributedString alloc] initWithString:@"This is a " attributes:bodyAttrs]];
    [content appendAttributedString:[[NSAttributedString alloc] initWithString:@"native NSTextView" attributes:boldAttrs]];
    [content appendAttributedString:[[NSAttributedString alloc] initWithString:@" with full rich text support, undo/redo, font panel, and ruler.\n\n" attributes:bodyAttrs]];
    [content appendAttributedString:[[NSAttributedString alloc] initWithString:@"module Main where\nimport Prelude\nmain = log \"Hello\"\n\n" attributes:codeAttrs]];
    [content appendAttributedString:[[NSAttributedString alloc] initWithString:@"Try selecting text and using " attributes:bodyAttrs]];
    [content appendAttributedString:[[NSAttributedString alloc] initWithString:@"Format > Font" attributes:boldAttrs]];
    [content appendAttributedString:[[NSAttributedString alloc] initWithString:@" from the menu bar to change fonts, colors, and styles. The ruler above can adjust margins and tab stops.\n\nAll of this is native AppKit \u2014 no React Native involvement." attributes:bodyAttrs]];

    [_textView.textStorage setAttributedString:content];
    _scrollView.documentView = _textView;
    [self addSubview:_scrollView];
  }
  return self;
}

- (BOOL)isOpaque { return YES; }
- (void)drawRect:(NSRect)dirtyRect {
  [[NSColor windowBackgroundColor] setFill];
  NSRectFill(dirtyRect);
}
- (void)layout {
  [super layout];
  _scrollView.frame = self.bounds;
}
@end

// ============================================================
// 3. Inspector / Detail pane (like Xcode's inspector)
// ============================================================

@interface RCTInspectorView : NSView
@property (nonatomic, strong) NSSplitView *splitView;
@end

@implementation RCTInspectorView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.wantsLayer = YES;

    _splitView = [[NSSplitView alloc] initWithFrame:self.bounds];
    _splitView.vertical = YES;
    _splitView.dividerStyle = NSSplitViewDividerStyleThin;
    _splitView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;

    // Left: content area
    NSView *leftPane = [self createContentPane];

    // Right: inspector
    NSView *rightPane = [self createInspectorPane];

    [_splitView addSubview:leftPane];
    [_splitView addSubview:rightPane];
    [_splitView setPosition:400 ofDividerAtIndex:0];

    [self addSubview:_splitView];
  }
  return self;
}

- (NSView *)createContentPane {
  NSView *pane = [[NSView alloc] initWithFrame:NSZeroRect];
  pane.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;

  // Fake "canvas" with shapes
  NSView *canvas = [[NSView alloc] initWithFrame:NSZeroRect];
  canvas.wantsLayer = YES;
  canvas.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;

  // Title
  NSTextField *title = [NSTextField labelWithString:@"Canvas"];
  title.font = [NSFont systemFontOfSize:11 weight:NSFontWeightMedium];
  title.textColor = [NSColor secondaryLabelColor];
  title.alignment = NSTextAlignmentCenter;
  title.frame = NSMakeRect(0, 0, 400, 20);
  title.autoresizingMask = NSViewWidthSizable | NSViewMinYMargin;
  [canvas addSubview:title];

  // Blue rectangle
  NSView *rect1 = [[NSView alloc] initWithFrame:NSMakeRect(40, 120, 150, 100)];
  rect1.wantsLayer = YES;
  rect1.layer.backgroundColor = [NSColor systemBlueColor].CGColor;
  rect1.layer.cornerRadius = 8;
  [canvas addSubview:rect1];

  // Green circle
  NSView *circle = [[NSView alloc] initWithFrame:NSMakeRect(220, 150, 80, 80)];
  circle.wantsLayer = YES;
  circle.layer.backgroundColor = [NSColor systemGreenColor].CGColor;
  circle.layer.cornerRadius = 40;
  [canvas addSubview:circle];

  // Orange rect
  NSView *rect2 = [[NSView alloc] initWithFrame:NSMakeRect(100, 50, 200, 60)];
  rect2.wantsLayer = YES;
  rect2.layer.backgroundColor = [NSColor systemOrangeColor].CGColor;
  rect2.layer.cornerRadius = 4;
  [canvas addSubview:rect2];

  [pane addSubview:canvas];
  canvas.frame = pane.bounds;
  return pane;
}

- (NSView *)createInspectorPane {
  NSScrollView *scroll = [[NSScrollView alloc] initWithFrame:NSZeroRect];
  scroll.hasVerticalScroller = YES;
  scroll.autohidesScrollers = YES;
  scroll.drawsBackground = YES;
  scroll.backgroundColor = [NSColor controlBackgroundColor];
  scroll.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;

  NSView *content = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 260, 600)];
  CGFloat y = 570;

  // Inspector header
  NSTextField *header = [NSTextField labelWithString:@"Inspector"];
  header.font = [NSFont systemFontOfSize:13 weight:NSFontWeightSemibold];
  header.frame = NSMakeRect(12, y, 200, 20);
  [content addSubview:header];
  y -= 30;

  // Position section
  [self addSectionHeader:@"POSITION" toView:content atY:&y];
  [self addLabeledField:@"X:" value:@"40" toView:content atY:&y atX:12];
  [self addLabeledField:@"Y:" value:@"120" toView:content atY:&y atX:130];
  y -= 5;
  [self addLabeledField:@"W:" value:@"150" toView:content atY:&y atX:12];
  [self addLabeledField:@"H:" value:@"100" toView:content atY:&y atX:130];
  y -= 10;

  // Appearance section
  [self addSectionHeader:@"APPEARANCE" toView:content atY:&y];

  NSTextField *fillLabel = [NSTextField labelWithString:@"Fill:"];
  fillLabel.font = [NSFont systemFontOfSize:11];
  fillLabel.frame = NSMakeRect(12, y, 40, 18);
  [content addSubview:fillLabel];

  NSColorWell *fillColor = [[NSColorWell alloc] initWithFrame:NSMakeRect(55, y - 2, 36, 22)];
  fillColor.color = [NSColor systemBlueColor];
  if (@available(macOS 13.0, *)) { fillColor.colorWellStyle = NSColorWellStyleMinimal; }
  [content addSubview:fillColor];

  NSTextField *opLabel = [NSTextField labelWithString:@"Opacity:"];
  opLabel.font = [NSFont systemFontOfSize:11];
  opLabel.frame = NSMakeRect(100, y, 50, 18);
  [content addSubview:opLabel];

  NSSlider *opSlider = [NSSlider sliderWithValue:100 minValue:0 maxValue:100 target:nil action:nil];
  opSlider.frame = NSMakeRect(152, y, 90, 18);
  [content addSubview:opSlider];
  y -= 30;

  NSTextField *strokeLabel = [NSTextField labelWithString:@"Stroke:"];
  strokeLabel.font = [NSFont systemFontOfSize:11];
  strokeLabel.frame = NSMakeRect(12, y, 45, 18);
  [content addSubview:strokeLabel];

  NSColorWell *strokeColor = [[NSColorWell alloc] initWithFrame:NSMakeRect(55, y - 2, 36, 22)];
  strokeColor.color = [NSColor labelColor];
  if (@available(macOS 13.0, *)) { strokeColor.colorWellStyle = NSColorWellStyleMinimal; }
  [content addSubview:strokeColor];

  NSTextField *widthLabel = [NSTextField labelWithString:@"Width:"];
  widthLabel.font = [NSFont systemFontOfSize:11];
  widthLabel.frame = NSMakeRect(100, y, 45, 18);
  [content addSubview:widthLabel];

  NSStepper *widthStepper = [[NSStepper alloc] initWithFrame:NSMakeRect(200, y - 1, 19, 20)];
  widthStepper.minValue = 0;
  widthStepper.maxValue = 20;
  widthStepper.integerValue = 1;
  [content addSubview:widthStepper];

  NSTextField *widthVal = [NSTextField labelWithString:@"1 px"];
  widthVal.font = [NSFont systemFontOfSize:11];
  widthVal.frame = NSMakeRect(152, y, 45, 18);
  [content addSubview:widthVal];
  y -= 30;

  NSTextField *cornerLabel = [NSTextField labelWithString:@"Corner radius:"];
  cornerLabel.font = [NSFont systemFontOfSize:11];
  cornerLabel.frame = NSMakeRect(12, y, 90, 18);
  [content addSubview:cornerLabel];

  NSSlider *cornerSlider = [NSSlider sliderWithValue:8 minValue:0 maxValue:50 target:nil action:nil];
  cornerSlider.frame = NSMakeRect(105, y, 135, 18);
  [content addSubview:cornerSlider];
  y -= 25;

  // Shadow section
  [self addSectionHeader:@"SHADOW" toView:content atY:&y];

  NSButton *shadowToggle = [NSButton checkboxWithTitle:@"Drop shadow" target:nil action:nil];
  shadowToggle.state = NSControlStateValueOn;
  shadowToggle.frame = NSMakeRect(12, y, 150, 18);
  [content addSubview:shadowToggle];
  y -= 25;

  [self addLabeledField:@"Blur:" value:@"4" toView:content atY:&y atX:12];
  [self addLabeledField:@"Offset:" value:@"2" toView:content atY:&y atX:130];
  y -= 10;

  // Typography section
  [self addSectionHeader:@"TYPOGRAPHY" toView:content atY:&y];

  NSPopUpButton *fontPop = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(12, y, 230, 22) pullsDown:NO];
  [fontPop addItemsWithTitles:@[@"SF Pro", @"SF Mono", @"New York", @"Helvetica Neue"]];
  [content addSubview:fontPop];
  y -= 30;

  NSSegmentedControl *styleControl = [NSSegmentedControl segmentedControlWithLabels:@[@"B", @"I", @"U", @"S"]
                                                                       trackingMode:NSSegmentSwitchTrackingSelectAny target:nil action:nil];
  styleControl.frame = NSMakeRect(12, y, 160, 22);
  [styleControl setSelected:YES forSegment:0];
  [content addSubview:styleControl];
  y -= 30;

  NSSegmentedControl *alignControl = [NSSegmentedControl
    segmentedControlWithImages:@[
      [NSImage imageWithSystemSymbolName:@"text.alignleft" accessibilityDescription:@"Left"],
      [NSImage imageWithSystemSymbolName:@"text.aligncenter" accessibilityDescription:@"Center"],
      [NSImage imageWithSystemSymbolName:@"text.alignright" accessibilityDescription:@"Right"],
      [NSImage imageWithSystemSymbolName:@"text.justify" accessibilityDescription:@"Justify"],
    ] trackingMode:NSSegmentSwitchTrackingSelectOne target:nil action:nil];
  alignControl.selectedSegment = 0;
  alignControl.frame = NSMakeRect(12, y, 160, 22);
  [content addSubview:alignControl];

  scroll.documentView = content;
  return scroll;
}

- (void)addSectionHeader:(NSString *)title toView:(NSView *)view atY:(CGFloat *)y {
  NSBox *sep = [[NSBox alloc] initWithFrame:NSMakeRect(12, *y + 5, 228, 1)];
  sep.boxType = NSBoxSeparator;
  [view addSubview:sep];
  *y -= 5;

  NSTextField *label = [NSTextField labelWithString:title];
  label.font = [NSFont systemFontOfSize:10 weight:NSFontWeightMedium];
  label.textColor = [NSColor tertiaryLabelColor];
  label.frame = NSMakeRect(12, *y, 200, 14);
  [view addSubview:label];
  *y -= 22;
}

- (void)addLabeledField:(NSString *)label value:(NSString *)value toView:(NSView *)view atY:(CGFloat *)y atX:(CGFloat)x {
  NSTextField *lbl = [NSTextField labelWithString:label];
  lbl.font = [NSFont systemFontOfSize:11];
  lbl.frame = NSMakeRect(x, *y, 22, 18);
  [view addSubview:lbl];

  NSTextField *field = [[NSTextField alloc] initWithFrame:NSMakeRect(x + 24, *y - 1, 80, 20)];
  field.stringValue = value;
  field.font = [NSFont systemFontOfSize:11];
  field.alignment = NSTextAlignmentRight;
  [view addSubview:field];
  *y -= 26;
}

- (BOOL)isOpaque { return YES; }
- (void)drawRect:(NSRect)dirtyRect {
  [[NSColor windowBackgroundColor] setFill];
  NSRectFill(dirtyRect);
}
- (void)layout {
  [super layout];
  _splitView.frame = self.bounds;
}
@end

// ============================================================
// 4. Controls Gallery
// ============================================================

@interface RCTControlsGalleryView : NSView
@end

@implementation RCTControlsGalleryView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.wantsLayer = YES;

    NSScrollView *scroll = [[NSScrollView alloc] initWithFrame:self.bounds];
    scroll.hasVerticalScroller = YES;
    scroll.autohidesScrollers = YES;
    scroll.drawsBackground = YES;
    scroll.backgroundColor = [NSColor controlBackgroundColor];
    scroll.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;

    NSView *c = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 600, 780)];
    CGFloat y = 740;

    NSTextField *title = [NSTextField labelWithString:@"Native macOS Controls"];
    title.font = [NSFont systemFontOfSize:22 weight:NSFontWeightBold];
    title.frame = NSMakeRect(30, y, 400, 30);
    [c addSubview:title];
    y -= 45;

    // Buttons
    [self addSection:@"Buttons" toView:c atY:&y];
    NSButton *b1 = [NSButton buttonWithTitle:@"Default" target:nil action:nil];
    b1.bezelStyle = NSBezelStylePush;
    b1.keyEquivalent = @"\r";
    b1.frame = NSMakeRect(30, y, 90, 24);
    [c addSubview:b1];

    NSButton *b2 = [NSButton buttonWithTitle:@"Regular" target:nil action:nil];
    b2.bezelStyle = NSBezelStylePush;
    b2.frame = NSMakeRect(130, y, 90, 24);
    [c addSubview:b2];

    NSButton *b3 = [NSButton buttonWithTitle:@"Destructive" target:nil action:nil];
    b3.bezelStyle = NSBezelStylePush;
    b3.hasDestructiveAction = YES;
    b3.frame = NSMakeRect(230, y, 110, 24);
    [c addSubview:b3];

    NSButton *b4 = [NSButton buttonWithImage:[NSImage imageWithSystemSymbolName:@"plus" accessibilityDescription:@"Add"] target:nil action:nil];
    b4.bezelStyle = NSBezelStyleToolbar;
    b4.frame = NSMakeRect(350, y, 36, 24);
    [c addSubview:b4];

    NSButton *b5 = [NSButton buttonWithImage:[NSImage imageWithSystemSymbolName:@"gearshape" accessibilityDescription:@"Settings"] target:nil action:nil];
    b5.bezelStyle = NSBezelStyleToolbar;
    b5.frame = NSMakeRect(390, y, 36, 24);
    [c addSubview:b5];

    NSButton *b6 = [NSButton buttonWithImage:[NSImage imageWithSystemSymbolName:@"trash" accessibilityDescription:@"Delete"] target:nil action:nil];
    b6.bezelStyle = NSBezelStyleToolbar;
    b6.frame = NSMakeRect(430, y, 36, 24);
    [c addSubview:b6];
    y -= 45;

    // Toggle buttons
    [self addSection:@"Toggles" toView:c atY:&y];
    NSButton *t1 = [NSButton checkboxWithTitle:@"Checkbox on" target:nil action:nil];
    t1.state = NSControlStateValueOn;
    t1.frame = NSMakeRect(30, y, 130, 20);
    [c addSubview:t1];

    NSButton *t2 = [NSButton checkboxWithTitle:@"Checkbox off" target:nil action:nil];
    t2.frame = NSMakeRect(170, y, 130, 20);
    [c addSubview:t2];

    NSSwitch *sw = [[NSSwitch alloc] initWithFrame:NSMakeRect(310, y - 2, 38, 22)];
    sw.state = NSControlStateValueOn;
    [c addSubview:sw];

    NSSwitch *sw2 = [[NSSwitch alloc] initWithFrame:NSMakeRect(360, y - 2, 38, 22)];
    [c addSubview:sw2];
    y -= 35;

    NSButton *r1 = [NSButton radioButtonWithTitle:@"Option A" target:nil action:nil];
    r1.state = NSControlStateValueOn;
    r1.frame = NSMakeRect(30, y, 100, 20);
    [c addSubview:r1];
    NSButton *r2 = [NSButton radioButtonWithTitle:@"Option B" target:nil action:nil];
    r2.frame = NSMakeRect(140, y, 100, 20);
    [c addSubview:r2];
    NSButton *r3 = [NSButton radioButtonWithTitle:@"Option C" target:nil action:nil];
    r3.frame = NSMakeRect(250, y, 100, 20);
    [c addSubview:r3];
    y -= 45;

    // Segmented controls
    [self addSection:@"Segmented Controls" toView:c atY:&y];
    NSSegmentedControl *s1 = [NSSegmentedControl segmentedControlWithLabels:@[@"Day", @"Week", @"Month", @"Year"]
                                                              trackingMode:NSSegmentSwitchTrackingSelectOne target:nil action:nil];
    s1.selectedSegment = 1;
    s1.frame = NSMakeRect(30, y, 300, 24);
    [c addSubview:s1];
    y -= 35;

    NSSegmentedControl *s2 = [NSSegmentedControl
      segmentedControlWithImages:@[
        [NSImage imageWithSystemSymbolName:@"list.bullet" accessibilityDescription:@"List"],
        [NSImage imageWithSystemSymbolName:@"square.grid.2x2" accessibilityDescription:@"Grid"],
        [NSImage imageWithSystemSymbolName:@"rectangle.grid.1x2" accessibilityDescription:@"Column"],
      ] trackingMode:NSSegmentSwitchTrackingSelectOne target:nil action:nil];
    s2.selectedSegment = 0;
    s2.frame = NSMakeRect(30, y, 120, 24);
    [c addSubview:s2];
    y -= 45;

    // Text inputs
    [self addSection:@"Text Fields" toView:c atY:&y];
    NSTextField *tf = [[NSTextField alloc] initWithFrame:NSMakeRect(30, y, 180, 22)];
    tf.placeholderString = @"Text field";
    [c addSubview:tf];

    NSSearchField *sf = [[NSSearchField alloc] initWithFrame:NSMakeRect(220, y, 180, 22)];
    sf.placeholderString = @"Search...";
    [c addSubview:sf];
    y -= 30;

    NSSecureTextField *stf = [[NSSecureTextField alloc] initWithFrame:NSMakeRect(30, y, 180, 22)];
    stf.placeholderString = @"Password";
    [c addSubview:stf];

    NSComboBox *combo = [[NSComboBox alloc] initWithFrame:NSMakeRect(220, y, 180, 22)];
    [combo addItemsWithObjectValues:@[@"Item 1", @"Item 2", @"Item 3"]];
    combo.placeholderString = @"Combo box";
    [c addSubview:combo];
    y -= 45;

    // Sliders & indicators
    [self addSection:@"Sliders & Indicators" toView:c atY:&y];
    NSSlider *sl1 = [NSSlider sliderWithValue:50 minValue:0 maxValue:100 target:nil action:nil];
    sl1.frame = NSMakeRect(30, y, 200, 20);
    [c addSubview:sl1];

    NSSlider *sl2 = [NSSlider sliderWithValue:3 minValue:0 maxValue:5 target:nil action:nil];
    sl2.numberOfTickMarks = 6;
    sl2.allowsTickMarkValuesOnly = YES;
    sl2.frame = NSMakeRect(240, y, 180, 20);
    [c addSubview:sl2];
    y -= 35;

    NSProgressIndicator *p1 = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(30, y, 200, 20)];
    p1.style = NSProgressIndicatorStyleBar;
    p1.doubleValue = 65;
    [c addSubview:p1];

    NSProgressIndicator *p2 = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(240, y, 20, 20)];
    p2.style = NSProgressIndicatorStyleSpinning;
    [p2 startAnimation:nil];
    [c addSubview:p2];

    NSLevelIndicator *lev = [[NSLevelIndicator alloc] initWithFrame:NSMakeRect(280, y + 2, 130, 18)];
    lev.maxValue = 10;
    lev.warningValue = 6;
    lev.criticalValue = 2;
    lev.doubleValue = 7;
    lev.levelIndicatorStyle = NSLevelIndicatorStyleContinuousCapacity;
    [c addSubview:lev];
    y -= 45;

    // Date, stepper, popup
    [self addSection:@"Pickers & Menus" toView:c atY:&y];
    NSDatePicker *dp = [[NSDatePicker alloc] initWithFrame:NSMakeRect(30, y, 200, 24)];
    dp.datePickerStyle = NSDatePickerStyleTextField;
    dp.dateValue = [NSDate date];
    [c addSubview:dp];

    NSStepper *step = [[NSStepper alloc] initWithFrame:NSMakeRect(240, y + 1, 19, 22)];
    step.minValue = 0;
    step.maxValue = 100;
    step.integerValue = 42;
    [c addSubview:step];

    NSTextField *stepVal = [NSTextField labelWithString:@"42"];
    stepVal.frame = NSMakeRect(265, y + 2, 40, 20);
    [c addSubview:stepVal];

    NSPopUpButton *pop = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(310, y, 120, 25) pullsDown:NO];
    [pop addItemsWithTitles:@[@"English", @"German", @"Japanese"]];
    [c addSubview:pop];
    y -= 45;

    // Date picker graphical
    NSDatePicker *dpg = [[NSDatePicker alloc] initWithFrame:NSMakeRect(30, y - 120, 260, 150)];
    dpg.datePickerStyle = NSDatePickerStyleClockAndCalendar;
    dpg.datePickerElements = NSDatePickerElementFlagYearMonthDay;
    dpg.dateValue = [NSDate date];
    [c addSubview:dpg];

    scroll.documentView = c;
    [self addSubview:scroll];
  }
  return self;
}

- (void)addSection:(NSString *)title toView:(NSView *)view atY:(CGFloat *)y {
  NSTextField *label = [NSTextField labelWithString:title];
  label.font = [NSFont systemFontOfSize:13 weight:NSFontWeightSemibold];
  label.textColor = [NSColor secondaryLabelColor];
  label.frame = NSMakeRect(30, *y, 200, 20);
  [view addSubview:label];
  *y -= 30;
}

- (BOOL)isOpaque { return YES; }
- (void)drawRect:(NSRect)dirtyRect {
  [[NSColor windowBackgroundColor] setFill];
  NSRectFill(dirtyRect);
}
- (void)layout {
  [super layout];
  for (NSView *v in self.subviews) {
    v.frame = self.bounds;
  }
}
@end

// ============================================================
// 5. Web Browser tab
// ============================================================

@interface RCTWebBrowserView : NSView <WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSTextField *urlBar;
@property (nonatomic, strong) NSProgressIndicator *loadingBar;
@property (nonatomic, strong) NSView *toolbar;
@end

@implementation RCTWebBrowserView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.wantsLayer = YES;

    // Toolbar
    _toolbar = [[NSView alloc] initWithFrame:NSZeroRect];
    _toolbar.wantsLayer = YES;
    _toolbar.layer.backgroundColor = [NSColor windowBackgroundColor].CGColor;
    _toolbar.autoresizingMask = NSViewWidthSizable | NSViewMinYMargin;

    NSButton *back = [NSButton buttonWithImage:[NSImage imageWithSystemSymbolName:@"chevron.left" accessibilityDescription:@"Back"] target:self action:@selector(goBack)];
    back.bezelStyle = NSBezelStyleToolbar;
    back.tag = 1;
    [_toolbar addSubview:back];

    NSButton *forward = [NSButton buttonWithImage:[NSImage imageWithSystemSymbolName:@"chevron.right" accessibilityDescription:@"Forward"] target:self action:@selector(goForward)];
    forward.bezelStyle = NSBezelStyleToolbar;
    forward.tag = 2;
    [_toolbar addSubview:forward];

    NSButton *refresh = [NSButton buttonWithImage:[NSImage imageWithSystemSymbolName:@"arrow.clockwise" accessibilityDescription:@"Reload"] target:self action:@selector(reload)];
    refresh.bezelStyle = NSBezelStyleToolbar;
    refresh.tag = 3;
    [_toolbar addSubview:refresh];

    _urlBar = [[NSTextField alloc] initWithFrame:NSZeroRect];
    _urlBar.stringValue = @"https://pursuit.purescript.org";
    _urlBar.font = [NSFont systemFontOfSize:12];
    _urlBar.target = self;
    _urlBar.action = @selector(navigate);
    [_toolbar addSubview:_urlBar];

    [self addSubview:_toolbar];

    // Loading bar
    _loadingBar = [[NSProgressIndicator alloc] initWithFrame:NSZeroRect];
    _loadingBar.style = NSProgressIndicatorStyleBar;
    _loadingBar.indeterminate = YES;
    _loadingBar.hidden = YES;
    [self addSubview:_loadingBar];

    // Web view
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    _webView = [[WKWebView alloc] initWithFrame:NSZeroRect configuration:config];
    _webView.navigationDelegate = self;
    _webView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    _webView.allowsBackForwardNavigationGestures = YES;
    [self addSubview:_webView];

    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://pursuit.purescript.org"]]];
  }
  return self;
}

- (void)layout {
  [super layout];
  NSRect b = self.bounds;
  CGFloat toolH = 36;
  _toolbar.frame = NSMakeRect(0, b.size.height - toolH, b.size.width, toolH);
  _loadingBar.frame = NSMakeRect(0, b.size.height - toolH - 3, b.size.width, 3);
  _webView.frame = NSMakeRect(0, 0, b.size.width, b.size.height - toolH - 3);

  // Layout toolbar items
  CGFloat pad = 6;
  CGFloat x = pad;
  for (NSView *v in _toolbar.subviews) {
    if ([v isKindOfClass:[NSButton class]]) {
      v.frame = NSMakeRect(x, (toolH - 24) / 2, 30, 24);
      x += 34;
    }
  }
  _urlBar.frame = NSMakeRect(x + 4, (toolH - 22) / 2, b.size.width - x - pad - 4, 22);
}

- (void)goBack { [_webView goBack]; }
- (void)goForward { [_webView goForward]; }
- (void)reload { [_webView reload]; }
- (void)navigate {
  NSString *url = _urlBar.stringValue;
  if (![url hasPrefix:@"http"]) url = [@"https://" stringByAppendingString:url];
  [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
  _loadingBar.hidden = NO;
  [_loadingBar startAnimation:nil];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
  _loadingBar.hidden = YES;
  [_loadingBar stopAnimation:nil];
  _urlBar.stringValue = webView.URL.absoluteString ?: @"";
}

- (BOOL)isOpaque { return YES; }
- (void)drawRect:(NSRect)dirtyRect {
  [[NSColor windowBackgroundColor] setFill];
  NSRectFill(dirtyRect);
}
@end

// ============================================================
// 6. Showcase container
// ============================================================

@interface RCTNativeShowcaseView : NSView
@property (nonatomic, strong) NSVisualEffectView *backgroundView;
@property (nonatomic, strong) NSTabView *tabView;
@end

@implementation RCTNativeShowcaseView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    // System background that adapts to light/dark mode
    _backgroundView = [[NSVisualEffectView alloc] initWithFrame:self.bounds];
    _backgroundView.material = NSVisualEffectMaterialWindowBackground;
    _backgroundView.blendingMode = NSVisualEffectBlendingModeBehindWindow;
    _backgroundView.state = NSVisualEffectStateFollowsWindowActiveState;
    _backgroundView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self addSubview:_backgroundView];

    _tabView = [[NSTabView alloc] initWithFrame:self.bounds];
    _tabView.tabViewType = NSTopTabsBezelBorder;
    _tabView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    _tabView.controlSize = NSControlSizeRegular;

    [self addTab:@"Controls" view:[[RCTControlsGalleryView alloc] initWithFrame:NSZeroRect]];
    [self addTab:@"Inspector" view:[[RCTInspectorView alloc] initWithFrame:NSZeroRect]];
    [self addTab:@"Text Editor" view:[[RCTTextEditorView alloc] initWithFrame:NSZeroRect]];
    [self addTab:@"Browser" view:[[RCTWebBrowserView alloc] initWithFrame:NSZeroRect]];
    [self addTab:@"Settings" view:[[RCTPreferencesView alloc] initWithFrame:NSZeroRect]];

    [_backgroundView addSubview:_tabView];
  }
  return self;
}

- (void)addTab:(NSString *)label view:(NSView *)view {
  NSTabViewItem *item = [[NSTabViewItem alloc] initWithIdentifier:label];
  item.label = label;
  item.view = view;
  [_tabView addTabViewItem:item];
}

- (void)viewDidMoveToWindow {
  [super viewDidMoveToWindow];
  if (self.window) {
    self.window.toolbar = nil;
    self.window.title = @"Native macOS Showcase";
    // Ensure window has proper appearance for dark/light mode
    self.window.appearance = nil; // follow system
  }
}

- (BOOL)isOpaque { return YES; }
- (void)drawRect:(NSRect)dirtyRect {
  [[NSColor windowBackgroundColor] setFill];
  NSRectFill(dirtyRect);
}
- (void)layout {
  [super layout];
  _backgroundView.frame = self.bounds;
  _tabView.frame = _backgroundView.bounds;
}
@end

// ============================================================
// View Managers
// ============================================================

@interface RCTNativeShowcaseViewManager : RCTViewManager
@end
@implementation RCTNativeShowcaseViewManager
RCT_EXPORT_MODULE(NativeShowcase)
- (NSView *)view { return [[RCTNativeShowcaseView alloc] initWithFrame:CGRectZero]; }
@end
