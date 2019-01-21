#ifndef RPSMacros_h
#define RPSMacros_h

// LOG
#ifdef DEBUG
#define RPSLog(...) NSLog(__VA_ARGS__)
#else
#define RPSLog(...)
#endif

#define RPSTrace RPSLog(@"trace %s", __func__);

// suppress deprecated warning
#define CLANG_SILENCE_DEPRECATION(expr)                                   \
do {                                                                \
_Pragma("clang diagnostic push")                                    \
_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"")   \
expr;                                                               \
_Pragma("clang diagnostic pop")                                     \
} while (0)

#define SILENCE_IOS7_DEPRECATION(expr) CLANG_SILENCE_DEPRECATION(expr)
#define SILENCE_IOS8_DEPRECATION(expr) CLANG_SILENCE_DEPRECATION(expr)

// iOS version check
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_BETWEEN(v1, v2) (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v1) && SYSTEM_VERSION_LESS_THAN(v2))


#endif /* RPSMacros_h */
