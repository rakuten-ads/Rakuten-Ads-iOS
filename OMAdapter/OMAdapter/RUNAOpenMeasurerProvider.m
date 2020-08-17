//
//  RUNAOpenMeasurerProvider.m
//  OMAdapter
//
//  Created by Wu, Wei b on R 2/07/19.
//  Copyright © Reiwa 2 RUNA. All rights reserved.
//

#import "RUNAOpenMeasurerProvider.h"
#import <RUNACore/RUNAURLString.h>

@implementation RUNAOpenMeasurerProvider

- (instancetype)initWithURL:(NSString *)url
{
    self = [super init];
    if (self) {
        self->_url = url;
        [self cacheURLContent:url];
    }
    return self;
}

NSTimeInterval RUNA_API_TIMEOUT_INTERVAL = 3;

-(void) cacheURLContent: (NSString*) url {
    NSData* urlStringInBase64 = [[url dataUsingEncoding:NSUTF8StringEncoding] base64EncodedDataWithOptions:0];
    NSString* cacheFileName = [[NSString alloc] initWithData:urlStringInBase64 encoding:NSUTF8StringEncoding];
    self->_cacheFile = [[RUNACacheFile alloc] initWithName:cacheFileName];
    if (self.cacheFile.isExist) {
        return;
    }
    
    RUNAURLStringRequest* request = [RUNAURLStringRequest new];
    request.httpTaskDelegate = self;
    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RUNA_API_TIMEOUT_INTERVAL * NSEC_PER_SEC));
    [request syncResume:timeout];
    
}

-(NSString *)getUrl {
    return self.url;
}

-(void)onResponse:(NSHTTPURLResponse *)response withData:(NSData *)data error:(NSError *)error {
    if (!error) {
        if (!_cacheFile.isExist && data.length > 0) {
            [_cacheFile writeData:data];
        }
    }
}

@end
