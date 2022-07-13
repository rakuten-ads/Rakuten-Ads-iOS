#import "RUNAJSONObject.h"

NS_ASSUME_NONNULL_BEGIN

@implementation RUNAJSONObject

+(instancetype) jsonWithRawDictionary:(NSDictionary*) rawDict {
    RUNAJSONObject* json = [RUNAJSONObject new];
    json->_rawDict = rawDict;
    return json;
}

-(nullable RUNAJSONObject*) getJson:(NSString*) key {
    NSObject* value = [self.rawDict valueForKeyPath:key];
    if (value && [value isKindOfClass:[NSDictionary class]]) {
        return [RUNAJSONObject jsonWithRawDictionary:(NSDictionary*)value];
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
    return NO;
}

@end

NS_ASSUME_NONNULL_END
