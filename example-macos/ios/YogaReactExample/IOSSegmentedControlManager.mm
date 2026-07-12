#import <React/RCTViewManager.h>
#import <UIKit/UIKit.h>

@interface YogaIOSSegmentedControl : UIView

@property (nonatomic, copy) NSArray<NSDictionary *> *items;
@property (nonatomic, copy) NSString *selectedId;
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;
@property (nonatomic, copy) RCTDirectEventBlock onSelect;

@end

@implementation YogaIOSSegmentedControl {
  UISegmentedControl *_segmentedControl;
  NSArray<NSString *> *_itemIDs;
  NSDictionary<NSString *, NSNumber *> *_indexesByID;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    _items = @[];
    _itemIDs = @[];
    _indexesByID = @{};
    _selectedId = @"";
    _enabled = YES;

    _segmentedControl = [UISegmentedControl new];
    _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_segmentedControl addTarget:self action:@selector(selectionDidChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_segmentedControl];
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  _segmentedControl.frame = self.bounds;
}

- (void)setItems:(NSArray<NSDictionary *> *)items
{
  _items = [items copy] ?: @[];

  NSMutableArray<NSString *> *desiredIDs = [NSMutableArray arrayWithCapacity:_items.count];
  NSMutableDictionary<NSString *, NSString *> *titlesByID = [NSMutableDictionary dictionaryWithCapacity:_items.count];
  for (id rawItem in _items) {
    if (![rawItem isKindOfClass:NSDictionary.class]) {
      continue;
    }
    NSDictionary *item = rawItem;
    id rawID = item[@"id"];
    if (![rawID isKindOfClass:NSString.class] || [(NSString *)rawID length] == 0 || titlesByID[rawID] != nil) {
      continue;
    }
    id rawTitle = item[@"title"];
    NSString *itemID = rawID;
    [desiredIDs addObject:itemID];
    titlesByID[itemID] = [rawTitle isKindOfClass:NSString.class] ? rawTitle : @"";
  }

  NSMutableArray<NSString *> *currentIDs = [_itemIDs mutableCopy];
  [desiredIDs enumerateObjectsUsingBlock:^(NSString *itemID, NSUInteger desiredIndex, BOOL *stop) {
    NSUInteger currentIndex = [currentIDs indexOfObject:itemID];
    if (currentIndex == NSNotFound) {
      [self->_segmentedControl insertSegmentWithTitle:titlesByID[itemID] atIndex:desiredIndex animated:NO];
      [currentIDs insertObject:itemID atIndex:desiredIndex];
    } else if (currentIndex != desiredIndex) {
      [self->_segmentedControl removeSegmentAtIndex:currentIndex animated:NO];
      [currentIDs removeObjectAtIndex:currentIndex];
      [self->_segmentedControl insertSegmentWithTitle:titlesByID[itemID] atIndex:desiredIndex animated:NO];
      [currentIDs insertObject:itemID atIndex:desiredIndex];
    }
    [self->_segmentedControl setTitle:titlesByID[itemID] forSegmentAtIndex:desiredIndex];
  }];

  while (currentIDs.count > desiredIDs.count) {
    NSUInteger finalIndex = currentIDs.count - 1;
    [_segmentedControl removeSegmentAtIndex:finalIndex animated:NO];
    [currentIDs removeObjectAtIndex:finalIndex];
  }

  NSMutableDictionary<NSString *, NSNumber *> *indexes = [NSMutableDictionary dictionaryWithCapacity:desiredIDs.count];
  [desiredIDs enumerateObjectsUsingBlock:^(NSString *itemID, NSUInteger index, BOOL *stop) {
    indexes[itemID] = @(index);
  }];
  _itemIDs = [desiredIDs copy];
  _indexesByID = [indexes copy];
  [self applyControlledSelection];
}

- (void)setSelectedId:(NSString *)selectedId
{
  _selectedId = [selectedId isKindOfClass:NSString.class] ? [selectedId copy] : @"";
  [self applyControlledSelection];
}

- (void)setEnabled:(BOOL)enabled
{
  _enabled = enabled;
  _segmentedControl.enabled = enabled;
}

- (void)applyControlledSelection
{
  NSNumber *index = _selectedId.length == 0 ? nil : _indexesByID[_selectedId];
  _segmentedControl.selectedSegmentIndex = index == nil ? UISegmentedControlNoSegment : index.integerValue;
}

- (void)selectionDidChange:(UISegmentedControl *)sender
{
  NSInteger index = sender.selectedSegmentIndex;
  if (index >= 0 && index < (NSInteger)_itemIDs.count && self.onSelect != nil) {
    self.onSelect(@{ @"id": _itemIDs[(NSUInteger)index], @"index": @(index) });
  }
  [self applyControlledSelection];
}

@end

@interface IOSSegmentedControlManager : RCTViewManager
@end

@implementation IOSSegmentedControlManager

RCT_EXPORT_MODULE(IOSSegmentedControl)

+ (BOOL)requiresMainQueueSetup
{
  return YES;
}

- (UIView *)view
{
  return [YogaIOSSegmentedControl new];
}

RCT_EXPORT_VIEW_PROPERTY(items, NSArray)
RCT_EXPORT_VIEW_PROPERTY(selectedId, NSString)
RCT_EXPORT_VIEW_PROPERTY(enabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onSelect, RCTDirectEventBlock)

@end
