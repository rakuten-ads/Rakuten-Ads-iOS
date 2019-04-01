#import "RPSHttpTask.h"
#import "RPSURLCoder.h"
#import "RPSValid.h"

@interface RPSHttpTask ()

@property (nonatomic, strong, nullable) dispatch_semaphore_t semaphore;
@property (nonatomic, strong, nonnull) NSString* underlyingUrl;

@end

@implementation RPSHttpTask

-(void) resume {
    @try {
        if (!_httpTaskDelegate) {
            @throw [NSException exceptionWithName:@"HttpSessionException" reason:@"required httpSessionDelegate" userInfo:nil];
        }

        if (!_httpSession) {
            @throw [NSException exceptionWithName:@"HttpSessionException" reason:@"init httpSession first!" userInfo:nil];
        }

        if ([_httpTaskDelegate respondsToSelector:@selector(shouldCancel)] && [_httpTaskDelegate shouldCancel]) {
            RPSLog(@"http session canceled");
            @throw [NSException exceptionWithName:@"HttpSessionException" reason:@"http resume cannceled" userInfo:nil];
        }

        // compose url
        if (!self.underlyingUrl) {
            RPSLog(@"required URL");
            @throw [NSException exceptionWithName:@"HttpSessionException" reason:@"url cannot be nil" userInfo:nil];
        }

        NSURL* url = [NSURL URLWithString:self.underlyingUrl];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];

        // request configuration
        [self configHttpRequest:request];

        // set POST data if neccesary
        [self setPostBody:request];

        // define completionHandler if concern the response
        void (^completionHandler)(NSData*, NSURLResponse*, NSError*) = nil;
        if ([self->_httpTaskDelegate respondsToSelector:@selector(onResponse:withData:)]
            || [self->_httpTaskDelegate respondsToSelector:@selector(onJsonResponse:withData:)]) {
            completionHandler = [self getCompletionhandler];
        } else {
            RPSLog(@"skip response as no concern");
        }

        // sending http transmission
        RPSLog(@"send request: %@", request);
        [[_httpSession dataTaskWithRequest:request completionHandler:completionHandler] resume];
    }
    @catch (NSException *exception) {
        RPSLog(@"httpsession resume failed: %@", exception);
        @throw exception;
    }
}

-(void) syncResume:(dispatch_time_t) timeout {
    RPSLog(@"http session syncResume with timeout at: %llu", timeout);
    self.semaphore = dispatch_semaphore_create(0);

    [self resume];

    dispatch_semaphore_wait(_semaphore, timeout);
}

-(NSString *) underlyingUrl {
    if (!_underlyingUrl) {
        _underlyingUrl = [self composeURLWithQueryString];
        RPSLog(@"override getUnderlyingUrl %@", _underlyingUrl);
    }
    return _underlyingUrl;
}

-(NSString*) composeURLWithQueryString {
    NSMutableString* urlStr = [NSMutableString stringWithString:[_httpTaskDelegate getUrl]];
    if ([_httpTaskDelegate respondsToSelector:@selector(getQueryParameters)]) {
        NSDictionary* paramDict = [_httpTaskDelegate getQueryParameters];
        if (paramDict) {
            // add query parameters
            if (![urlStr containsString:@"?"]) {
                [urlStr appendString:@"?"];
            }
            for (NSString* key in paramDict) {
                NSString* encodeKey = [RPSURLCoder encodeURL:key];

                NSString* encodeValue = @"";
                id value = [paramDict objectForKey:key];
                if (value && [value isKindOfClass:[NSString class]]) {
                    encodeValue = [RPSURLCoder encodeURL:value];
                } else {
                    encodeValue = value;
                }

                [urlStr appendFormat:@"%@=%@&", encodeKey, encodeValue];
            }
            [urlStr deleteCharactersInRange:NSMakeRange(urlStr.length - 1, 1)];
        }
    }
    return [NSString stringWithString:urlStr];
}

-(void) configHttpRequest:(NSMutableURLRequest*) request {
    if (_httpTaskDelegate && [_httpTaskDelegate respondsToSelector:@selector(postJsonBody)]) {
        RPSLog(@"set Json header");
        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    }

    if ([_httpTaskDelegate respondsToSelector:@selector(processConfig:)]) {
        [_httpTaskDelegate processConfig:request];
    }
}

-(void) setPostBody:(NSMutableURLRequest*) request {
    if ([_httpTaskDelegate respondsToSelector:@selector(postBody)]) {
        request.HTTPMethod = @"POST";
        request.HTTPBody = [_httpTaskDelegate postBody];
    } else if (_httpTaskDelegate && [_httpTaskDelegate respondsToSelector:@selector(postJsonBody)]) {
        NSDictionary* jsonBody = [(id<RPSJsonHttpSessionDelegate>)_httpTaskDelegate postJsonBody];
        RPSLog(@"jsonBody: %@", jsonBody);
        if (jsonBody) {
            request.HTTPMethod = @"POST";
            NSError* jsonSerialErr;
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonBody options:0 error:nil];
            if (jsonData) {
                RPSLog(@"jsonBody string: %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
                request.HTTPBody = jsonData;
            } else {
                if (jsonSerialErr) {
                    @throw [NSException exceptionWithName:@"HttpSessionException" reason:@"illegal json body" userInfo:nil];
                }
            }
        }
    }
}

-(void (^)(NSData*, NSURLResponse*, NSError*)) getCompletionhandler {
    return ^void (NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable httpErr) {
        RPSLog(@"receive response:%@ \n\t data: %@",
               response,
               data != nil ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : @"nil");

        @try {
            NSHTTPURLResponse* rep = (NSHTTPURLResponse*)response;
            if ([self->_httpTaskDelegate respondsToSelector:@selector(onResponse:withData:)]) {
                // take prior response to HttpSesionDelegate
                [self->_httpTaskDelegate onResponse:rep withData:data];
            } else if ([self->_httpTaskDelegate respondsToSelector:@selector(onJsonResponse:withData:)]) {
                // otherwise the JsonHttpSessionDelegate
                NSError* jsonErr = nil;
                NSDictionary* json = nil;
                if (data) {
                    json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonErr];
                    RPSLog(@"JSON format result: %@", jsonErr ?: @"OK");
                } else {
                    RPSLog(@"desired JSON response data while nil");
                }
                [(id<RPSJsonHttpSessionDelegate>)self->_httpTaskDelegate onJsonResponse:rep withData:json];
            }

            RPSLog(@"http error: %@", httpErr ?: @"None");
        }
        @catch (NSException *exception) {
            RPSLog(@"http session completion handler exception %@", exception);
        }
        @finally {
            if (self->_semaphore) {
                RPSLog(@"dispatch_semaphore_signal for sync resume");
                dispatch_semaphore_signal(self->_semaphore);
            }
        }
    };
}

@end
