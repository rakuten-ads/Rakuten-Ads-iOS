#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RUNAJSONObject : NSObject

@property(nonatomic, readonly)  NSDictionary* rawDict;

+(instancetype) jsonWithRawDictionary:(NSDictionary*) rawDict;

-(nullable RUNAJSONObject*) getJson:(NSString*) key;
-(nullable NSArray*) getArray:(NSString*) key;
-(nullable NSNumber*) getNumber:(NSString*) key;
-(nullable NSString*) getString:(NSString*) key;
-(BOOL) getBoolean:(NSString*) key;

@end

NS_ASSUME_NONNULL_END
