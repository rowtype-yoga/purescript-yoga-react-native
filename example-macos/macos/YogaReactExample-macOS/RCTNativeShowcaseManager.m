#import <React/RCTViewManager.h>
#import <React/RCTBridge.h>
#import <AppKit/AppKit.h>

// ============================================================
// 1. NSToolbar-style toolbar view
// ============================================================

@interface RCTToolbarView : NSView <NSToolbarDelegate>
@property (nonatomic, strong) NSToolbar *toolbar;
@property (nonatomic, copy) RCTBubblingEventBlock onAction;
@end

@implementation RCTToolbarView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    // We'll attach the toolbar to the window once we're in a window
  }
  return self;
}

- (void)viewDidMoveToWindow {
  [super viewDidMoveToWindow];
  if (self.window && !self.window.toolbar) {
    _toolbar = [[NSToolbar alloc] initWithIdentifier:@"MainToolbar"];
    _toolbar.delegate = self;
    _toolbar.displayMode = NSToolbarDisplayModeIconAndLabel;
    _toolbar.allowsUserCustomization = NO;
    self.window.toolbar = _toolbar;
    self.window.toolbarStyle = NSWindowToolbarStyleUnified;
  }
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
  return @[@"back", @"forward", NSToolbarFlexibleSpaceItemIdentifier, @"search", @"share", NSToolbarFlexibleSpaceItemIdentifier, @"sidebar"];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
  return @[@"back", @"forward", NSToolbarFlexibleSpaceItemIdentifier, @"search", NSToolbarFlexibleSpaceItemIdentifier, @"sidebar"];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
  NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];

  if ([itemIdentifier isEqualToString:@"back"]) {
    item.label = @"Back";
    item.image = [NSImage imageWithSystemSymbolName:@"chevron.left" accessibilityDescription:@"Back"];
    item.action = @selector(toolbarAction:);
    item.target = self;
  } else if ([itemIdentifier isEqualToString:@"forward"]) {
    item.label = @"Forward";
    item.image = [NSImage imageWithSystemSymbolName:@"chevron.right" accessibilityDescription:@"Forward"];
    item.action = @selector(toolbarAction:);
    item.target = self;
  } else if ([itemIdentifier isEqualToString:@"search"]) {
    NSSearchToolbarItem *searchItem = [[NSSearchToolbarItem alloc] initWithItemIdentifier:@"search"];
    searchItem.label = @"Search";
    return searchItem;
  } else if ([itemIdentifier isEqualToString:@"sidebar"]) {
    item.label = @"Sidebar";
    item.image = [NSImage imageWithSystemSymbolName:@"sidebar.left" accessibilityDescription:@"Toggle Sidebar"];
    item.action = @selector(toolbarAction:);
    item.target = self;
  }

  return item;
}

- (void)toolbarAction:(NSToolbarItem *)sender {
  if (_onAction) {
    _onAction(@{@"action": sender.itemIdentifier});
  }
}

@end

// ============================================================
// 2. Preferences-style tab view
// ============================================================

@interface RCTPreferencesView : NSView <NSToolbarDelegate>
@property (nonatomic, strong) NSTabView *tabView;
@property (nonatomic, strong) NSToolbar *prefsToolbar;
@property (nonatomic, copy) RCTBubblingEventBlock onTabChange;
@end

@implementation RCTPreferencesView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _tabView = [[NSTabView alloc] initWithFrame:self.bounds];
    _tabView.tabViewType = NSNoTabsNoBorder;
    _tabView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self addSubview:_tabView];

    // Add sample preference panes
    [self addPaneWithTitle:@"General" icon:@"gearshape.fill" content:[self generalPane]];
    [self addPaneWithTitle:@"Appearance" icon:@"paintbrush.fill" content:[self appearancePane]];
    [self addPaneWithTitle:@"Notifications" icon:@"bell.badge.fill" content:[self notificationsPane]];
    [self addPaneWithTitle:@"Privacy" icon:@"lock.shield.fill" content:[self privacyPane]];
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

- (void)addPaneWithTitle:(NSString *)title icon:(NSString *)iconName content:(NSView *)content {
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

  // Toggle switches
  NSButton *check1 = [NSButton checkboxWithTitle:@"Open at login" target:nil action:nil];
  check1.frame = NSMakeRect(30, 310, 250, 20);
  [pane addSubview:check1];

  NSButton *check2 = [NSButton checkboxWithTitle:@"Check for updates automatically" target:nil action:nil];
  check2.state = NSControlStateValueOn;
  check2.frame = NSMakeRect(30, 280, 250, 20);
  [pane addSubview:check2];

  NSButton *check3 = [NSButton checkboxWithTitle:@"Show in menu bar" target:nil action:nil];
  check3.state = NSControlStateValueOn;
  check3.frame = NSMakeRect(30, 250, 250, 20);
  [pane addSubview:check3];

  // Popup button
  NSTextField *label1 = [NSTextField labelWithString:@"Default browser:"];
  label1.frame = NSMakeRect(30, 210, 120, 20);
  [pane addSubview:label1];

  NSPopUpButton *popup = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(155, 207, 200, 25) pullsDown:NO];
  [popup addItemsWithTitles:@[@"Safari", @"Chrome", @"Firefox", @"Arc"]];
  [pane addSubview:popup];

  // Slider
  NSTextField *label2 = [NSTextField labelWithString:@"Font size:"];
  label2.frame = NSMakeRect(30, 170, 120, 20);
  [pane addSubview:label2];

  NSSlider *slider = [NSSlider sliderWithValue:13 minValue:9 maxValue:24 target:nil action:nil];
  slider.frame = NSMakeRect(155, 170, 200, 20);
  [pane addSubview:slider];

  return pane;
}

- (NSView *)appearancePane {
  NSView *pane = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 500, 400)];

  NSTextField *header = [NSTextField labelWithString:@"Appearance"];
  header.font = [NSFont systemFontOfSize:20 weight:NSFontWeightSemibold];
  header.frame = NSMakeRect(30, 350, 200, 30);
  [pane addSubview:header];

  // Segmented control for theme
  NSTextField *label = [NSTextField labelWithString:@"Theme:"];
  label.frame = NSMakeRect(30, 310, 60, 20);
  [pane addSubview:label];

  NSSegmentedControl *seg = [NSSegmentedControl segmentedControlWithLabels:@[@"Light", @"Dark", @"Auto"]
                                                              trackingMode:NSSegmentSwitchTrackingSelectOne
                                                                    target:nil action:nil];
  seg.selectedSegment = 2;
  seg.frame = NSMakeRect(95, 307, 250, 24);
  [pane addSubview:seg];

  // Color well
  NSTextField *label2 = [NSTextField labelWithString:@"Accent:"];
  label2.frame = NSMakeRect(30, 270, 60, 20);
  [pane addSubview:label2];

  NSColorWell *colorWell = [[NSColorWell alloc] initWithFrame:NSMakeRect(95, 265, 44, 30)];
  colorWell.color = [NSColor controlAccentColor];
  if (@available(macOS 13.0, *)) {
    colorWell.colorWellStyle = NSColorWellStyleMinimal;
  }
  [pane addSubview:colorWell];

  // Radio buttons
  NSTextField *label3 = [NSTextField labelWithString:@"Sidebar size:"];
  label3.frame = NSMakeRect(30, 220, 100, 20);
  [pane addSubview:label3];

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

  NSButton *check1 = [NSButton checkboxWithTitle:@"Show notifications" target:nil action:nil];
  check1.state = NSControlStateValueOn;
  check1.frame = NSMakeRect(30, 310, 250, 20);
  [pane addSubview:check1];

  NSButton *check2 = [NSButton checkboxWithTitle:@"Play sound for notifications" target:nil action:nil];
  check2.state = NSControlStateValueOn;
  check2.frame = NSMakeRect(30, 280, 250, 20);
  [pane addSubview:check2];

  NSButton *check3 = [NSButton checkboxWithTitle:@"Show badge on dock icon" target:nil action:nil];
  check3.frame = NSMakeRect(30, 250, 250, 20);
  [pane addSubview:check3];

  NSTextField *label = [NSTextField labelWithString:@"Notification style:"];
  label.frame = NSMakeRect(30, 210, 130, 20);
  [pane addSubview:label];

  NSPopUpButton *popup = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(165, 207, 200, 25) pullsDown:NO];
  [popup addItemsWithTitles:@[@"Banners", @"Alerts", @"None"]];
  [pane addSubview:popup];

  return pane;
}

- (NSView *)privacyPane {
  NSView *pane = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 500, 400)];

  NSTextField *header = [NSTextField labelWithString:@"Privacy & Security"];
  header.font = [NSFont systemFontOfSize:20 weight:NSFontWeightSemibold];
  header.frame = NSMakeRect(30, 350, 250, 30);
  [pane addSubview:header];

  // Progress indicator (as if scanning)
  NSProgressIndicator *progress = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(30, 310, 300, 20)];
  progress.style = NSProgressIndicatorStyleBar;
  progress.indeterminate = NO;
  progress.doubleValue = 75.0;
  [pane addSubview:progress];

  NSTextField *progressLabel = [NSTextField labelWithString:@"Security scan: 75% complete"];
  progressLabel.font = [NSFont systemFontOfSize:11];
  progressLabel.textColor = [NSColor secondaryLabelColor];
  progressLabel.frame = NSMakeRect(30, 288, 300, 16);
  [pane addSubview:progressLabel];

  NSButton *check1 = [NSButton checkboxWithTitle:@"Require password after sleep" target:nil action:nil];
  check1.state = NSControlStateValueOn;
  check1.frame = NSMakeRect(30, 250, 250, 20);
  [pane addSubview:check1];

  NSButton *check2 = [NSButton checkboxWithTitle:@"Allow apps from App Store only" target:nil action:nil];
  check2.frame = NSMakeRect(30, 220, 250, 20);
  [pane addSubview:check2];

  // Level indicator
  NSTextField *label = [NSTextField labelWithString:@"Password strength:"];
  label.frame = NSMakeRect(30, 180, 130, 20);
  [pane addSubview:label];

  NSLevelIndicator *level = [[NSLevelIndicator alloc] initWithFrame:NSMakeRect(165, 180, 150, 18)];
  level.maxValue = 5;
  level.warningValue = 3;
  level.criticalValue = 1;
  level.doubleValue = 4;
  level.levelIndicatorStyle = NSLevelIndicatorStyleContinuousCapacity;
  [pane addSubview:level];

  return pane;
}

- (void)layout {
  [super layout];
  _tabView.frame = self.bounds;
}

// Toolbar delegate for prefs
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

  NSString *iconName;
  if ([itemIdentifier isEqualToString:@"General"]) iconName = @"gearshape.fill";
  else if ([itemIdentifier isEqualToString:@"Appearance"]) iconName = @"paintbrush.fill";
  else if ([itemIdentifier isEqualToString:@"Notifications"]) iconName = @"bell.badge.fill";
  else if ([itemIdentifier isEqualToString:@"Privacy"]) iconName = @"lock.shield.fill";

  if (iconName) {
    item.image = [NSImage imageWithSystemSymbolName:iconName accessibilityDescription:itemIdentifier];
  }
  return item;
}

- (void)switchTab:(NSToolbarItem *)sender {
  NSInteger idx = [_tabView indexOfTabViewItemWithIdentifier:sender.itemIdentifier];
  if (idx != NSNotFound) {
    [_tabView selectTabViewItemAtIndex:idx];
    if (_onTabChange) {
      _onTabChange(@{@"tab": sender.itemIdentifier});
    }
  }
}

@end

// ============================================================
// 3. Map-style view with NSVisualEffectView overlays
// ============================================================

@interface RCTMapOverlayView : NSView
@property (nonatomic, strong) NSVisualEffectView *topBar;
@property (nonatomic, strong) NSVisualEffectView *bottomBar;
@property (nonatomic, strong) NSView *mapPlaceholder;
@property (nonatomic, strong) NSSegmentedControl *mapTypeControl;
@property (nonatomic, strong) NSTextField *coordLabel;
@end

@implementation RCTMapOverlayView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    // Map placeholder with gradient
    _mapPlaceholder = [[NSView alloc] initWithFrame:self.bounds];
    _mapPlaceholder.wantsLayer = YES;
    _mapPlaceholder.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = @[(id)[NSColor colorWithSRGBRed:0.85 green:0.92 blue:0.85 alpha:1].CGColor,
                        (id)[NSColor colorWithSRGBRed:0.78 green:0.88 blue:0.95 alpha:1].CGColor];
    _mapPlaceholder.layer = gradient;
    [self addSubview:_mapPlaceholder];

    // Add some "map" elements
    for (int i = 0; i < 8; i++) {
      NSView *road = [[NSView alloc] init];
      road.wantsLayer = YES;
      road.layer.backgroundColor = [NSColor colorWithWhite:1.0 alpha:0.5].CGColor;
      CGFloat y = 30 + arc4random_uniform(300);
      road.frame = NSMakeRect(0, y, 600, 2);
      road.autoresizingMask = NSViewWidthSizable;
      [_mapPlaceholder addSubview:road];
    }
    for (int i = 0; i < 6; i++) {
      NSView *road = [[NSView alloc] init];
      road.wantsLayer = YES;
      road.layer.backgroundColor = [NSColor colorWithWhite:1.0 alpha:0.5].CGColor;
      CGFloat x = 30 + arc4random_uniform(500);
      road.frame = NSMakeRect(x, 0, 2, 600);
      road.autoresizingMask = NSViewHeightSizable;
      [_mapPlaceholder addSubview:road];
    }

    // Pin
    NSTextField *pin = [NSTextField labelWithString:@"\U0001F4CD"];
    pin.font = [NSFont systemFontOfSize:28];
    pin.frame = NSMakeRect(200, 200, 40, 40);
    [_mapPlaceholder addSubview:pin];

    // Top bar (vibrancy)
    _topBar = [[NSVisualEffectView alloc] initWithFrame:NSZeroRect];
    _topBar.material = NSVisualEffectMaterialMenu;
    _topBar.blendingMode = NSVisualEffectBlendingModeWithinWindow;
    _topBar.autoresizingMask = NSViewWidthSizable | NSViewMinYMargin;

    _mapTypeControl = [NSSegmentedControl segmentedControlWithLabels:@[@"Map", @"Satellite", @"Hybrid"]
                                                        trackingMode:NSSegmentSwitchTrackingSelectOne
                                                              target:nil action:nil];
    _mapTypeControl.selectedSegment = 0;
    [_topBar addSubview:_mapTypeControl];

    NSSearchField *searchField = [[NSSearchField alloc] init];
    searchField.placeholderString = @"Search location...";
    [_topBar addSubview:searchField];

    [self addSubview:_topBar];

    // Bottom bar
    _bottomBar = [[NSVisualEffectView alloc] initWithFrame:NSZeroRect];
    _bottomBar.material = NSVisualEffectMaterialMenu;
    _bottomBar.blendingMode = NSVisualEffectBlendingModeWithinWindow;
    _bottomBar.autoresizingMask = NSViewWidthSizable | NSViewMaxYMargin;

    _coordLabel = [NSTextField labelWithString:@"37.7749\u00B0 N, 122.4194\u00B0 W"];
    _coordLabel.font = [NSFont monospacedSystemFontOfSize:11 weight:NSFontWeightRegular];
    _coordLabel.textColor = [NSColor secondaryLabelColor];
    [_bottomBar addSubview:_coordLabel];

    // Zoom buttons
    NSButton *zoomIn = [NSButton buttonWithImage:[NSImage imageWithSystemSymbolName:@"plus" accessibilityDescription:@"Zoom In"] target:nil action:nil];
    zoomIn.bezelStyle = NSBezelStyleAccessoryBarAction;
    zoomIn.tag = 1;
    [_bottomBar addSubview:zoomIn];

    NSButton *zoomOut = [NSButton buttonWithImage:[NSImage imageWithSystemSymbolName:@"minus" accessibilityDescription:@"Zoom Out"] target:nil action:nil];
    zoomOut.bezelStyle = NSBezelStyleAccessoryBarAction;
    zoomOut.tag = 2;
    [_bottomBar addSubview:zoomOut];

    [self addSubview:_bottomBar];
  }
  return self;
}

- (void)layout {
  [super layout];
  NSRect b = self.bounds;
  _mapPlaceholder.frame = b;

  CGFloat barH = 44;
  _topBar.frame = NSMakeRect(0, b.size.height - barH, b.size.width, barH);
  _bottomBar.frame = NSMakeRect(0, 0, b.size.width, 36);

  // Layout top bar contents
  CGFloat pad = 10;
  _mapTypeControl.frame = NSMakeRect(pad, (barH - 24) / 2, 200, 24);
  NSSearchField *search = nil;
  for (NSView *v in _topBar.subviews) {
    if ([v isKindOfClass:[NSSearchField class]]) { search = (NSSearchField *)v; break; }
  }
  if (search) {
    search.frame = NSMakeRect(b.size.width - 210, (barH - 24) / 2, 200, 24);
  }

  // Layout bottom bar contents
  _coordLabel.frame = NSMakeRect(pad, (36 - 16) / 2, 250, 16);
  CGFloat bx = b.size.width - pad;
  for (NSView *v in _bottomBar.subviews) {
    if ([v isKindOfClass:[NSButton class]]) {
      bx -= 30;
      v.frame = NSMakeRect(bx, (36 - 24) / 2, 28, 24);
    }
  }
}

@end

// ============================================================
// 4. Showcase container: NSTabView at the bottom
// ============================================================

@interface RCTNativeShowcaseView : NSView
@property (nonatomic, strong) NSTabView *tabView;
@property (nonatomic, strong) RCTPreferencesView *prefsView;
@property (nonatomic, strong) RCTMapOverlayView *mapView;
@end

@implementation RCTNativeShowcaseView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _tabView = [[NSTabView alloc] initWithFrame:self.bounds];
    _tabView.tabViewType = NSTopTabsBezelBorder;
    _tabView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    _tabView.controlSize = NSControlSizeRegular;

    // Tab 1: Finder
    NSTabViewItem *finderTab = [[NSTabViewItem alloc] initWithIdentifier:@"finder"];
    finderTab.label = @"Finder";
    // We can't use RCTFinderView here directly since it needs React, so create a native file browser
    finderTab.view = [self createFinderTab];
    [_tabView addTabViewItem:finderTab];

    // Tab 2: Settings
    NSTabViewItem *prefsTab = [[NSTabViewItem alloc] initWithIdentifier:@"settings"];
    prefsTab.label = @"Settings";
    _prefsView = [[RCTPreferencesView alloc] initWithFrame:NSZeroRect];
    prefsTab.view = _prefsView;
    [_tabView addTabViewItem:prefsTab];

    // Tab 3: Map Overlay
    NSTabViewItem *mapTab = [[NSTabViewItem alloc] initWithIdentifier:@"map"];
    mapTab.label = @"Map";
    _mapView = [[RCTMapOverlayView alloc] initWithFrame:NSZeroRect];
    mapTab.view = _mapView;
    [_tabView addTabViewItem:mapTab];

    // Tab 4: Controls Gallery
    NSTabViewItem *controlsTab = [[NSTabViewItem alloc] initWithIdentifier:@"controls"];
    controlsTab.label = @"Controls";
    controlsTab.view = [self createControlsGallery];
    [_tabView addTabViewItem:controlsTab];

    [self addSubview:_tabView];
  }
  return self;
}

- (NSView *)createFinderTab {
  // Native file browser using NSOutlineView + NSTableView
  NSSplitView *split = [[NSSplitView alloc] initWithFrame:NSZeroRect];
  split.vertical = YES;
  split.dividerStyle = NSSplitViewDividerStyleThin;
  split.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;

  // Sidebar
  NSOutlineView *outline = [[NSOutlineView alloc] initWithFrame:NSZeroRect];
  outline.headerView = nil;
  outline.selectionHighlightStyle = NSTableViewSelectionHighlightStyleSourceList;
  NSTableColumn *col = [[NSTableColumn alloc] initWithIdentifier:@"name"];
  [outline addTableColumn:col];
  outline.outlineTableColumn = col;

  NSScrollView *sideScroll = [[NSScrollView alloc] init];
  sideScroll.documentView = outline;
  sideScroll.hasVerticalScroller = YES;
  sideScroll.autohidesScrollers = YES;
  sideScroll.drawsBackground = NO;

  NSVisualEffectView *sideEffect = [[NSVisualEffectView alloc] init];
  sideEffect.material = NSVisualEffectMaterialSidebar;
  sideEffect.blendingMode = NSVisualEffectBlendingModeBehindWindow;
  sideScroll.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
  [sideEffect addSubview:sideScroll];

  // Table placeholder
  NSTableView *table = [[NSTableView alloc] initWithFrame:NSZeroRect];
  table.usesAlternatingRowBackgroundColors = YES;
  table.style = NSTableViewStyleFullWidth;

  NSTableColumn *nameCol = [[NSTableColumn alloc] initWithIdentifier:@"name"];
  nameCol.title = @"Name";
  nameCol.width = 250;
  [table addTableColumn:nameCol];

  NSTableColumn *sizeCol = [[NSTableColumn alloc] initWithIdentifier:@"size"];
  sizeCol.title = @"Size";
  sizeCol.width = 80;
  [table addTableColumn:sizeCol];

  NSTableColumn *kindCol = [[NSTableColumn alloc] initWithIdentifier:@"kind"];
  kindCol.title = @"Kind";
  kindCol.width = 120;
  [table addTableColumn:kindCol];

  NSScrollView *tableScroll = [[NSScrollView alloc] init];
  tableScroll.documentView = table;
  tableScroll.hasVerticalScroller = YES;
  tableScroll.autohidesScrollers = YES;

  [split addSubview:sideEffect];
  [split addSubview:tableScroll];
  [split setPosition:200 ofDividerAtIndex:0];

  return split;
}

- (NSView *)createControlsGallery {
  NSScrollView *scroll = [[NSScrollView alloc] initWithFrame:NSZeroRect];
  scroll.hasVerticalScroller = YES;
  scroll.autohidesScrollers = YES;
  scroll.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;

  NSView *content = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 600, 700)];
  CGFloat y = 660;

  // Title
  NSTextField *title = [NSTextField labelWithString:@"Native macOS Controls"];
  title.font = [NSFont systemFontOfSize:22 weight:NSFontWeightBold];
  title.frame = NSMakeRect(30, y, 400, 30);
  [content addSubview:title];
  y -= 45;

  // Buttons section
  NSTextField *btnLabel = [NSTextField labelWithString:@"Buttons"];
  btnLabel.font = [NSFont systemFontOfSize:13 weight:NSFontWeightSemibold];
  btnLabel.textColor = [NSColor secondaryLabelColor];
  btnLabel.frame = NSMakeRect(30, y, 200, 20);
  [content addSubview:btnLabel];
  y -= 35;

  NSButton *btn1 = [NSButton buttonWithTitle:@"Push Button" target:nil action:nil];
  btn1.bezelStyle = NSBezelStylePush;
  btn1.frame = NSMakeRect(30, y, 120, 24);
  [content addSubview:btn1];

  NSButton *btn2 = [NSButton buttonWithTitle:@"Textured" target:nil action:nil];
  btn2.bezelStyle = NSBezelStyleTexturedSquare;
  btn2.frame = NSMakeRect(160, y, 100, 24);
  [content addSubview:btn2];

  NSButton *btn3 = [NSButton buttonWithImage:[NSImage imageWithSystemSymbolName:@"plus" accessibilityDescription:@"Add"] target:nil action:nil];
  btn3.bezelStyle = NSBezelStyleAccessoryBarAction;
  btn3.frame = NSMakeRect(270, y, 30, 24);
  [content addSubview:btn3];

  NSButton *btn4 = [NSButton buttonWithImage:[NSImage imageWithSystemSymbolName:@"gear" accessibilityDescription:@"Settings"] target:nil action:nil];
  btn4.bezelStyle = NSBezelStyleAccessoryBarAction;
  btn4.frame = NSMakeRect(310, y, 30, 24);
  [content addSubview:btn4];
  y -= 45;

  // Segmented controls
  NSTextField *segLabel = [NSTextField labelWithString:@"Segmented Controls"];
  segLabel.font = [NSFont systemFontOfSize:13 weight:NSFontWeightSemibold];
  segLabel.textColor = [NSColor secondaryLabelColor];
  segLabel.frame = NSMakeRect(30, y, 200, 20);
  [content addSubview:segLabel];
  y -= 35;

  NSSegmentedControl *seg1 = [NSSegmentedControl segmentedControlWithLabels:@[@"Day", @"Week", @"Month", @"Year"]
                                                                trackingMode:NSSegmentSwitchTrackingSelectOne
                                                                      target:nil action:nil];
  seg1.selectedSegment = 1;
  seg1.frame = NSMakeRect(30, y, 300, 24);
  [content addSubview:seg1];
  y -= 45;

  // Text fields
  NSTextField *tfLabel = [NSTextField labelWithString:@"Text Fields"];
  tfLabel.font = [NSFont systemFontOfSize:13 weight:NSFontWeightSemibold];
  tfLabel.textColor = [NSColor secondaryLabelColor];
  tfLabel.frame = NSMakeRect(30, y, 200, 20);
  [content addSubview:tfLabel];
  y -= 35;

  NSTextField *tf1 = [[NSTextField alloc] initWithFrame:NSMakeRect(30, y, 200, 22)];
  tf1.placeholderString = @"Regular text field";
  [content addSubview:tf1];

  NSSearchField *sf = [[NSSearchField alloc] initWithFrame:NSMakeRect(240, y, 200, 22)];
  sf.placeholderString = @"Search...";
  [content addSubview:sf];
  y -= 35;

  NSSecureTextField *stf = [[NSSecureTextField alloc] initWithFrame:NSMakeRect(30, y, 200, 22)];
  stf.placeholderString = @"Password field";
  [content addSubview:stf];

  NSTokenField *tokenField = [[NSTokenField alloc] initWithFrame:NSMakeRect(240, y, 200, 22)];
  tokenField.placeholderString = @"Tags...";
  [content addSubview:tokenField];
  y -= 45;

  // Sliders & Progress
  NSTextField *sliderLabel = [NSTextField labelWithString:@"Sliders & Progress"];
  sliderLabel.font = [NSFont systemFontOfSize:13 weight:NSFontWeightSemibold];
  sliderLabel.textColor = [NSColor secondaryLabelColor];
  sliderLabel.frame = NSMakeRect(30, y, 200, 20);
  [content addSubview:sliderLabel];
  y -= 35;

  NSSlider *slider1 = [NSSlider sliderWithValue:50 minValue:0 maxValue:100 target:nil action:nil];
  slider1.frame = NSMakeRect(30, y, 200, 20);
  [content addSubview:slider1];

  NSSlider *slider2 = [[NSSlider alloc] initWithFrame:NSMakeRect(240, y - 60, 20, 80)];
  slider2.minValue = 0;
  slider2.maxValue = 100;
  slider2.doubleValue = 70;
  slider2.vertical = YES;
  [content addSubview:slider2];
  y -= 30;

  NSProgressIndicator *prog1 = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(30, y, 200, 20)];
  prog1.style = NSProgressIndicatorStyleBar;
  prog1.doubleValue = 65;
  [content addSubview:prog1];
  y -= 35;

  NSProgressIndicator *prog2 = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(30, y, 32, 32)];
  prog2.style = NSProgressIndicatorStyleSpinning;
  [prog2 startAnimation:nil];
  [content addSubview:prog2];

  NSLevelIndicator *level = [[NSLevelIndicator alloc] initWithFrame:NSMakeRect(80, y + 8, 150, 18)];
  level.maxValue = 10;
  level.warningValue = 6;
  level.criticalValue = 2;
  level.doubleValue = 7;
  level.levelIndicatorStyle = NSLevelIndicatorStyleContinuousCapacity;
  [content addSubview:level];
  y -= 50;

  // Steppers & Date pickers
  NSTextField *dateLabel = [NSTextField labelWithString:@"Date & Stepper"];
  dateLabel.font = [NSFont systemFontOfSize:13 weight:NSFontWeightSemibold];
  dateLabel.textColor = [NSColor secondaryLabelColor];
  dateLabel.frame = NSMakeRect(30, y, 200, 20);
  [content addSubview:dateLabel];
  y -= 35;

  NSDatePicker *datePicker = [[NSDatePicker alloc] initWithFrame:NSMakeRect(30, y, 200, 24)];
  datePicker.datePickerStyle = NSDatePickerStyleTextField;
  datePicker.dateValue = [NSDate date];
  [content addSubview:datePicker];

  NSStepper *stepper = [[NSStepper alloc] initWithFrame:NSMakeRect(240, y, 19, 24)];
  stepper.minValue = 0;
  stepper.maxValue = 100;
  stepper.integerValue = 42;
  [content addSubview:stepper];

  NSTextField *stepVal = [NSTextField labelWithString:@"42"];
  stepVal.frame = NSMakeRect(265, y, 40, 22);
  [content addSubview:stepVal];
  y -= 45;

  // Combo box
  NSTextField *comboLabel = [NSTextField labelWithString:@"Combo Box & Pop Up"];
  comboLabel.font = [NSFont systemFontOfSize:13 weight:NSFontWeightSemibold];
  comboLabel.textColor = [NSColor secondaryLabelColor];
  comboLabel.frame = NSMakeRect(30, y, 200, 20);
  [content addSubview:comboLabel];
  y -= 35;

  NSComboBox *combo = [[NSComboBox alloc] initWithFrame:NSMakeRect(30, y, 200, 25)];
  [combo addItemsWithObjectValues:@[@"Option A", @"Option B", @"Option C", @"Custom..."]];
  combo.placeholderString = @"Choose or type...";
  [content addSubview:combo];

  NSPopUpButton *popUp = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(240, y, 200, 25) pullsDown:NO];
  [popUp addItemsWithTitles:@[@"English", @"German", @"Japanese", @"PureScript"]];
  [content addSubview:popUp];

  scroll.documentView = content;
  return scroll;
}

- (void)viewDidMoveToWindow {
  [super viewDidMoveToWindow];
  // Remove any toolbar the preferences view might have set
  if (self.window) {
    self.window.toolbar = nil;
    self.window.title = @"Native macOS Showcase";
  }
}

- (void)layout {
  [super layout];
  _tabView.frame = self.bounds;
}

@end

// ============================================================
// View Managers
// ============================================================

@interface RCTToolbarViewManager : RCTViewManager
@end
@implementation RCTToolbarViewManager
RCT_EXPORT_MODULE(ToolbarView)
- (NSView *)view { return [[RCTToolbarView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(onAction, RCTBubblingEventBlock)
@end

@interface RCTPreferencesViewManager : RCTViewManager
@end
@implementation RCTPreferencesViewManager
RCT_EXPORT_MODULE(PreferencesView)
- (NSView *)view { return [[RCTPreferencesView alloc] initWithFrame:CGRectZero]; }
RCT_EXPORT_VIEW_PROPERTY(onTabChange, RCTBubblingEventBlock)
@end

@interface RCTMapOverlayViewManager : RCTViewManager
@end
@implementation RCTMapOverlayViewManager
RCT_EXPORT_MODULE(MapOverlayView)
- (NSView *)view { return [[RCTMapOverlayView alloc] initWithFrame:CGRectZero]; }
@end

@interface RCTNativeShowcaseViewManager : RCTViewManager
@end
@implementation RCTNativeShowcaseViewManager
RCT_EXPORT_MODULE(NativeShowcase)
- (NSView *)view { return [[RCTNativeShowcaseView alloc] initWithFrame:CGRectZero]; }
@end
