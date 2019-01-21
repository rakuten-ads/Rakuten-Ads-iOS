@interface RPSVerboseLogger : NSObject

#define VERBOSE_LOG(...) RPSLog(__VA_ARGS__); [RPSVerboseLogger verboseLog : __VA_ARGS__];

+(void) verboseLog:(nonnull NSString*) format, ...;

+(void) setVerboseMode:(BOOL) enableVerboseMode;

@end
