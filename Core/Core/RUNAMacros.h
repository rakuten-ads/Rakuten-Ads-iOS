#ifndef RUNAMacros_h
#define RUNAMacros_h

// LOG
#if DEBUG
#define RUNADebug(...) runa_log_debug(__VA_ARGS__)
#else
#define RUNADebug(...)
#endif

#define RUNALog(...) runa_log_info(__VA_ARGS__)

#endif /* RUNAMacros_h */
