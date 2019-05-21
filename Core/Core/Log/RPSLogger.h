#import <os/log.h>

FOUNDATION_EXPORT BOOL gRPSLogModeEnabled;

@interface RPSLogger : NSObject

+(void) debug:(const char*) format, ...;
+(void) vdebug:(const char*) format withArgs:(va_list) args;

+(void) info:(const char*) format, ...;
+(void) vinfo:(const char*) format withArgs:(va_list) args;


+(os_log_t) sharedLog;

@end


#define rps_shared_log [RPSLogger sharedLog]
#define rps_os_debug(format, ...) __extension__ ({\
    os_log_with_type(rps_shared_log, OS_LOG_TYPE_DEBUG, format, ##__VA_ARGS__);\
})

#define rps_os_info(format, ...) __extension__ ({\
    os_log_with_type(rps_shared_log, OS_LOG_TYPE_INFO, format, ##__VA_ARGS__);\
})

#define rps_os_error(format, ...) __extension__ ({\
    os_log_with_type(rps_shared_log, OS_LOG_TYPE_ERROR, format, ##__VA_ARGS__);\
})

#define rps_log_debug(format, ...) __extension__ ({\
    if (@available(iOS 10.0, *)) {\
        rps_os_debug(format, ##__VA_ARGS__);\
    } else {\
        [RPSLogger debug:format, ##__VA_ARGS__];\
    };\
})

#define rps_log_info(format, ...) __extension__ ({\
    if (@available(iOS 10.0, *)) {\
        rps_os_info(format, ##__VA_ARGS__);\
    } else {\
        [RPSLogger info:format, ##__VA_ARGS__];\
    };\
})

#define rps_log_verbose(...) __extension__ ({\
    if (gRPSLogModeEnabled) {\
        rps_log_info(__VA_ARGS__);\
    };\
})
