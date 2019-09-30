#import "RPSJSONObject.h"

NS_ASSUME_NONNULL_BEGIN

@implementation RPSJSONObject

+(instancetype) jsonWithRawDictionary:(NSDictionary*) rawDict {
    RPSJSONObject* json = [RPSJSONObject new];
    json->_rawDict = rawDict;
    return json;
}

-(nullable RPSJSONObject*) getJson:(NSString*) key {
    NSObject* value = [self.rawDict valueForKeyPath:key];
    if (value && [value isKindOfClass:[NSDictionary class]]) {
        return [RPSJSONObject jsonWithRawDictionary:(NSDictionary*)value];
    }
    return nil;
}

-(nullable NSArray *)getArray:(NSString *)key {
    NSObject* value = [self.rawDict valueForKeyPath:key];
    if (value && [value isKindOfClass:[NSArray class]]) {
        return (NSArray*)value;
    }
    return nil;
}

-(nullable NSNumber*) getNumber:(NSString *) key {
    NSObject* value = [self.rawDict valueForKeyPath:key];
    if (value && [value isKindOfClass:[NSNumber class]]) {
        return (NSNumber*)value;
    }
    return nil;
}

-(nullable NSString*) getString:(NSString *) key {
    NSObject* value = [self.rawDict valueForKeyPath:key];
    if (value && [value isKindOfClass:[NSString class]]) {
        return (NSString*)value;
    }
    return nil;
}

-(BOOL) getBoolean:(NSString *) key {
    NSObject* value = [self.rawDict valueForKeyPath:key];
    if (value && [value isKindOfClass:[NSNumber class]]) {
        return [(NSNumber*)value boolValue] == YES;
    }
    return false;
}

@end

NS_ASSUME_NONNULL_END
