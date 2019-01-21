#import "RPSJSONObject.h"

@implementation RPSJSONObject

+(nonnull instancetype) jsonWithRawDictionary:(nonnull NSDictionary*) rawDict {
    RPSJSONObject* json = [RPSJSONObject new];
    json->_rawDict = rawDict;
    return json;
}

-(nullable RPSJSONObject*) getJson:(nonnull NSString*) key {
    NSObject* value = [self.rawDict valueForKeyPath:key];
    if (value && [value isKindOfClass:[NSDictionary class]]) {
        return [RPSJSONObject jsonWithRawDictionary:(NSDictionary*)value];
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

-(NSString*) getString:(NSString *) key {
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
