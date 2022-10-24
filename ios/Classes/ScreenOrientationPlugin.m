#import "ScreenOrientationPlugin.h"
#if __has_include(<screen_orientation/screen_orientation-Swift.h>)
#import <screen_orientation/screen_orientation-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "screen_orientation-Swift.h"
#endif

@implementation ScreenOrientationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftScreenOrientationPlugin registerWithRegistrar:registrar];
}
@end
