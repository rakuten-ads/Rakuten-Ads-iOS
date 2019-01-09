@interface GAPLogger : NSObject

+(void) warning:(NSString*) format, ...;
+(void) info:(NSString*) format, ...;
+(void) debug:(NSString*) format, ...;

@end
