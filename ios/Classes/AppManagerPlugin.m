#import "AppManagerPlugin.h"
#if __has_include(<app_manager/app_manager-Swift.h>)
#import <app_manager/app_manager-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "app_manager-Swift.h"
#endif

@implementation AppManagerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAppManagerPlugin registerWithRegistrar:registrar];
}
@end
