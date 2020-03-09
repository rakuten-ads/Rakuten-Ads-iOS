#import "RUNALogger.h"

BOOL gRUNALogVerboseEnabled = NO;
const char* kSubSystem = "com.rakuten.ad.runa";
const char* kCategory = "sdk";

@implementation RUNALogger

+(os_log_t) sharedLog {
    static os_log_t sharedLog;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLog = os_log_create(kSubSystem, kCategory);
    });
    return sharedLog;
}

@end
