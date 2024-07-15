//
//  GADMediationAdapterRunaUtil.m
//  MediationAdapterObj
//
//  Created by Wu, Wei | David | GATD on 2024/06/05.
//

#import "GADMediationAdapterRunaUtil.h"


NSString* kRUNAMediationAdapterAdmobDomain = @"com.rakuten.runa.mediation.admob";

@implementation GADMediationAdapterRunaUtil

+(NSError *)domainError:(RUNABannerViewError)errorCode withDescription:(NSString *)description {
    NSDictionary* userInfo = @{
        NSLocalizedDescriptionKey: description,
        NSLocalizedFailureReasonErrorKey: description
    };
    return [NSError errorWithDomain:kRUNAMediationAdapterAdmobDomain code:errorCode userInfo:userInfo];
}
@end
