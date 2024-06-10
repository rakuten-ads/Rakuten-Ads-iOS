//
//  RUNAMediationAdapterAdmob.m
//  MediationAdapterObj
//
//  Created by Wu, Wei | David | GATD on 2024/06/05.
//

#import "RUNAMediationAdapterAdmob.h"
#import <RUNABanner/RUNABanner.h>
#import "RUNAMediationAdapterAdmobBanner.h"
#import "RUNAMediationAdapterAdmobExtras.h"

@interface RUNAMediationAdapterAdmob()

@property RUNAMediationAdapterAdmobBanner* bannerLoader;

@end

@implementation RUNAMediationAdapterAdmob

+ (nullable Class<GADAdNetworkExtras>)networkExtrasClass {
    return RUNAMediationAdapterAdmobExtras.class;
}

+ (void)setUpWithConfiguration:(GADMediationServerConfiguration *)configuration 
             completionHandler:(GADMediationAdapterSetUpCompletionBlock)completionHandler {
    
    completionHandler(nil);
}

#pragma mark - banner

- (void)loadBannerForAdConfiguration:(GADMediationBannerAdConfiguration *)adConfiguration completionHandler:(GADMediationBannerLoadCompletionHandler)completionHandler {
    self.bannerLoader = [RUNAMediationAdapterAdmobBanner new];
    [self.bannerLoader loadBannerForAdConfiguration:adConfiguration completionHandler:completionHandler];
}

#pragma mark - version info

+ (GADVersionNumber)adSDKVersion {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if ([RUNABannerView respondsToSelector:@selector(RUNASDKVersionString)]) {
        NSString* runaSDKVersion = [RUNABannerView performSelector:@selector(RUNASDKVersionString)];
        return [RUNAMediationAdapterAdmob parseVersionWithString:runaSDKVersion];
    } else {
        struct GADVersionNumber empty = {};
        return empty;
    }
#pragma clang diagnostic pop
}

+ (GADVersionNumber)adapterVersion { 
    return [RUNAMediationAdapterAdmob parseVersionWithString:[RUNAMediationAdapterAdmob versionString]];
}


+(NSString*) versionString {
    return @OS_STRINGIFY(RUNA_SDK_VERSION);
}

+ (GADVersionNumber) parseVersionWithString: (NSString*) verStr {
    struct GADVersionNumber ver = {};
    NSArray* verArray = [verStr componentsSeparatedByString:@"."];
    if (verArray.count > 2) {
        ver.majorVersion = [verArray[0] intValue];
        ver.minorVersion = [verArray[1] intValue];
        ver.patchVersion = [verArray[2] intValue];
    }
    return ver;
}



@end
