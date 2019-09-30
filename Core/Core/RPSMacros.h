#ifndef RPSMacros_h
#define RPSMacros_h

// LOG
#if DEBUG
#define RPSDebug(...) rps_log_debug(__VA_ARGS__)
#else
#define RPSDebug(...)
#endif

#define RPSLog(...) rps_log_verbose(__VA_ARGS__)

#endif /* RPSMacros_h */
