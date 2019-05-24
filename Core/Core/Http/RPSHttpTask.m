#import "RPSHttpTask.h"
#import "RPSURLCoder.h"
#import "RPSValid.h"

@interface RPSHttpTask ()

@property (nonatomic, strong, nullable) dispatch_semaphore_t semaphore;
@property (nonatomic, strong, nonnull) NSURL* underlyingUrl;

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
            RPSDebug("http session canceled");
            @throw [NSException exceptionWithName:@"HttpSessionException" reason:@"http resume cannceled" userInfo:nil];
        }

        // compose url
        if (!self.underlyingUrl) {
            RPSDebug("required URL");
            @throw [NSException exceptionWithName:@"HttpSessionException" reason:@"url cannot be nil" userInfo:nil];
        }

        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:self.underlyingUrl];

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
            RPSDebug("skip response as no concern");
        }

        // sending http transmission
        RPSDebug("send request: %@", request);
        [[_httpSession dataTaskWithRequest:request completionHandler:completionHandler] resume];
    }
    @catch (NSException *exception) {
        RPSDebug("httpsession resume failed: %@", exception);
        @throw exception;
    }
}

-(void) syncResume:(dispatch_time_t) timeout {
    RPSDebug("http session syncResume with timeout at: %llu", timeout);
    self.semaphore = dispatch_semaphore_create(0);

    [self resume];

    dispatch_semaphore_wait(_semaphore, timeout);
}

-(NSURL*) underlyingUrl {
    if (!_underlyingUrl) {
        _underlyingUrl = [self composeURL];
        RPSDebug("override getUnderlyingUrl %@", _underlyingUrl);
    }
    return _underlyingUrl;
}

-(NSURL*) composeURL {
    NSURLComponents* comps = [[NSURLComponents alloc] initWithString:[_httpTaskDelegate getUrl]];
    if ([_httpTaskDelegate respondsToSelector:@selector(getQueryParameters)]) {
        NSMutableArray<NSURLQueryItem*>* queryItems = [NSMutableArray array];
        [[_httpTaskDelegate getQueryParameters] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:(NSString*)obj]];
        }];
        comps.queryItems = queryItems;
    }
    return comps.URL;
}

-(void) configHttpRequest:(NSMutableURLRequest*) request {
    if (_httpTaskDelegate && [_httpTaskDelegate respondsToSelector:@selector(postJsonBody)]) {
        RPSDebug("set Json header");
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
        RPSDebug("jsonBody: %@", jsonBody);
        if (jsonBody) {
            request.HTTPMethod = @"POST";
            NSError* jsonSerialErr;
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonBody options:0 error:nil];
            if (jsonData) {
                RPSDebug("jsonBody string: %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
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
        RPSDebug("receive response:%@ \n\t data: %@",
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
                    RPSDebug("JSON format result: %@", jsonErr ?: @"OK");
                } else {
                    RPSDebug("desired JSON response data while nil");
                }
                [(id<RPSJsonHttpSessionDelegate>)self->_httpTaskDelegate onJsonResponse:rep withData:json];
            }

            RPSDebug("http error: %@", httpErr ?: @"None");
        }
        @catch (NSException *exception) {
            RPSDebug("http session completion handler exception %@", exception);
        }
        @finally {
            if (self->_semaphore) {
                RPSDebug("dispatch_semaphore_signal for sync resume");
                dispatch_semaphore_signal(self->_semaphore);
            }
        }
    };
}

@end
