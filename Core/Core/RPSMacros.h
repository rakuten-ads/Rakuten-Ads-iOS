#ifndef RPSMacros_h
#define RPSMacros_h

// LOG
#if DEBUG
#define RPSDebug(...) rps_log_debug(__VA_ARGS__)
#else
#define RPSDebug(...)
#endif

#define RPSLog(...) rps_log_verbose(__VA_ARGS__)


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

#endif /* RPSMacros_h */
