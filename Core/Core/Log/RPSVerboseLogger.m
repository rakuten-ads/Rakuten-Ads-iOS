#import "RPSVerboseLogger.h"
#import "RPSLogger.h"

static BOOL isVerboseMode;

@implementation RPSVerboseLogger

+(void) verboseLog:(NSString*) format, ...{
    if (isVerboseMode) {
        NSString* logFormat = [@"[RPS] " stringByAppendingString:format];

        va_list args;
        va_start(args, format);
        NSString* msg = [[NSString alloc] initWithFormat:logFormat arguments:args];
        va_end(args);

        [RPSLogger debug:msg];
    }
}

+(void) setVerboseMode:(BOOL) enableVerboseMode {
    isVerboseMode = enableVerboseMode;
}

@end
