#import "RUNAIdfa.h"
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/ATTrackingManager.h>

@implementation RUNAIdfa

-(NSString*) idfa {
    ASIdentifierManager* idfaManager = [ASIdentifierManager sharedManager];

    NSString* idfa = [[[idfaManager advertisingIdentifier] UUIDString] copy];

    RUNADebug("get idfa: %@", idfa);
    return idfa;
}

-(BOOL) isTrackingEnabled {
    ASIdentifierManager* idfaManager = [ASIdentifierManager sharedManager];
    BOOL idte = NO;
    if (@available(iOS 14, *)) {
        BOOL shouldGetIdfa = [ATTrackingManager trackingAuthorizationStatus] == ATTrackingManagerAuthorizationStatusAuthorized;
        idte = shouldGetIdfa || [idfaManager isAdvertisingTrackingEnabled];
    } else {
        idte = [idfaManager isAdvertisingTrackingEnabled];
    }

    RUNADebug("get idte: %@", idte ? @"YES" : @"NO");
    return idte;
}

@end
