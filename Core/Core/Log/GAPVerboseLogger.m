#import "GAPVerboseLogger.h"
#import "GAPLogger.h"

static BOOL isVerboseMode;

@implementation GAPVerboseLogger

+(void) verboseLog:(NSString*) format, ...{
    if (isVerboseMode) {
        NSString* logFormat = [@"[GAP] " stringByAppendingString:format];

        va_list args;
        va_start(args, format);
        NSString* msg = [[NSString alloc] initWithFormat:logFormat arguments:args];
        va_end(args);

        [GAPLogger debug:msg];
    }
}

+(void) setVerboseMode:(BOOL) enableVerboseMode {
    isVerboseMode = enableVerboseMode;
}

@end
