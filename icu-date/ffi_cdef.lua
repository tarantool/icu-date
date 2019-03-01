return function(ffi, icu_version_suffix)
  pcall(ffi.cdef, [[
    void* malloc(size_t size);
    void free(void* ptr);

    typedef uint16_t UChar;
    typedef void* UCalendar;
    typedef double UDate;
    typedef void* UDateFormat;
    typedef enum UErrorCode {
      U_USING_FALLBACK_WARNING = -128,
      U_ERROR_WARNING_START = -128,
      U_USING_DEFAULT_WARNING = -127,
      U_SAFECLONE_ALLOCATED_WARNING = -126,
      U_STATE_OLD_WARNING = -125,
      U_STRING_NOT_TERMINATED_WARNING = -124,
      U_SORT_KEY_TOO_SHORT_WARNING = -123,
      U_AMBIGUOUS_ALIAS_WARNING = -122,
      U_DIFFERENT_UCA_VERSION = -121,
      U_PLUGIN_CHANGED_LEVEL_WARNING = -120,
      U_ERROR_WARNING_LIMIT,
      U_ZERO_ERROR =  0,
      U_ILLEGAL_ARGUMENT_ERROR =  1,
      U_MISSING_RESOURCE_ERROR =  2,
      U_INVALID_FORMAT_ERROR =  3,
      U_FILE_ACCESS_ERROR =  4,
      U_INTERNAL_PROGRAM_ERROR =  5,
      U_MESSAGE_PARSE_ERROR =  6,
      U_MEMORY_ALLOCATION_ERROR =  7,
      U_INDEX_OUTOFBOUNDS_ERROR =  8,
      U_PARSE_ERROR =  9,
      U_INVALID_CHAR_FOUND = 10,
      U_TRUNCATED_CHAR_FOUND = 11,
      U_ILLEGAL_CHAR_FOUND = 12,
      U_INVALID_TABLE_FORMAT = 13,
      U_INVALID_TABLE_FILE = 14,
      U_BUFFER_OVERFLOW_ERROR = 15,
      U_UNSUPPORTED_ERROR = 16,
      U_RESOURCE_TYPE_MISMATCH = 17,
      U_ILLEGAL_ESCAPE_SEQUENCE = 18,
      U_UNSUPPORTED_ESCAPE_SEQUENCE = 19,
      U_NO_SPACE_AVAILABLE = 20,
      U_CE_NOT_FOUND_ERROR = 21,
      U_PRIMARY_TOO_LONG_ERROR = 22,
      U_STATE_TOO_OLD_ERROR = 23,
      U_TOO_MANY_ALIASES_ERROR = 24,
      U_ENUM_OUT_OF_SYNC_ERROR = 25,
      U_INVARIANT_CONVERSION_ERROR = 26,
      U_INVALID_STATE_ERROR = 27,
      U_COLLATOR_VERSION_MISMATCH = 28,
      U_USELESS_COLLATOR_ERROR = 29,
      U_NO_WRITE_PERMISSION = 30,
      U_STANDARD_ERROR_LIMIT,
      U_BAD_VARIABLE_DEFINITION=0x10000,
      U_PARSE_ERROR_START = 0x10000,
      U_MALFORMED_RULE,
      U_MALFORMED_SET,
      U_MALFORMED_SYMBOL_REFERENCE,
      U_MALFORMED_UNICODE_ESCAPE,
      U_MALFORMED_VARIABLE_DEFINITION,
      U_MALFORMED_VARIABLE_REFERENCE,
      U_MISMATCHED_SEGMENT_DELIMITERS,
      U_MISPLACED_ANCHOR_START,
      U_MISPLACED_CURSOR_OFFSET,
      U_MISPLACED_QUANTIFIER,
      U_MISSING_OPERATOR,
      U_MISSING_SEGMENT_CLOSE,
      U_MULTIPLE_ANTE_CONTEXTS,
      U_MULTIPLE_CURSORS,
      U_MULTIPLE_POST_CONTEXTS,
      U_TRAILING_BACKSLASH,
      U_UNDEFINED_SEGMENT_REFERENCE,
      U_UNDEFINED_VARIABLE,
      U_UNQUOTED_SPECIAL,
      U_UNTERMINATED_QUOTE,
      U_RULE_MASK_ERROR,
      U_MISPLACED_COMPOUND_FILTER,
      U_MULTIPLE_COMPOUND_FILTERS,
      U_INVALID_RBT_SYNTAX,
      U_INVALID_PROPERTY_PATTERN,
      U_MALFORMED_PRAGMA,
      U_UNCLOSED_SEGMENT,
      U_ILLEGAL_CHAR_IN_SEGMENT,
      U_VARIABLE_RANGE_EXHAUSTED,
      U_VARIABLE_RANGE_OVERLAP,
      U_ILLEGAL_CHARACTER,
      U_INTERNAL_TRANSLITERATOR_ERROR,
      U_INVALID_ID,
      U_INVALID_FUNCTION,
      U_PARSE_ERROR_LIMIT,
      U_UNEXPECTED_TOKEN=0x10100,
      U_FMT_PARSE_ERROR_START=0x10100,
      U_MULTIPLE_DECIMAL_SEPARATORS,
      U_MULTIPLE_DECIMAL_SEPERATORS = U_MULTIPLE_DECIMAL_SEPARATORS,
      U_MULTIPLE_EXPONENTIAL_SYMBOLS,
      U_MALFORMED_EXPONENTIAL_PATTERN,
      U_MULTIPLE_PERCENT_SYMBOLS,
      U_MULTIPLE_PERMILL_SYMBOLS,
      U_MULTIPLE_PAD_SPECIFIERS,
      U_PATTERN_SYNTAX_ERROR,
      U_ILLEGAL_PAD_POSITION,
      U_UNMATCHED_BRACES,
      U_UNSUPPORTED_PROPERTY,
      U_UNSUPPORTED_ATTRIBUTE,
      U_ARGUMENT_TYPE_MISMATCH,
      U_DUPLICATE_KEYWORD,
      U_UNDEFINED_KEYWORD,
      U_DEFAULT_KEYWORD_MISSING,
      U_DECIMAL_NUMBER_SYNTAX_ERROR,
      U_FORMAT_INEXACT_ERROR,
      U_FMT_PARSE_ERROR_LIMIT,
      U_BRK_INTERNAL_ERROR=0x10200,
      U_BRK_ERROR_START=0x10200,
      U_BRK_HEX_DIGITS_EXPECTED,
      U_BRK_SEMICOLON_EXPECTED,
      U_BRK_RULE_SYNTAX,
      U_BRK_UNCLOSED_SET,
      U_BRK_ASSIGN_ERROR,
      U_BRK_VARIABLE_REDFINITION,
      U_BRK_MISMATCHED_PAREN,
      U_BRK_NEW_LINE_IN_QUOTED_STRING,
      U_BRK_UNDEFINED_VARIABLE,
      U_BRK_INIT_ERROR,
      U_BRK_RULE_EMPTY_SET,
      U_BRK_UNRECOGNIZED_OPTION,
      U_BRK_MALFORMED_RULE_TAG,
      U_BRK_ERROR_LIMIT,
      U_REGEX_INTERNAL_ERROR=0x10300,
      U_REGEX_ERROR_START=0x10300,
      U_REGEX_RULE_SYNTAX,
      U_REGEX_INVALID_STATE,
      U_REGEX_BAD_ESCAPE_SEQUENCE,
      U_REGEX_PROPERTY_SYNTAX,
      U_REGEX_UNIMPLEMENTED,
      U_REGEX_MISMATCHED_PAREN,
      U_REGEX_NUMBER_TOO_BIG,
      U_REGEX_BAD_INTERVAL,
      U_REGEX_MAX_LT_MIN,
      U_REGEX_INVALID_BACK_REF,
      U_REGEX_INVALID_FLAG,
      U_REGEX_LOOK_BEHIND_LIMIT,
      U_REGEX_SET_CONTAINS_STRING,
      U_REGEX_OCTAL_TOO_BIG,
      U_REGEX_MISSING_CLOSE_BRACKET=U_REGEX_SET_CONTAINS_STRING+2,
      U_REGEX_INVALID_RANGE,
      U_REGEX_STACK_OVERFLOW,
      U_REGEX_TIME_OUT,
      U_REGEX_STOPPED_BY_CALLER,
      U_REGEX_PATTERN_TOO_BIG,
      U_REGEX_INVALID_CAPTURE_GROUP_NAME,
      U_REGEX_ERROR_LIMIT=U_REGEX_STOPPED_BY_CALLER+3,
      U_IDNA_PROHIBITED_ERROR=0x10400,
      U_IDNA_ERROR_START=0x10400,
      U_IDNA_UNASSIGNED_ERROR,
      U_IDNA_CHECK_BIDI_ERROR,
      U_IDNA_STD3_ASCII_RULES_ERROR,
      U_IDNA_ACE_PREFIX_ERROR,
      U_IDNA_VERIFICATION_ERROR,
      U_IDNA_LABEL_TOO_LONG_ERROR,
      U_IDNA_ZERO_LENGTH_LABEL_ERROR,
      U_IDNA_DOMAIN_NAME_TOO_LONG_ERROR,
      U_IDNA_ERROR_LIMIT,
      U_STRINGPREP_PROHIBITED_ERROR = U_IDNA_PROHIBITED_ERROR,
      U_STRINGPREP_UNASSIGNED_ERROR = U_IDNA_UNASSIGNED_ERROR,
      U_STRINGPREP_CHECK_BIDI_ERROR = U_IDNA_CHECK_BIDI_ERROR,
      U_PLUGIN_ERROR_START=0x10500,
      U_PLUGIN_TOO_HIGH=0x10500,
      U_PLUGIN_DIDNT_SET_LEVEL,
      U_PLUGIN_ERROR_LIMIT,
      U_ERROR_LIMIT=U_PLUGIN_ERROR_LIMIT
    } UErrorCode;
    typedef enum UDateFormatStyle {
      UDAT_FULL,
      UDAT_LONG,
      UDAT_MEDIUM,
      UDAT_SHORT,
      UDAT_DEFAULT = UDAT_MEDIUM,
      UDAT_RELATIVE = (1 << 7),
      UDAT_FULL_RELATIVE = UDAT_FULL | UDAT_RELATIVE,
      UDAT_LONG_RELATIVE = UDAT_LONG | UDAT_RELATIVE,
      UDAT_MEDIUM_RELATIVE = UDAT_MEDIUM | UDAT_RELATIVE,
      UDAT_SHORT_RELATIVE = UDAT_SHORT | UDAT_RELATIVE,
      UDAT_NONE = -1,
      UDAT_PATTERN = -2,
    } UDateFormatStyle;
    typedef enum UCalendarType {
      UCAL_TRADITIONAL,
      UCAL_DEFAULT = UCAL_TRADITIONAL,
      UCAL_GREGORIAN
    } UCalendarType;
    typedef struct UFieldPosition {
      int32_t field;
      int32_t beginIndex;
      int32_t endIndex;
    } UFieldPosition;
    typedef enum UCalendarDateFields {
      UCAL_ERA,
      UCAL_YEAR,
      UCAL_MONTH,
      UCAL_WEEK_OF_YEAR,
      UCAL_WEEK_OF_MONTH,
      UCAL_DATE,
      UCAL_DAY_OF_YEAR,
      UCAL_DAY_OF_WEEK,
      UCAL_DAY_OF_WEEK_IN_MONTH,
      UCAL_AM_PM,
      UCAL_HOUR,
      UCAL_HOUR_OF_DAY,
      UCAL_MINUTE,
      UCAL_SECOND,
      UCAL_MILLISECOND,
      UCAL_ZONE_OFFSET,
      UCAL_DST_OFFSET,
      UCAL_YEAR_WOY,
      UCAL_DOW_LOCAL,
      UCAL_EXTENDED_YEAR,
      UCAL_JULIAN_DAY,
      UCAL_MILLISECONDS_IN_DAY,
      UCAL_IS_LEAP_MONTH,
      UCAL_FIELD_COUNT,
      UCAL_DAY_OF_MONTH=UCAL_DATE
    } UCalendarDateFields;
    typedef enum UCalendarAttribute {
      UCAL_LENIENT,
      UCAL_FIRST_DAY_OF_WEEK,
      UCAL_MINIMAL_DAYS_IN_FIRST_WEEK,
      UCAL_REPEATED_WALL_TIME,
      UCAL_SKIPPED_WALL_TIME
    } UCalendarAttribute;

    int32_t u_strlen]] .. icu_version_suffix .. [[(const UChar* s);
    UChar* u_uastrcpy]] .. icu_version_suffix .. [[(UChar* dst, const char* src);
    char* u_austrcpy]] .. icu_version_suffix .. [[(char* dst, const UChar* src);

    const char* u_errorName]] .. icu_version_suffix .. [[(UErrorCode code);

    UDateFormat* udat_open]] .. icu_version_suffix .. [[(UDateFormatStyle timeStyle, UDateFormatStyle dateStyle, const char* locale, const UChar* tzID, int32_t tzIDLength, const UChar* pattern, int32_t patternLength, UErrorCode* status);
    void udat_close]] .. icu_version_suffix .. [[(UDateFormat* format);
    void udat_parseCalendar]] .. icu_version_suffix .. [[(const UDateFormat* format, UCalendar* calendar, const UChar* text, int32_t textLength, int32_t* parsePos, UErrorCode* status);
    int32_t udat_formatCalendar]] .. icu_version_suffix .. [[(const UDateFormat* format, UCalendar* calendar, UChar* result, int32_t capacity, UFieldPosition* position, UErrorCode* status);

    UCalendar* ucal_open]] .. icu_version_suffix .. [[(const UChar* zoneID, int32_t len, const char* locale, UCalendarType type, UErrorCode* status);
    void ucal_close]] .. icu_version_suffix .. [[(UCalendar* cal);
    int32_t ucal_get]] .. icu_version_suffix .. [[(const UCalendar* cal, UCalendarDateFields field, UErrorCode* status);
    void ucal_set]] .. icu_version_suffix .. [[(UCalendar* cal, UCalendarDateFields field, int32_t value);
    void ucal_add]] .. icu_version_suffix .. [[(UCalendar* cal, UCalendarDateFields field, int32_t amount, UErrorCode* status);
    void ucal_clear]] .. icu_version_suffix .. [[(UCalendar* cal);
    void ucal_clearField]] .. icu_version_suffix .. [[(UCalendar* cal, UCalendarDateFields field);
    UDate ucal_getMillis]] .. icu_version_suffix .. [[(const UCalendar* cal, UErrorCode* status);
    void ucal_setMillis]] .. icu_version_suffix .. [[(UCalendar* cal, UDate dateTime, UErrorCode* status);
    int32_t ucal_getAttribute]] .. icu_version_suffix .. [[(const UCalendar* cal, UCalendarAttribute attr) ;
    void ucal_setAttribute]] .. icu_version_suffix .. [[(UCalendar* cal, UCalendarAttribute attr, int32_t newValue);
    int32_t ucal_getTimeZoneID]] .. icu_version_suffix .. [[(const UCalendar* cal, UChar* result, int32_t resultLength, UErrorCode* status) ;
    void ucal_setTimeZone]] .. icu_version_suffix .. [[(UCalendar* cal, const UChar* zoneID, int32_t len, UErrorCode* status);
  ]])
end
