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
        RPSLog(@"idfa return directly: %@", self->_idfa);
        return self->_idfa;
    }
    
    RPSLog(@"try to get idfa again");
    
    [NSThread sleepForTimeInterval:0.5];
    [self getValues];
    
    RPSLog(@"finally get idfa: %@", self->_idfa);
    return self->_idfa;
}

-(BOOL) isTrackingEnabled {
    
    if (self->_idfa) {
        RPSLog(@"idfa enabled return directly: %@", self->_idte ? @"YES" : @"NO");
        return self->_idte;
    }
    
    RPSLog(@"try to get idte again");
    
    [NSThread sleepForTimeInterval:0.5];
    [self getValues];
    
    RPSLog(@"finally get idte: %@", self->_idfa ? @"YES" : @"NO");
    return self->_idte;
}

@end
