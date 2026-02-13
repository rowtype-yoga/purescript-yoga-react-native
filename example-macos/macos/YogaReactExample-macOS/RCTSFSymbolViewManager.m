#import <React/RCTViewManager.h>
#import <AppKit/AppKit.h>

@interface RCTSFSymbolView : NSView
@property (nonatomic, strong) NSImageView *imageView;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGFloat size;
@property (nonatomic, assign) CGFloat weight;
@property (nonatomic, strong) NSColor *color;
@end

@implementation RCTSFSymbolView

- (instancetype)init {
  if (self = [super init]) {
    _imageView = [[NSImageView alloc] init];
    _imageView.imageScaling = NSImageScaleProportionallyUpOrDown;
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_imageView];
    [NSLayoutConstraint activateConstraints:@[
      [_imageView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
      [_imageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
      [_imageView.widthAnchor constraintEqualToAnchor:self.widthAnchor],
      [_imageView.heightAnchor constraintEqualToAnchor:self.heightAnchor],
    ]];
    _size = 16.0;
    _weight = 0.0; // regular
  }
  return self;
}

- (void)updateImage {
  if (!_name) return;

  NSImage *image = [NSImage imageWithSystemSymbolName:_name
                             accessibilityDescription:_name];
  if (!image) return;

  // Apply point size and weight via symbol configuration
  NSFontWeight fontWeight = NSFontWeightRegular;
  if (_weight < -0.3) fontWeight = NSFontWeightLight;
  else if (_weight < 0) fontWeight = NSFontWeightRegular;
  else if (_weight < 0.3) fontWeight = NSFontWeightMedium;
  else if (_weight < 0.5) fontWeight = NSFontWeightSemibold;
  else fontWeight = NSFontWeightBold;

  NSImageSymbolConfiguration *config =
    [NSImageSymbolConfiguration configurationWithPointSize:_size weight:fontWeight];
  NSImage *configured = [image imageWithSymbolConfiguration:config];
  if (configured) image = configured;

  _imageView.image = image;
  _imageView.contentTintColor = _color ?: [NSColor labelColor];
}

- (void)setName:(NSString *)name {
  _name = [name copy];
  [self updateImage];
}

- (void)setSize:(CGFloat)size {
  _size = size;
  [self updateImage];
}

- (void)setWeight:(CGFloat)weight {
  _weight = weight;
  [self updateImage];
}

- (void)setColor:(NSColor *)color {
  _color = color;
  [self updateImage];
}

@end

@interface RCTSFSymbolViewManager : RCTViewManager
@end

@implementation RCTSFSymbolViewManager

RCT_EXPORT_MODULE(SFSymbol)

- (NSView *)view {
  return [[RCTSFSymbolView alloc] init];
}

RCT_EXPORT_VIEW_PROPERTY(name, NSString)
RCT_EXPORT_VIEW_PROPERTY(size, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(weight, CGFloat)
RCT_CUSTOM_VIEW_PROPERTY(color, NSString, RCTSFSymbolView) {
  if (json) {
    NSString *hex = [json description];
    // Parse hex color string like "#007AFF"
    unsigned int rgb = 0;
    NSString *clean = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];
    [[NSScanner scannerWithString:clean] scanHexInt:&rgb];
    CGFloat r = ((rgb >> 16) & 0xFF) / 255.0;
    CGFloat g = ((rgb >> 8) & 0xFF) / 255.0;
    CGFloat b = (rgb & 0xFF) / 255.0;
    view.color = [NSColor colorWithSRGBRed:r green:g blue:b alpha:1.0];
  } else {
    view.color = nil;
  }
}

@end
