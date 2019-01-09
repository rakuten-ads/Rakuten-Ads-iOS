#import "GAPHttpSession.h"
#import "GAPURLCoder.h"
#import "GAPValid.h"

@interface GAPHttpSession ()

@property dispatch_semaphore_t semaphore;

@end

@implementation GAPHttpSession {
    NSString* _underlyingUrl;
}

-(void) resume {
    @try {
        if (!_httpSessionDelegate) {
            @throw [NSException exceptionWithName:@"HttpSessionException" reason:@"required httpSessionDelegate" userInfo:nil];
        }

        if (!_httpSession) {
            @throw [NSException exceptionWithName:@"HttpSessionException" reason:@"init httpSession first!" userInfo:nil];
        }

        if ([_httpSessionDelegate respondsToSelector:@selector(shouldCancel)] && [_httpSessionDelegate shouldCancel]) {
            GAPLog(@"http session canceled");
            @throw [NSException exceptionWithName:@"HttpSessionException" reason:@"http resume cannceled" userInfo:nil];
        }

        // compose url
        if (!self.underlyingUrl) {
            GAPLog(@"required URL");
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
        if ([self->_httpSessionDelegate respondsToSelector:@selector(onResponse:withData:)]
            || [self->_httpSessionDelegate respondsToSelector:@selector(onJsonResponse:withData:)]) {
            completionHandler = [self getCompletionhandler];
        } else {
            GAPLog(@"skip response as no concern");
        }

        // sending http transmission
        GAPLog(@"send request: %@", request);
        [[_httpSession dataTaskWithRequest:request completionHandler:completionHandler] resume];
    }
    @catch (NSException *exception) {
        GAPLog(@"httpsession resume failed: %@", exception);
        @throw exception;
    }
    @finally {
        // release http session
        if (!self.shouldKeepHttpSession) {
            [_httpSession finishTasksAndInvalidate];
        }
        GAPLog(@"do%@ keep httpsession", self.shouldKeepHttpSession ? @"" : @" not");
    }
}

-(void) syncResume:(dispatch_time_t) timeout {
    GAPLog(@"http session syncResume with timeout at: %llu", timeout);
    self.semaphore = dispatch_semaphore_create(0);

    [self resume];

    dispatch_semaphore_wait(_semaphore, timeout);
}

-(NSString *) underlyingUrl {
    if (!_underlyingUrl) {
        _underlyingUrl = [self composeURLWithQueryString];
        GAPLog(@"override getUnderlyingUrl %@", _underlyingUrl);
    }
    return _underlyingUrl;
}

-(NSString*) composeURLWithQueryString {
    NSMutableString* urlStr = [NSMutableString stringWithString:[_httpSessionDelegate getUrl]];
    if ([_httpSessionDelegate respondsToSelector:@selector(getQueryParameters)]) {
        NSDictionary* paramDict = [_httpSessionDelegate getQueryParameters];
        if (paramDict) {
            // add query parameters
            if (![urlStr containsString:@"?"]) {
                [urlStr appendString:@"?"];
            }
            for (NSString* key in paramDict) {
                NSString* encodeKey = [GAPURLCoder encodeURL:key];

                NSString* encodeValue = @"";
                id value = [paramDict objectForKey:key];
                if (value && [value isKindOfClass:[NSString class]]) {
                    encodeValue = [GAPURLCoder encodeURL:value];
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
    if (_httpSessionDelegate && [_httpSessionDelegate respondsToSelector:@selector(postJsonBody)]) {
        GAPLog(@"set Json header");
        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    }

    if ([_httpSessionDelegate respondsToSelector:@selector(appendConfig:)]) {
        [_httpSessionDelegate appendConfig:request];
    }
}

-(void) setPostBody:(NSMutableURLRequest*) request {
    if ([_httpSessionDelegate respondsToSelector:@selector(postBody)]) {
        request.HTTPMethod = @"POST";
        request.HTTPBody = [_httpSessionDelegate postBody];
    } else if (_httpSessionDelegate && [_httpSessionDelegate respondsToSelector:@selector(postJsonBody)]) {
        NSDictionary* jsonBody = [(id<GAPJsonHttpSessionDelegate>)_httpSessionDelegate postJsonBody];
        GAPLog(@"jsonBody: %@", jsonBody);
        if (jsonBody) {
            request.HTTPMethod = @"POST";
            NSError* jsonSerialErr;
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonBody options:0 error:nil];
            if (jsonData) {
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
        GAPLog(@"receive response:%@ \n\t data: %@",
               response,
               data != nil ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : @"nil");

        @try {
            NSHTTPURLResponse* rep = (NSHTTPURLResponse*)response;
            if ([self->_httpSessionDelegate respondsToSelector:@selector(onResponse:withData:)]) {
                // take prior response to HttpSesionDelegate
                [self->_httpSessionDelegate onResponse:rep withData:data];
            } else if ([self->_httpSessionDelegate respondsToSelector:@selector(onJsonResponse:withData:)]) {
                // otherwise the JsonHttpSessionDelegate
                NSError* jsonErr = nil;
                NSDictionary* json = nil;
                if (data) {
                    json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonErr];
                    GAPLog(@"JSON format result: %@", jsonErr ?: @"OK");
                } else {
                    GAPLog(@"desired JSON response data while nil");
                }
                [(id<GAPJsonHttpSessionDelegate>)self->_httpSessionDelegate onJsonResponse:rep withData:json];
            }

            GAPLog(@"http session result :%@", httpErr ?: @"OK");
        }
        @catch (NSException *exception) {
            GAPLog(@"http session completion handler exception %@", exception);
        }
        @finally {
            if (self->_semaphore) {
                GAPLog(@"dispatch_semaphore_signal for sync resume");
                dispatch_semaphore_signal(self->_semaphore);
            }
        }
    };
}

@end
