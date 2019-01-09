#import "GAPIdfa.h"
#import <AdSupport/AdSupport.h>

@implementation GAPIdfa {
    NSString* _idfa;
    BOOL _idte;
    NSString* _encryptedIdfa;
}

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
        GAPLog(@"idfa return directly: %@", self->_idfa);
        return self->_idfa;
    }
    
    GAPLog(@"try to get idfa again");
    
    [NSThread sleepForTimeInterval:0.5];
    [self getValues];
    
    GAPLog(@"finally get idfa: %@", self->_idfa);
    return self->_idfa;
}

-(BOOL) isTrackingEnabled {
    
    if (self->_idfa) {
        GAPLog(@"idfa enabled return directly: %@", self->_idte ? @"YES" : @"NO");
        return self->_idte;
    }
    
    GAPLog(@"try to get idte again");
    
    [NSThread sleepForTimeInterval:0.5];
    [self getValues];
    
    GAPLog(@"finally get idte: %@", self->_idfa ? @"YES" : @"NO");
    return self->_idte;
}

@end
