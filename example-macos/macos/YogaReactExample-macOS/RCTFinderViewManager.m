#import <React/RCTViewManager.h>
#import <React/RCTBridge.h>
#import <React/RCTUIManager.h>
#import <AppKit/AppKit.h>

// ---------- Data model ----------

@interface FinderItem : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, assign) BOOL isDirectory;
@property (nonatomic, assign) double size;
@end

@implementation FinderItem
@end

@interface SidebarItem : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *icon; // SF Symbol name
@property (nonatomic, assign) BOOL isHeader;
@property (nonatomic, strong) NSArray<SidebarItem *> *children;
@end

@implementation SidebarItem
+ (SidebarItem *)headerWithTitle:(NSString *)title children:(NSArray<SidebarItem *> *)children {
  SidebarItem *item = [SidebarItem new];
  item.title = title;
  item.isHeader = YES;
  item.children = children;
  return item;
}
+ (SidebarItem *)itemWithTitle:(NSString *)title path:(NSString *)path icon:(NSString *)icon {
  SidebarItem *item = [SidebarItem new];
  item.title = title;
  item.path = path;
  item.icon = icon;
  item.isHeader = NO;
  return item;
}
@end

// ---------- Main view ----------

@interface RCTFinderView : NSView <NSSplitViewDelegate, NSOutlineViewDataSource, NSOutlineViewDelegate, NSTableViewDataSource, NSTableViewDelegate>
@property (nonatomic, strong) NSSplitView *splitView;
@property (nonatomic, strong) NSOutlineView *sidebarOutline;
@property (nonatomic, strong) NSScrollView *sidebarScroll;
@property (nonatomic, strong) NSVisualEffectView *sidebarEffect;
@property (nonatomic, strong) NSTableView *tableView;
@property (nonatomic, strong) NSScrollView *tableScroll;
@property (nonatomic, strong) NSTextField *statusBar;

@property (nonatomic, strong) NSArray<SidebarItem *> *sidebarSections;
@property (nonatomic, strong) NSMutableArray<FinderItem *> *items;
@property (nonatomic, copy) NSString *currentPath;

@property (nonatomic, copy) RCTBubblingEventBlock onNavigate;
@property (nonatomic, copy) RCTBubblingEventBlock onSelectFile;
@end

@implementation RCTFinderView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _items = [NSMutableArray new];
    _currentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    [self setupSidebarData];
    [self setupUI];
    [self loadDirectory:_currentPath];
  }
  return self;
}

- (void)setupSidebarData {
  NSString *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
  NSString *downloads = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES).firstObject;
  NSString *desktop = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES).firstObject;
  NSString *home = NSHomeDirectory();

  _sidebarSections = @[
    [SidebarItem headerWithTitle:@"Favorites" children:@[
      [SidebarItem itemWithTitle:@"Desktop" path:desktop icon:@"menubar.dock.rectangle"],
      [SidebarItem itemWithTitle:@"Documents" path:docs icon:@"doc.fill"],
      [SidebarItem itemWithTitle:@"Downloads" path:downloads icon:@"arrow.down.circle.fill"],
      [SidebarItem itemWithTitle:@"Home" path:home icon:@"house.fill"],
    ]],
    [SidebarItem headerWithTitle:@"Locations" children:@[
      [SidebarItem itemWithTitle:@"Macintosh HD" path:@"/" icon:@"externaldrive.fill"],
      [SidebarItem itemWithTitle:@"tmp" path:@"/tmp" icon:@"folder.fill"],
    ]],
  ];
}

- (void)setupUI {
  // --- Sidebar ---
  _sidebarOutline = [[NSOutlineView alloc] initWithFrame:NSZeroRect];
  _sidebarOutline.headerView = nil;
  _sidebarOutline.floatsGroupRows = NO;
  _sidebarOutline.rowSizeStyle = NSTableViewRowSizeStyleDefault;
  _sidebarOutline.selectionHighlightStyle = NSTableViewSelectionHighlightStyleSourceList;
  _sidebarOutline.indentationPerLevel = 0;
  _sidebarOutline.dataSource = self;
  _sidebarOutline.delegate = self;

  NSTableColumn *sidebarCol = [[NSTableColumn alloc] initWithIdentifier:@"sidebar"];
  sidebarCol.editable = NO;
  [_sidebarOutline addTableColumn:sidebarCol];
  _sidebarOutline.outlineTableColumn = sidebarCol;

  _sidebarScroll = [[NSScrollView alloc] initWithFrame:NSZeroRect];
  _sidebarScroll.documentView = _sidebarOutline;
  _sidebarScroll.hasVerticalScroller = YES;
  _sidebarScroll.autohidesScrollers = YES;
  _sidebarScroll.drawsBackground = NO;

  _sidebarEffect = [[NSVisualEffectView alloc] initWithFrame:NSZeroRect];
  _sidebarEffect.material = NSVisualEffectMaterialSidebar;
  _sidebarEffect.blendingMode = NSVisualEffectBlendingModeBehindWindow;
  _sidebarEffect.state = NSVisualEffectStateFollowsWindowActiveState;
  _sidebarScroll.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
  [_sidebarEffect addSubview:_sidebarScroll];

  // --- Table ---
  _tableView = [[NSTableView alloc] initWithFrame:NSZeroRect];
  _tableView.rowSizeStyle = NSTableViewRowSizeStyleDefault;
  _tableView.usesAlternatingRowBackgroundColors = YES;
  _tableView.allowsColumnReordering = YES;
  _tableView.allowsColumnResizing = YES;
  _tableView.dataSource = self;
  _tableView.delegate = self;
  _tableView.doubleAction = @selector(tableDoubleClick:);
  _tableView.target = self;
  _tableView.style = NSTableViewStyleFullWidth;

  NSTableColumn *iconCol = [[NSTableColumn alloc] initWithIdentifier:@"icon"];
  iconCol.title = @"";
  iconCol.width = 24;
  iconCol.minWidth = 24;
  iconCol.maxWidth = 24;
  iconCol.editable = NO;
  [_tableView addTableColumn:iconCol];

  NSTableColumn *nameCol = [[NSTableColumn alloc] initWithIdentifier:@"name"];
  nameCol.title = @"Name";
  nameCol.width = 300;
  nameCol.minWidth = 100;
  nameCol.editable = NO;
  nameCol.sortDescriptorPrototype = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
  [_tableView addTableColumn:nameCol];

  NSTableColumn *sizeCol = [[NSTableColumn alloc] initWithIdentifier:@"size"];
  sizeCol.title = @"Size";
  sizeCol.width = 80;
  sizeCol.minWidth = 50;
  sizeCol.editable = NO;
  [_tableView addTableColumn:sizeCol];

  NSTableColumn *kindCol = [[NSTableColumn alloc] initWithIdentifier:@"kind"];
  kindCol.title = @"Kind";
  kindCol.width = 120;
  kindCol.minWidth = 60;
  kindCol.editable = NO;
  [_tableView addTableColumn:kindCol];

  _tableScroll = [[NSScrollView alloc] initWithFrame:NSZeroRect];
  _tableScroll.documentView = _tableView;
  _tableScroll.hasVerticalScroller = YES;
  _tableScroll.autohidesScrollers = YES;

  // --- Status bar ---
  _statusBar = [NSTextField labelWithString:@""];
  _statusBar.font = [NSFont systemFontOfSize:11];
  _statusBar.textColor = [NSColor secondaryLabelColor];
  _statusBar.alignment = NSTextAlignmentCenter;

  // --- Split view ---
  _splitView = [[NSSplitView alloc] initWithFrame:self.bounds];
  _splitView.dividerStyle = NSSplitViewDividerStyleThin;
  _splitView.vertical = YES;
  _splitView.delegate = self;
  _splitView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;

  // Right side: table + status bar
  NSView *rightPane = [[NSView alloc] initWithFrame:NSZeroRect];
  _tableScroll.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
  _statusBar.autoresizingMask = NSViewWidthSizable | NSViewMinYMargin;
  [rightPane addSubview:_tableScroll];
  [rightPane addSubview:_statusBar];

  [_splitView addSubview:_sidebarEffect];
  [_splitView addSubview:rightPane];
  [_splitView setPosition:200 ofDividerAtIndex:0];
  [_splitView setHoldingPriority:NSLayoutPriorityDefaultLow + 1 forSubviewAtIndex:0];

  [self addSubview:_splitView];

  // Expand sidebar sections
  for (SidebarItem *section in _sidebarSections) {
    [_sidebarOutline expandItem:section];
  }
}

- (void)layout {
  [super layout];
  NSRect bounds = self.bounds;
  _splitView.frame = bounds;

  // Layout right pane
  NSView *rightPane = _splitView.subviews.lastObject;
  NSRect rightBounds = rightPane.bounds;
  CGFloat statusH = 22;
  _tableScroll.frame = NSMakeRect(0, statusH, rightBounds.size.width, rightBounds.size.height - statusH);
  _statusBar.frame = NSMakeRect(0, 0, rightBounds.size.width, statusH);

  // Sidebar scroll fills effect view
  _sidebarScroll.frame = _sidebarEffect.bounds;
}

// ---------- Directory loading ----------

- (void)loadDirectory:(NSString *)path {
  _currentPath = path;
  [_items removeAllObjects];

  NSError *error = nil;
  NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
  if (error) {
    [self updateStatusBar];
    [_tableView reloadData];
    return;
  }

  for (NSString *name in contents) {
    NSString *fullPath = [path stringByAppendingPathComponent:name];
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:nil];
    FinderItem *item = [FinderItem new];
    item.name = name;
    item.path = fullPath;
    item.isDirectory = [attrs[NSFileType] isEqualToString:NSFileTypeDirectory];
    item.size = [attrs[NSFileSize] doubleValue];
    [_items addObject:item];
  }

  // Sort: folders first, then alphabetical
  [_items sortUsingComparator:^NSComparisonResult(FinderItem *a, FinderItem *b) {
    if (a.isDirectory && !b.isDirectory) return NSOrderedAscending;
    if (!a.isDirectory && b.isDirectory) return NSOrderedDescending;
    return [a.name caseInsensitiveCompare:b.name];
  }];

  [_tableView reloadData];
  [self updateStatusBar];
}

- (void)updateStatusBar {
  NSInteger folders = 0, files = 0;
  for (FinderItem *item in _items) {
    if (item.isDirectory) folders++; else files++;
  }
  _statusBar.stringValue = [NSString stringWithFormat:@"%ld items", (long)_items.count];
}

- (void)navigateTo:(NSString *)path {
  [self loadDirectory:path];
  if (_onNavigate) {
    _onNavigate(@{@"path": path});
  }
}

// ---------- Sidebar data source ----------

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
  if (!item) return _sidebarSections.count;
  if ([item isKindOfClass:[SidebarItem class]] && ((SidebarItem *)item).isHeader) {
    return ((SidebarItem *)item).children.count;
  }
  return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
  if (!item) return _sidebarSections[index];
  return ((SidebarItem *)item).children[index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
  return [item isKindOfClass:[SidebarItem class]] && ((SidebarItem *)item).isHeader;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item {
  return [item isKindOfClass:[SidebarItem class]] && ((SidebarItem *)item).isHeader;
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
  SidebarItem *si = item;

  if (si.isHeader) {
    NSTableCellView *cell = [outlineView makeViewWithIdentifier:@"HeaderCell" owner:self];
    if (!cell) {
      cell = [[NSTableCellView alloc] init];
      cell.identifier = @"HeaderCell";
      NSTextField *tf = [NSTextField labelWithString:@""];
      tf.font = [NSFont systemFontOfSize:11 weight:NSFontWeightSemibold];
      tf.textColor = [NSColor secondaryLabelColor];
      tf.translatesAutoresizingMaskIntoConstraints = NO;
      [cell addSubview:tf];
      cell.textField = tf;
      [NSLayoutConstraint activateConstraints:@[
        [tf.leadingAnchor constraintEqualToAnchor:cell.leadingAnchor constant:4],
        [tf.centerYAnchor constraintEqualToAnchor:cell.centerYAnchor],
      ]];
    }
    cell.textField.stringValue = si.title.uppercaseString;
    return cell;
  }

  NSTableCellView *cell = [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
  if (!cell) {
    cell = [[NSTableCellView alloc] init];
    cell.identifier = @"DataCell";
    NSImageView *iv = [[NSImageView alloc] init];
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    [cell addSubview:iv];
    cell.imageView = iv;
    NSTextField *tf = [NSTextField labelWithString:@""];
    tf.font = [NSFont systemFontOfSize:13];
    tf.lineBreakMode = NSLineBreakByTruncatingTail;
    tf.translatesAutoresizingMaskIntoConstraints = NO;
    [cell addSubview:tf];
    cell.textField = tf;
    [NSLayoutConstraint activateConstraints:@[
      [iv.leadingAnchor constraintEqualToAnchor:cell.leadingAnchor constant:4],
      [iv.centerYAnchor constraintEqualToAnchor:cell.centerYAnchor],
      [iv.widthAnchor constraintEqualToConstant:18],
      [iv.heightAnchor constraintEqualToConstant:18],
      [tf.leadingAnchor constraintEqualToAnchor:iv.trailingAnchor constant:6],
      [tf.trailingAnchor constraintEqualToAnchor:cell.trailingAnchor constant:-4],
      [tf.centerYAnchor constraintEqualToAnchor:cell.centerYAnchor],
    ]];
  }

  NSImage *img = [NSImage imageWithSystemSymbolName:si.icon accessibilityDescription:si.title];
  if (img) {
    NSImageSymbolConfiguration *config = [NSImageSymbolConfiguration configurationWithPointSize:13 weight:NSFontWeightRegular];
    cell.imageView.image = [img imageWithSymbolConfiguration:config];
    cell.imageView.contentTintColor = [NSColor controlAccentColor];
  }
  cell.textField.stringValue = si.title;
  return cell;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item {
  return ![item isKindOfClass:[SidebarItem class]] || !((SidebarItem *)item).isHeader;
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
  NSInteger row = _sidebarOutline.selectedRow;
  if (row < 0) return;
  SidebarItem *item = [_sidebarOutline itemAtRow:row];
  if (item && !item.isHeader && item.path) {
    [self navigateTo:item.path];
  }
}

// ---------- Table data source ----------

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  return _items.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  FinderItem *item = _items[row];
  NSString *colId = tableColumn.identifier;

  if ([colId isEqualToString:@"icon"]) {
    NSImageView *iv = [tableView makeViewWithIdentifier:@"IconCell" owner:self];
    if (!iv) {
      iv = [[NSImageView alloc] init];
      iv.identifier = @"IconCell";
      iv.imageAlignment = NSImageAlignCenter;
    }
    NSString *symbolName = item.isDirectory ? @"folder.fill" : [self symbolForFile:item.name];
    NSImage *img = [NSImage imageWithSystemSymbolName:symbolName accessibilityDescription:item.name];
    if (img) {
      NSImageSymbolConfiguration *config = [NSImageSymbolConfiguration configurationWithPointSize:14 weight:NSFontWeightRegular];
      iv.image = [img imageWithSymbolConfiguration:config];
      iv.contentTintColor = item.isDirectory ? [NSColor controlAccentColor] : [NSColor secondaryLabelColor];
    }
    return iv;
  }

  NSTableCellView *cell = [tableView makeViewWithIdentifier:colId owner:self];
  if (!cell) {
    cell = [[NSTableCellView alloc] init];
    cell.identifier = colId;
    NSTextField *tf = [NSTextField labelWithString:@""];
    tf.lineBreakMode = NSLineBreakByTruncatingTail;
    tf.translatesAutoresizingMaskIntoConstraints = NO;
    [cell addSubview:tf];
    cell.textField = tf;
    [NSLayoutConstraint activateConstraints:@[
      [tf.leadingAnchor constraintEqualToAnchor:cell.leadingAnchor constant:2],
      [tf.trailingAnchor constraintEqualToAnchor:cell.trailingAnchor constant:-2],
      [tf.centerYAnchor constraintEqualToAnchor:cell.centerYAnchor],
    ]];
  }

  if ([colId isEqualToString:@"name"]) {
    cell.textField.stringValue = item.name;
    cell.textField.font = [NSFont systemFontOfSize:13];
    cell.textField.textColor = [NSColor labelColor];
  } else if ([colId isEqualToString:@"size"]) {
    cell.textField.stringValue = item.isDirectory ? @"--" : [self formatSize:item.size];
    cell.textField.font = [NSFont systemFontOfSize:11];
    cell.textField.textColor = [NSColor secondaryLabelColor];
  } else if ([colId isEqualToString:@"kind"]) {
    cell.textField.stringValue = item.isDirectory ? @"Folder" : [self kindForFile:item.name];
    cell.textField.font = [NSFont systemFontOfSize:11];
    cell.textField.textColor = [NSColor secondaryLabelColor];
  }

  return cell;
}

- (void)tableDoubleClick:(id)sender {
  NSInteger row = _tableView.clickedRow;
  if (row < 0 || row >= (NSInteger)_items.count) return;
  FinderItem *item = _items[row];
  if (item.isDirectory) {
    [self navigateTo:item.path];
  } else if (_onSelectFile) {
    _onSelectFile(@{@"path": item.path, @"name": item.name});
  }
}

// ---------- Split view delegate ----------

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex {
  return 150;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex {
  return 300;
}

// ---------- Helpers ----------

- (NSString *)formatSize:(double)bytes {
  if (bytes < 1024) return [NSString stringWithFormat:@"%d bytes", (int)bytes];
  if (bytes < 1048576) return [NSString stringWithFormat:@"%d KB", (int)(bytes / 1024)];
  if (bytes < 1073741824) return [NSString stringWithFormat:@"%.1f MB", bytes / 1048576];
  return [NSString stringWithFormat:@"%.1f GB", bytes / 1073741824];
}

- (NSString *)symbolForFile:(NSString *)name {
  NSString *ext = name.pathExtension.lowercaseString;
  if ([ext isEqualToString:@"pdf"]) return @"doc.richtext.fill";
  if ([ext isEqualToString:@"txt"] || [ext isEqualToString:@"md"]) return @"doc.text";
  if ([ext isEqualToString:@"json"]) return @"doc.text";
  if ([ext isEqualToString:@"js"] || [ext isEqualToString:@"ts"] || [ext isEqualToString:@"purs"]) return @"doc.text.fill";
  if ([ext isEqualToString:@"png"] || [ext isEqualToString:@"jpg"] || [ext isEqualToString:@"gif"] || [ext isEqualToString:@"svg"]) return @"photo";
  if ([ext isEqualToString:@"zip"] || [ext isEqualToString:@"gz"] || [ext isEqualToString:@"tar"]) return @"doc.zipper";
  return @"doc";
}

- (NSString *)kindForFile:(NSString *)name {
  NSString *ext = name.pathExtension.lowercaseString;
  if ([ext isEqualToString:@"pdf"]) return @"PDF Document";
  if ([ext isEqualToString:@"txt"]) return @"Plain Text";
  if ([ext isEqualToString:@"md"]) return @"Markdown";
  if ([ext isEqualToString:@"json"]) return @"JSON";
  if ([ext isEqualToString:@"js"]) return @"JavaScript";
  if ([ext isEqualToString:@"ts"]) return @"TypeScript";
  if ([ext isEqualToString:@"purs"]) return @"PureScript";
  if ([ext isEqualToString:@"png"]) return @"PNG Image";
  if ([ext isEqualToString:@"jpg"]) return @"JPEG Image";
  if ([ext isEqualToString:@"gif"]) return @"GIF Image";
  if ([ext isEqualToString:@"svg"]) return @"SVG Image";
  if ([ext isEqualToString:@"zip"]) return @"ZIP Archive";
  if ([ext isEqualToString:@"gz"]) return @"Archive";
  if (ext.length == 0) return @"Document";
  return [NSString stringWithFormat:@"%@ File", ext.uppercaseString];
}

// ---------- React props ----------

- (void)setInitialPath:(NSString *)path {
  [self navigateTo:path];
}

@end

// ---------- View Manager ----------

@interface RCTFinderViewManager : RCTViewManager
@end

@implementation RCTFinderViewManager

RCT_EXPORT_MODULE(FinderView)

- (NSView *)view {
  return [[RCTFinderView alloc] initWithFrame:CGRectZero];
}

RCT_EXPORT_VIEW_PROPERTY(onNavigate, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onSelectFile, RCTBubblingEventBlock)
RCT_CUSTOM_VIEW_PROPERTY(initialPath, NSString, RCTFinderView) {
  if (json) {
    [view setInitialPath:[json description]];
  }
}

@end
