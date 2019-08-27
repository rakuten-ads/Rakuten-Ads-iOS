#import "RPSIdfa.h"
#import <AdSupport/AdSupport.h>

@implementation RPSIdfa

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
    self->_idte = [idfaManager isAdvertisingTrackingEnabled];
}

-(NSString*) idfa {
    
    if (self->_idfa) {
        RPSDebug("idfa return directly: %@", self->_idfa);
        return self->_idfa;
    }
    
    RPSDebug("try to get idfa again");
    
    [NSThread sleepForTimeInterval:0.5];
    [self getValues];
    
    RPSDebug("finally get idfa: %@", self->_idfa);
    return self->_idfa;
}

-(BOOL) isTrackingEnabled {
    
    if (self->_idfa) {
        RPSDebug("idfa enabled return directly: %@", self->_idte ? @"YES" : @"NO");
        return self->_idte;
    }
    
    RPSDebug("try to get idte again");
    
    [NSThread sleepForTimeInterval:0.5];
    [self getValues];
    
    RPSDebug("finally get idte: %@", self->_idfa ? @"YES" : @"NO");
    return self->_idte;
}

@end
