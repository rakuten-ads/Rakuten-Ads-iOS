#import "RUNAIdfa.h"
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/ATTrackingManager.h>

@implementation RUNAIdfa

@synthesize idfa = _idfa;
@synthesize trackingEnabled = _idte;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self getValues];
    }
    return self;
}

-(void) getValues {
    ASIdentifierManager* idfaManager = [ASIdentifierManager sharedManager];
    
    self->_idfa = [[idfaManager advertisingIdentifier] UUIDString];

    if (@available(iOS 14, *)) {
        BOOL shouldGetIdfa = [ATTrackingManager trackingAuthorizationStatus] == ATTrackingManagerAuthorizationStatusAuthorized;
        self->_idte = shouldGetIdfa;
    } else {
        self->_idte = [idfaManager isAdvertisingTrackingEnabled];
    }
}

-(NSString*) idfa {
    
    if (self->_idfa) {
        RUNADebug("idfa return directly: %@", self->_idfa);
        return self->_idfa;
    }

    RUNADebug("try to get idfa again");

    [NSThread sleepForTimeInterval:0.5];
    [self getValues];

    RUNADebug("finally get idfa: %@", self->_idfa);
    return self->_idfa;
}

-(BOOL) isTrackingEnabled {
    
    if (self->_idfa) {
        RUNADebug("idfa enabled return directly: %@", self->_idte ? @"YES" : @"NO");
        return self->_idte;
    }

    RUNADebug("try to get idte again");

    [NSThread sleepForTimeInterval:0.5];
    [self getValues];

    RUNADebug("finally get idte: %@", self->_idfa ? @"YES" : @"NO");
    return self->_idte;
}

@end
