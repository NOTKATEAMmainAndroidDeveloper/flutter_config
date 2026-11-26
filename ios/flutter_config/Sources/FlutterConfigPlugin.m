#import "FlutterConfigPlugin.h"
#if !defined(FLUTTER_CONFIG_SWIFTPM)
#import "../../Classes/GeneratedDotEnv.m"
#endif

@implementation FlutterConfigPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_config"
            binaryMessenger:[registrar messenger]];
  FlutterConfigPlugin* instance = [[FlutterConfigPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

+ (NSDictionary *)env {
#if defined(FLUTTER_CONFIG_SWIFTPM)
    static NSDictionary *variables;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [NSBundle.mainBundle pathForResource:@"FlutterConfigEnv" ofType:@"json"];
        NSData *data = path ? [NSData dataWithContentsOfFile:path] : nil;
        id decoded = data ? [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL] : nil;
        variables = [decoded isKindOfClass:[NSDictionary class]] ? decoded : @{};
    });
    return variables;
#else
    return (NSDictionary *)DOT_ENV;
#endif
}

+ (NSString *)envFor: (NSString *)key {
    NSString *value = (NSString *)[self.env objectForKey:key];
    return value;
}

- (NSDictionary *)constantsToExport {
    return [FlutterConfigPlugin env];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"loadEnvVariables" isEqualToString:call.method]) {
      result([FlutterConfigPlugin env]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
