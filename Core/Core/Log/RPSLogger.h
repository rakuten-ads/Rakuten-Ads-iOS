#import <os/log.h>

FOUNDATION_EXPORT BOOL gRPSLogVerboseEnabled;

@interface RPSLogger : NSObject

+(os_log_t) sharedLog;

@end


#define rps_shared_log [RPSLogger sharedLog]
#define rps_os_log_debug(format, ...) __extension__ ({\
    os_log_with_type(rps_shared_log, OS_LOG_TYPE_DEBUG, format, ##__VA_ARGS__);\
})

#define rps_os_log_info(format, ...) __extension__ ({\
    os_log_with_type(rps_shared_log, OS_LOG_TYPE_INFO, format, ##__VA_ARGS__);\
})

#define rps_os_log_error(format, ...) __extension__ ({\
    os_log_with_type(rps_shared_log, OS_LOG_TYPE_ERROR, format, ##__VA_ARGS__);\
})

#define rps_log_debug(format, ...) __extension__ ({\
    rps_os_log_debug(format, ##__VA_ARGS__);\
})

#define rps_log_info(format, ...) __extension__ ({\
    rps_os_log_info(format, ##__VA_ARGS__);\
})

#define rps_log_verbose(...) __extension__ ({\
    if (gRPSLogVerboseEnabled) {\
        rps_log_info(__VA_ARGS__);\
    } else {\
        rps_log_debug(__VA_ARGS__);\
    };\
})
