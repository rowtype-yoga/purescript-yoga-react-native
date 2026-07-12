#import <React/RCTViewManager.h>
#import <UIKit/UIKit.h>

namespace {
constexpr CGFloat kItemHeight = 52.0;
NSString *const kCellReuseIdentifier = @"IOSCollectionViewCell";
NSString *const kSectionIdentifier = @"items";
}

@interface IOSCollectionViewCell : UICollectionViewCell
- (void)setTitle:(NSString *)title;
@end

@implementation IOSCollectionViewCell {
  UILabel *_titleLabel;
  UIView *_separator;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    self.isAccessibilityElement = YES;
    self.accessibilityTraits = UIAccessibilityTraitButton;

    _titleLabel = [UILabel new];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _titleLabel.adjustsFontForContentSizeCategory = YES;
    _titleLabel.numberOfLines = 1;

    _separator = [UIView new];
    _separator.translatesAutoresizingMaskIntoConstraints = NO;
    _separator.backgroundColor = UIColor.separatorColor;

    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_separator];
    [NSLayoutConstraint activateConstraints:@[
      [_titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16.0],
      [_titleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16.0],
      [_titleLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
      [_separator.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16.0],
      [_separator.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
      [_separator.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
      [_separator.heightAnchor constraintEqualToConstant:0.5],
    ]];

    [self updateAppearance];
  }
  return self;
}

- (void)prepareForReuse
{
  [super prepareForReuse];
  [self setTitle:@""];
  self.selected = NO;
}

- (void)setTitle:(NSString *)title
{
  _titleLabel.text = title;
  self.accessibilityLabel = title;
}

- (void)setSelected:(BOOL)selected
{
  [super setSelected:selected];
  [self updateAppearance];
}

- (void)setHighlighted:(BOOL)highlighted
{
  [super setHighlighted:highlighted];
  [self updateAppearance];
}

- (void)updateAppearance
{
  if (self.selected) {
    self.contentView.backgroundColor = UIColor.systemBlueColor;
    _titleLabel.textColor = UIColor.whiteColor;
    self.accessibilityTraits = UIAccessibilityTraitButton | UIAccessibilityTraitSelected;
  } else if (self.highlighted) {
    self.contentView.backgroundColor = UIColor.tertiarySystemFillColor;
    _titleLabel.textColor = UIColor.labelColor;
    self.accessibilityTraits = UIAccessibilityTraitButton;
  } else {
    self.contentView.backgroundColor = UIColor.systemBackgroundColor;
    _titleLabel.textColor = UIColor.labelColor;
    self.accessibilityTraits = UIAccessibilityTraitButton;
  }
}

@end

@interface YogaIOSCollectionView : UIView <UICollectionViewDelegate>

@property (nonatomic, copy) NSArray<NSDictionary *> *items;
@property (nonatomic, copy, nullable) NSString *selectedId;
@property (nonatomic, assign, getter=isRefreshing) BOOL refreshing;
@property (nonatomic, copy, nullable) RCTDirectEventBlock onSelectItem;
@property (nonatomic, copy, nullable) RCTDirectEventBlock onRefresh;

@end

@implementation YogaIOSCollectionView {
  UICollectionView *_collectionView;
  UICollectionViewFlowLayout *_layout;
  UICollectionViewDiffableDataSource<NSString *, NSString *> *_dataSource;
  UIRefreshControl *_refreshControl;
  NSDictionary<NSString *, NSString *> *_titlesByID;
  NSDictionary<NSString *, NSNumber *> *_indexesByID;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    _items = @[];
    _titlesByID = @{};
    _indexesByID = @{};

    _layout = [UICollectionViewFlowLayout new];
    _layout.minimumLineSpacing = 0;
    _layout.minimumInteritemSpacing = 0;

    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_layout];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.backgroundColor = UIColor.systemBackgroundColor;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.delegate = self;
    [_collectionView registerClass:IOSCollectionViewCell.class forCellWithReuseIdentifier:kCellReuseIdentifier];

    _refreshControl = [UIRefreshControl new];
    [_refreshControl addTarget:self action:@selector(didRequestRefresh:) forControlEvents:UIControlEventValueChanged];
    _collectionView.refreshControl = _refreshControl;

    __weak YogaIOSCollectionView *weakSelf = self;
    _dataSource = [[UICollectionViewDiffableDataSource alloc]
        initWithCollectionView:_collectionView
                  cellProvider:^UICollectionViewCell *(
                      UICollectionView *collectionView,
                      NSIndexPath *indexPath,
                      NSString *itemIdentifier) {
                    YogaIOSCollectionView *strongSelf = weakSelf;
                    IOSCollectionViewCell *cell = [collectionView
                        dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier
                                                 forIndexPath:indexPath];
                    [cell setTitle:strongSelf->_titlesByID[itemIdentifier] ?: @""];
                    return cell;
                  }];

    [self addSubview:_collectionView];
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  _collectionView.frame = self.bounds;
  CGSize itemSize = CGSizeMake(CGRectGetWidth(self.bounds), kItemHeight);
  if (!CGSizeEqualToSize(_layout.itemSize, itemSize)) {
    _layout.itemSize = itemSize;
    [_layout invalidateLayout];
  }
}

- (void)setItems:(NSArray<NSDictionary *> *)items
{
  _items = [items copy] ?: @[];

  NSMutableArray<NSString *> *itemIDs = [NSMutableArray arrayWithCapacity:_items.count];
  NSMutableDictionary<NSString *, NSString *> *titles = [NSMutableDictionary dictionaryWithCapacity:_items.count];
  NSMutableDictionary<NSString *, NSNumber *> *indexes = [NSMutableDictionary dictionaryWithCapacity:_items.count];

  [_items enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger index, BOOL *stop) {
    id rawID = item[@"id"];
    id rawTitle = item[@"title"];
    if (![rawID isKindOfClass:NSString.class] || [(NSString *)rawID length] == 0 || titles[rawID] != nil) {
      return;
    }
    NSString *itemID = rawID;
    [itemIDs addObject:itemID];
    titles[itemID] = [rawTitle isKindOfClass:NSString.class] ? rawTitle : @"";
    indexes[itemID] = @(index);
  }];

  NSSet<NSString *> *oldIDs = [NSSet setWithArray:_dataSource.snapshot.itemIdentifiers];
  _titlesByID = [titles copy];
  _indexesByID = [indexes copy];

  NSDiffableDataSourceSnapshot<NSString *, NSString *> *snapshot = [NSDiffableDataSourceSnapshot new];
  [snapshot appendSectionsWithIdentifiers:@[ kSectionIdentifier ]];
  [snapshot appendItemsWithIdentifiers:itemIDs intoSectionWithIdentifier:kSectionIdentifier];

  NSMutableArray<NSString *> *retainedIDs = [NSMutableArray new];
  for (NSString *itemID in itemIDs) {
    if ([oldIDs containsObject:itemID]) {
      [retainedIDs addObject:itemID];
    }
  }
  if (retainedIDs.count > 0) {
    [snapshot reconfigureItemsWithIdentifiers:retainedIDs];
  }
  [_dataSource applySnapshot:snapshot animatingDifferences:NO];
  [self applyControlledSelection];
}

- (void)setSelectedId:(NSString *)selectedId
{
  _selectedId = [selectedId copy];
  [self applyControlledSelection];
}

- (void)setRefreshing:(BOOL)refreshing
{
  _refreshing = refreshing;
  if (refreshing) {
    [_refreshControl beginRefreshing];
  } else {
    [_refreshControl endRefreshing];
  }
}

- (void)applyControlledSelection
{
  for (NSIndexPath *indexPath in _collectionView.indexPathsForSelectedItems ?: @[]) {
    [_collectionView deselectItemAtIndexPath:indexPath animated:NO];
  }

  if (_selectedId.length == 0) {
    return;
  }

  NSIndexPath *selectedIndexPath = [_dataSource indexPathForItemIdentifier:_selectedId];
  if (selectedIndexPath != nil) {
    [_collectionView selectItemAtIndexPath:selectedIndexPath
                                  animated:NO
                            scrollPosition:UICollectionViewScrollPositionNone];
  }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *itemID = [_dataSource itemIdentifierForIndexPath:indexPath];
  NSNumber *index = itemID == nil ? nil : _indexesByID[itemID];
  if (itemID != nil && index != nil && self.onSelectItem != nil) {
    self.onSelectItem(@{ @"id": itemID, @"index": index });
  }
  [self applyControlledSelection];
}

- (void)didRequestRefresh:(UIRefreshControl *)sender
{
  if (self.onRefresh != nil) {
    self.onRefresh(@{});
  }
  if (!self.isRefreshing) {
    [sender endRefreshing];
  }
}

@end

@interface IOSCollectionViewManager : RCTViewManager
@end

@implementation IOSCollectionViewManager

RCT_EXPORT_MODULE(IOSCollectionView)

+ (BOOL)requiresMainQueueSetup
{
  return YES;
}

- (UIView *)view
{
  return [YogaIOSCollectionView new];
}

RCT_EXPORT_VIEW_PROPERTY(items, NSArray)
RCT_EXPORT_VIEW_PROPERTY(selectedId, NSString)
RCT_EXPORT_VIEW_PROPERTY(refreshing, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onSelectItem, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onRefresh, RCTDirectEventBlock)

@end
