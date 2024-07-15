//
//  GADMediationAdapterRunaUtil.h
//  MediationAdapterObj
//
//  Created by Wu, Wei | David | GATD on 2024/06/05.
//

#import <Foundation/Foundation.h>
#import <RUNABanner/RUNABanner.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString* kRUNAMediationAdapterAdmobDomain;

@interface GADMediationAdapterRunaUtil : NSObject

+(NSError*) domainError:(RUNABannerViewError) errorCode withDescription:(NSString*) description;

@end

NS_ASSUME_NONNULL_END
