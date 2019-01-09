#import "GAPLogger.h"
#import "asl.h"

#define MAKE_LOG_FUNC(LEVEL, FUNC_NAME) \
+ (void) FUNC_NAME: (NSString*) format, ...{ \
static aslclient client; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
client = asl_open("GAP-verbose", "GAP-LOG", ASL_OPT_STDERR); \
}); \
\
va_list args; \
va_start(args, format); \
NSString* msg = [[NSString alloc] initWithFormat:format arguments:args]; \
asl_log(client, NULL, ASL_LEVEL_DEBUG, "%s", [msg UTF8String]); \
va_end(args); \
}


@implementation GAPLogger

MAKE_LOG_FUNC(ASL_LEVEL_WARNING, warning)
MAKE_LOG_FUNC(ASL_LEVEL_INFO, info)
MAKE_LOG_FUNC(ASL_LEVEL_DEBUG, debug)

//+(void) debug:(NSString*) format, ...{
//    static aslclient client;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        client = asl_open("GAP-verbose", "GAP-LOG", ASL_OPT_STDERR);
//    });
//
//    va_list args;
//    va_start(args, format);
//    NSString* msg = [[NSString alloc] initWithFormat:format arguments:args];
//    asl_log(client, NULL, ASL_LEVEL_DEBUG, "%s", [msg UTF8String]);
//    va_end(args);
//}

@end
