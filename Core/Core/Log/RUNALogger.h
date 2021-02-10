#import <os/log.h>

@interface RUNALogger : NSObject

+(os_log_t) sharedLog;

@end


#define runa_shared_log [RUNALogger sharedLog]
#define runa_os_log_debug(format, ...) __extension__ ({\
    os_log_with_type(runa_shared_log, OS_LOG_TYPE_DEBUG, format, ##__VA_ARGS__);\
})

#define runa_os_log_info(format, ...) __extension__ ({\
    os_log_with_type(runa_shared_log, OS_LOG_TYPE_INFO, format, ##__VA_ARGS__);\
})

#define runa_os_log_error(format, ...) __extension__ ({\
    os_log_with_type(runa_shared_log, OS_LOG_TYPE_ERROR, format, ##__VA_ARGS__);\
})

#define runa_log_debug(format, ...) __extension__ ({\
    runa_os_log_debug(format, ##__VA_ARGS__);\
})

#define runa_log_info(format, ...) __extension__ ({\
    runa_os_log_info(format, ##__VA_ARGS__);\
})
