#import <React/RCTViewManager.h>
#import <UIKit/UIKit.h>

namespace {

NSDate *DateFromISO8601String(NSString *value)
{
  if (![value isKindOfClass:NSString.class] || value.length == 0) {
    return nil;
  }

  static NSISO8601DateFormatter *fractionalFormatter;
  static NSISO8601DateFormatter *standardFormatter;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    fractionalFormatter = [NSISO8601DateFormatter new];
    fractionalFormatter.formatOptions = NSISO8601DateFormatWithInternetDateTime |
        NSISO8601DateFormatWithFractionalSeconds;
    standardFormatter = [NSISO8601DateFormatter new];
    standardFormatter.formatOptions = NSISO8601DateFormatWithInternetDateTime;
  });

  return [fractionalFormatter dateFromString:value] ?: [standardFormatter dateFromString:value];
}

NSString *ISO8601StringFromDate(NSDate *date)
{
  static NSDateFormatter *formatter;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    formatter = [NSDateFormatter new];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    formatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
  });
  return [formatter stringFromDate:date];
}

} // namespace

@interface YogaIOSDatePicker : UIView

@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *mode;
@property (nonatomic, copy) NSString *min;
@property (nonatomic, copy) NSString *max;
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;
@property (nonatomic, copy) RCTDirectEventBlock onDateChange;

@end

@implementation YogaIOSDatePicker {
  UIDatePicker *_datePicker;
  NSDate *_controlledDate;
  NSDate *_minimumDate;
  NSDate *_maximumDate;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    _datePicker = [UIDatePicker new];
    _datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_datePicker addTarget:self action:@selector(dateDidChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_datePicker];

    _controlledDate = _datePicker.date;
    _value = ISO8601StringFromDate(_controlledDate);
    _mode = @"datetime";
    _min = @"";
    _max = @"";
    _enabled = YES;
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  _datePicker.frame = self.bounds;
}

- (void)setValue:(NSString *)value
{
  NSDate *date = DateFromISO8601String(value);
  if (date == nil) {
    return;
  }

  _value = [value copy];
  _controlledDate = date;
  [_datePicker setDate:date animated:NO];
}

- (void)setMode:(NSString *)mode
{
  if ([mode isEqualToString:@"date"]) {
    _datePicker.datePickerMode = UIDatePickerModeDate;
  } else if ([mode isEqualToString:@"time"]) {
    _datePicker.datePickerMode = UIDatePickerModeTime;
  } else if ([mode isEqualToString:@"datetime"]) {
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
  } else {
    return;
  }
  _mode = [mode copy];
}

- (void)setMin:(NSString *)min
{
  if (![min isKindOfClass:NSString.class]) {
    return;
  }
  NSDate *date = min.length == 0 ? nil : DateFromISO8601String(min);
  if (min.length > 0 && date == nil) {
    return;
  }
  _min = [min copy];
  _minimumDate = date;
  [self applyDateBounds];
}

- (void)setMax:(NSString *)max
{
  if (![max isKindOfClass:NSString.class]) {
    return;
  }
  NSDate *date = max.length == 0 ? nil : DateFromISO8601String(max);
  if (max.length > 0 && date == nil) {
    return;
  }
  _max = [max copy];
  _maximumDate = date;
  [self applyDateBounds];
}

- (void)setEnabled:(BOOL)enabled
{
  _enabled = enabled;
  _datePicker.enabled = enabled;
}

- (void)applyDateBounds
{
  if (_minimumDate != nil && _maximumDate != nil && [_minimumDate compare:_maximumDate] == NSOrderedDescending) {
    _datePicker.minimumDate = nil;
    _datePicker.maximumDate = nil;
    return;
  }
  _datePicker.minimumDate = _minimumDate;
  _datePicker.maximumDate = _maximumDate;
}

- (void)dateDidChange:(UIDatePicker *)sender
{
  if (self.onDateChange != nil) {
    self.onDateChange(@{ @"value": ISO8601StringFromDate(sender.date) });
  }
  if (_controlledDate != nil) {
    [sender setDate:_controlledDate animated:NO];
  }
}

@end

@interface IOSDatePickerManager : RCTViewManager
@end

@implementation IOSDatePickerManager

RCT_EXPORT_MODULE(IOSDatePicker)

+ (BOOL)requiresMainQueueSetup
{
  return YES;
}

- (UIView *)view
{
  return [YogaIOSDatePicker new];
}

RCT_EXPORT_VIEW_PROPERTY(value, NSString)
RCT_EXPORT_VIEW_PROPERTY(mode, NSString)
RCT_EXPORT_VIEW_PROPERTY(min, NSString)
RCT_EXPORT_VIEW_PROPERTY(max, NSString)
RCT_EXPORT_VIEW_PROPERTY(enabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onDateChange, RCTDirectEventBlock)

@end
