#import "GAPAdNative.h"
#import <GAPCore/GAPValid.h>
#import "GAPAdRequest.h"
#import "GAPDefines.h"

typedef void (^GAPAdNativeHandler)(NSDictionary<NSString*, NSObject*>* _Nullable adInfo);

@interface GAPAdNative() <GAPAdRequestDelegate>

@property(nonatomic, copy, nonnull) NSString* adSpotId;
@property(nonatomic, copy, nonnull) GAPAdNativeHandler handler;

@end

@implementation GAPAdNative

-(void) requestWithAdSpotId:(NSString *)adSpotId completionHandler:(GAPAdNativeHandler)handler {
    dispatch_async(GAPDefines.sharedQueue, ^{
        if ([GAPValid isNotEmptyString:adSpotId]) {
            self.adSpotId = adSpotId;
        } else {
            NSLog(@"adSpotId is required!");
        }
        
        if (handler) {
            self.handler = handler;
        } else {
            NSLog(@"GAPAdNativeHandler is required to process request result!");
        }
        
        GAPAdRequest* request = [[GAPAdRequest alloc]initWithAdSpotId:self.adSpotId];
        request.delegate = self;
        [request resume];
    });
}

- (void)triggerFailure {
    dispatch_async(dispatch_get_main_queue(), ^{
        @try {
            self.handler(nil);
        } @catch (NSException* exception) {
            VERBOSE_LOG(@"failed when GAPAdNativeHandler callback: %@", exception);
        }
    });
}

- (void)adRequestOnFailure {
    GAPLog(@"ad native request failure");
    [self triggerFailure];
}

- (void)adRequestOnSuccess:(nonnull GAPAdSpotInfo *)adSpotInfo {
    GAPLog(@"ad native request success");
    dispatch_async(dispatch_get_main_queue(), ^{
        @try {
            NSDictionary* json = @{
                                   @"ad_spot_id": adSpotInfo.adSpotId,
                                   @"width": @(adSpotInfo.width),
                                   @"height":@(adSpotInfo.height),
                                   @"html": adSpotInfo.html,
                                   };
            GAPLog(@"call ad native completion handler");
            self.handler(json);
        } @catch (NSException* exception) {
            VERBOSE_LOG(@"failed when GAPAdNativeHandler callback: %@", exception);
        }
    });
}

@end
