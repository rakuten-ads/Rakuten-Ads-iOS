#import "GAPJSONObject.h"

@implementation GAPJSONObject

+(nonnull instancetype) jsonWithRawDictionary:(nonnull NSDictionary*) rawDict {
    GAPJSONObject* json = [GAPJSONObject new];
    json->_rawDict = rawDict;
    return json;
}

-(nullable GAPJSONObject*) getJson:(nonnull NSString*) key {
    NSObject* value = [self.rawDict valueForKeyPath:key];
    if (value && [value isKindOfClass:[NSDictionary class]]) {
        return [GAPJSONObject jsonWithRawDictionary:(NSDictionary*)value];
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
