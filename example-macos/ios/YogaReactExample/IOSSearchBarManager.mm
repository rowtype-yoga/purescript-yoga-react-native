#import <React/RCTViewManager.h>
#import <UIKit/UIKit.h>

@interface YogaIOSSearchBar : UIView <UISearchBarDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) BOOL showsCancelButton;
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;
@property (nonatomic, copy) RCTDirectEventBlock onChangeText;
@property (nonatomic, copy) RCTDirectEventBlock onSubmit;
@property (nonatomic, copy) RCTDirectEventBlock onCancel;

@end

@implementation YogaIOSSearchBar {
  UISearchBar *_searchBar;
  BOOL _applyingControlledText;
  UITapGestureRecognizer *_outsideTapRecognizer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    _text = @"";
    _placeholder = @"";
    _enabled = YES;

    _searchBar = [UISearchBar new];
    _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _searchBar.delegate = self;
    [self addSubview:_searchBar];
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  _searchBar.frame = self.bounds;
}

- (void)setText:(NSString *)text
{
  NSString *nextText = [text isKindOfClass:NSString.class] ? text : @"";
  _text = [nextText copy];
  if ([_searchBar.text isEqualToString:nextText]) {
    return;
  }

  _applyingControlledText = YES;
  _searchBar.text = nextText;
  _applyingControlledText = NO;
}

- (void)setPlaceholder:(NSString *)placeholder
{
  NSString *nextPlaceholder = [placeholder isKindOfClass:NSString.class] ? placeholder : @"";
  _placeholder = [nextPlaceholder copy];
  _searchBar.placeholder = nextPlaceholder;
}

- (void)setShowsCancelButton:(BOOL)showsCancelButton
{
  _showsCancelButton = showsCancelButton;
  [_searchBar setShowsCancelButton:showsCancelButton animated:NO];
}

- (void)setEnabled:(BOOL)enabled
{
  _enabled = enabled;
  _searchBar.userInteractionEnabled = enabled;
  _searchBar.searchTextField.enabled = enabled;
}

- (void)removeOutsideTapRecognizer
{
  if (_outsideTapRecognizer != nil) {
    [_outsideTapRecognizer.view removeGestureRecognizer:_outsideTapRecognizer];
    _outsideTapRecognizer = nil;
  }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
  [self removeOutsideTapRecognizer];
  if (self.window == nil) {
    return;
  }
  _outsideTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(outsideViewTapped:)];
  _outsideTapRecognizer.cancelsTouchesInView = NO;
  _outsideTapRecognizer.delaysTouchesBegan = NO;
  _outsideTapRecognizer.delegate = self;
  [self.window addGestureRecognizer:_outsideTapRecognizer];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
  [self removeOutsideTapRecognizer];
}

- (void)outsideViewTapped:(UITapGestureRecognizer *)recognizer
{
  [_searchBar resignFirstResponder];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
  return ![touch.view isDescendantOfView:self];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
    shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
  return YES;
}

- (void)dealloc
{
  [self removeOutsideTapRecognizer];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
  if (_applyingControlledText) {
    return;
  }
  if (self.onChangeText != nil) {
    self.onChangeText(@{ @"text": searchText ?: @"" });
  }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
  [searchBar resignFirstResponder];
  if (self.onSubmit != nil) {
    self.onSubmit(@{ @"text": searchBar.text ?: @"" });
  }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
  [searchBar resignFirstResponder];
  if (self.onCancel != nil) {
    self.onCancel(@{});
  }
}

@end

@interface IOSSearchBarManager : RCTViewManager
@end

@implementation IOSSearchBarManager

RCT_EXPORT_MODULE(IOSSearchBar)

+ (BOOL)requiresMainQueueSetup
{
  return YES;
}

- (UIView *)view
{
  return [YogaIOSSearchBar new];
}

RCT_EXPORT_VIEW_PROPERTY(text, NSString)
RCT_EXPORT_VIEW_PROPERTY(placeholder, NSString)
RCT_EXPORT_VIEW_PROPERTY(showsCancelButton, BOOL)
RCT_EXPORT_VIEW_PROPERTY(enabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onChangeText, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onSubmit, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onCancel, RCTDirectEventBlock)

@end
