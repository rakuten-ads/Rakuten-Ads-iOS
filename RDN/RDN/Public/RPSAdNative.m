#import "RPSAdNative.h"
#import <RPSCore/RPSValid.h>
#import "RPSAdRequest.h"
#import "RPSDefines.h"

typedef void (^RPSAdNativeHandler)(NSDictionary<NSString*, NSObject*>* _Nullable adInfo);

@interface RPSAdNative() <RPSAdRequestDelegate>

@property(nonatomic, copy, nonnull) NSString* adSpotId;
@property(nonatomic, copy, nonnull) RPSAdNativeHandler handler;

@end

@implementation RPSAdNative

-(void) requestWithAdSpotId:(NSString *)adSpotId completionHandler:(RPSAdNativeHandler)handler {
    dispatch_async(RPSDefines.sharedQueue, ^{
        if ([RPSValid isNotEmptyString:adSpotId]) {
            self.adSpotId = adSpotId;
        } else {
            NSLog(@"adSpotId is required!");
        }
        
        if (handler) {
            self.handler = handler;
        } else {
            NSLog(@"RPSAdNativeHandler is required to process request result!");
        }
        
        RPSAdRequest* request = [[RPSAdRequest alloc]initWithAdSpotId:self.adSpotId];
        request.delegate = self;
        [request resume];
    });
}

- (void)triggerFailure {
    dispatch_async(dispatch_get_main_queue(), ^{
        @try {
            self.handler(nil);
        } @catch (NSException* exception) {
            VERBOSE_LOG(@"failed when RPSAdNativeHandler callback: %@", exception);
        }
    });
}

- (void)adRequestOnFailure {
    RPSLog(@"ad native request failure");
    [self triggerFailure];
}

- (void)adRequestOnSuccess:(nonnull RPSAdSpotInfo *)adSpotInfo {
    RPSLog(@"ad native request success");
    dispatch_async(dispatch_get_main_queue(), ^{
        @try {
            NSDictionary* json = @{
                                   @"ad_spot_id": adSpotInfo.adSpotId,
                                   @"width": @(adSpotInfo.width),
                                   @"height":@(adSpotInfo.height),
                                   @"html": adSpotInfo.html,
                                   };
            RPSLog(@"call ad native completion handler");
            self.handler(json);
        } @catch (NSException* exception) {
            VERBOSE_LOG(@"failed when RPSAdNativeHandler callback: %@", exception);
        }
    });
}

@end
