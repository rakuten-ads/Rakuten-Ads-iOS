#import <Foundation/Foundation.h>

@interface GAPJSONObject : NSObject

@property(nonatomic, readonly, nonnull)  NSDictionary* rawDict;

+(nonnull instancetype) jsonWithRawDictionary:(nonnull NSDictionary*) rawDict;

-(nullable GAPJSONObject*) getJson:(nonnull NSString*) key;
-(nullable NSNumber*) getNumber:(nonnull NSString*) key;
-(nullable NSString*) getString:(nonnull NSString*) key;
-(BOOL) getBoolean:(nonnull NSString*) key;

@end
