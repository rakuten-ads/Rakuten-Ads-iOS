#import "RPSLogger.h"

BOOL gRPSLogModeEnabled = YES;
const char* kSubSystem = "com.rakuten.ad.rps";
const char* kCategory = "sdk";

@implementation RPSLogger

+(os_log_t) sharedLog {
    static os_log_t sharedLog;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLog = os_log_create(kSubSystem, kCategory);
    });
    return sharedLog;
}

@end
