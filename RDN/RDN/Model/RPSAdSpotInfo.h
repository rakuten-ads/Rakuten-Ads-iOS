@import UIKit;

@interface RPSAdSpotInfo : NSObject

@property(nonatomic, readonly, nonnull) NSString* adSpotId;
@property(nonatomic, readonly, nonnull) NSString* html;
@property(nonatomic, readonly) CGFloat width; // in unit density-independency-pixel
@property(nonatomic, readonly) CGFloat height; // in unit density-independency-pixel

+ (instancetype) adSpotInfoFrom:(nonnull NSDictionary*)json;
@end
