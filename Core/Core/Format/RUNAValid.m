#import "RUNAValid.h"

@implementation RUNAValid

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
