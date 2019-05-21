#import "RPSLogger.h"
#import "asl.h"

#define MAKE_LOG_FUNC(LEVEL, FUNC_NAME) \
+ (void) v##FUNC_NAME: (const char *)format withArgs:(va_list)args { \
[RPSLogger vlogASL:LEVEL withFormat:format andArgs:args];\
}\
\
+ (void) FUNC_NAME: (const char*) format, ... { \
va_list args;\
va_start(args, format);\
[RPSLogger v##FUNC_NAME:format withArgs:args];\
va_end(args);\
}

BOOL gRPSLogModeEnabled = YES;
const char* kSubSystem = "com.rakuten.ad.rps";
const char* kCategory = "sdk";

@implementation RPSLogger

// template function
//+(void)vdebug:(NSString *)format withArgs:(va_list)args {
//    [RPSLogger vlogASL:ASL_LEVEL_DEBUG withFormat:format andArgs:args];
//}
//
//+(void)debug:(NSString *)format, ... {
//    va_list args;
//    va_start(args, format);
//    [RPSLogger vdebug:format withArgs:args];
//    va_end(args);
//}


MAKE_LOG_FUNC(ASL_LEVEL_INFO, info)
MAKE_LOG_FUNC(ASL_LEVEL_DEBUG, debug)

+(void) vlogASL:(int)level withFormat:(const char*) format andArgs:(va_list) args {
    static aslclient client;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = asl_open(kSubSystem, kCategory, ASL_OPT_STDERR);
    });

    asl_vlog(client, NULL, level, format, args);
}

+(void) logASL:(int)level withFormat:(const char*) format, ...{
    va_list args;
    va_start(args, format);
    [RPSLogger vlogASL:level withFormat:format andArgs:args];
    va_end(args);
}

+(os_log_t) sharedLog {
    static os_log_t sharedLog;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLog = os_log_create(kSubSystem, kCategory);
    });
    return sharedLog;
}

@end
