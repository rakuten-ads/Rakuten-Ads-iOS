@import UIKit;

@interface RPSDevice : NSObject

@property(nonatomic, readonly, nonnull) NSString* osVersion;
@property(nonatomic, readonly, nonnull) NSString* model;
@property(nonatomic, readonly, nonnull) NSString* buildName;
@property(nonatomic, readonly, nonnull) NSString* language;

// TODO isWIFINetwork

@end
