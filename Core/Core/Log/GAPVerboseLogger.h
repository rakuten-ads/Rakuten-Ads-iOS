@interface GAPVerboseLogger : NSObject

#define VERBOSE_LOG(...) GAPLog(__VA_ARGS__); [GAPVerboseLogger verboseLog : __VA_ARGS__];

+(void) verboseLog:(nonnull NSString*) format, ...;

+(void) setVerboseMode:(BOOL) enableVerboseMode;

@end
