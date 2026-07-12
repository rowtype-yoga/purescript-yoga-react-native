#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(HapticFeedback, NSObject)
RCT_EXTERN_METHOD(selectionChanged)
RCT_EXTERN_METHOD(impact:(NSString *)style)
RCT_EXTERN_METHOD(notification:(NSString *)type)
@end
