#import "RPSValid.h"

@implementation RPSValid

+(BOOL) isEmptyString:(NSString*) str {
    return [self isNotEmptyString:str] == NO;
}

+(BOOL) isNotEmptyString:(NSString*) str {
    if (str) {
        return [str length] > 0;
    }
    return NO;
}

@end
