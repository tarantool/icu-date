local ffi = require("ffi")
local detect_icu_version_suffix = require("icu-date.detect_icu_version_suffix")
local icu_ffi_cdef = require("icu-date.ffi_cdef")

local icu_version_suffix = detect_icu_version_suffix()
icu_ffi_cdef(ffi, icu_version_suffix)
local icu = ffi.C

local uerrorcode_type = ffi.typeof("UErrorCode[1]")
local uchar_size = ffi.sizeof("UChar")
local char_size = ffi.sizeof("char")

local _M = {}
_M.__index = _M

local function call_fn(name, ...)
  return icu[name .. icu_version_suffix](...)
end

local function call_fn_status(name, ...)
  local length = select("#", ...)
  local status_ptr = select(length, ...)
  status_ptr[0] = icu.U_ZERO_ERROR

  local result = call_fn(name, ...)
  return tonumber(status_ptr[0]), result
end

local function check_status(status, result)
  if status == icu.U_ZERO_ERROR then
    return result
  else
    local error_name = ffi.string(call_fn("u_errorName", status))
    if status >= icu.U_ERROR_WARNING_START and status < icu.U_ERROR_WARNING_LIMIT then
      -- print("WARNING: " .. error_name)
      return result
    else
      error("Invalid status: " .. (tostring(error_name) or "") .. ". Result: " .. (tostring(result) or ""))
    end
  end
end

local function call_fn_check_status(name, ...)
  local status, result = call_fn_status(name, ...)
  return check_status(status, result)
end

local function string_to_uchar(str)
  local length = string.len(str) + 1
  local size = length * uchar_size
  local uchar = ffi.gc(ffi.C.malloc(size), ffi.C.free)
  call_fn("u_uastrcpy", uchar, str)
  return uchar
end

local function uchar_to_string(uchar)
  local length = call_fn("u_strlen", uchar) + 1
  local size = length * char_size
  local str = ffi.gc(ffi.C.malloc(size), ffi.C.free)
  call_fn("u_austrcpy", str, uchar)
  return ffi.string(str)
end

function _M:get(field)
  assert(field)
  return call_fn_check_status("ucal_get", self.cal, field, self.status_ptr)
end

function _M:set(field, value)
  assert(field)
  return call_fn("ucal_set", self.cal, field, value)
end

function _M:add(field, amount)
  assert(field)
  return call_fn_check_status("ucal_add", self.cal, field, amount, self.status_ptr)
end

function _M:clear()
  return call_fn("ucal_clear", self.cal)
end

function _M:clear_field(field)
  assert(field)
  return call_fn("ucal_clear", self.cal, field)
end

function _M:get_millis()
  return call_fn_check_status("ucal_getMillis", self.cal, self.status_ptr)
end

function _M:set_millis(value)
  return call_fn_check_status("ucal_setMillis", self.cal, value, self.status_ptr)
end

function _M:get_attribute(attribute)
  assert(attribute)
  return call_fn("ucal_getAttribute", self.cal, attribute)
end

function _M:set_attribute(attribute, value)
  assert(attribute)
  return call_fn("ucal_setAttribute", self.cal, attribute, value)
end

function _M:get_time_zone_id()
  local result_length = 64
  local result = ffi.gc(ffi.C.malloc(result_length * uchar_size), ffi.C.free)

  local status, needed_length = call_fn_status("ucal_getTimeZoneID", self.cal, result, result_length, self.status_ptr)
  if status == icu.U_BUFFER_OVERFLOW_ERROR then
    result_length = needed_length + 1
    result = ffi.gc(ffi.C.malloc(result_length * uchar_size), ffi.C.free)
    call_fn_status("ucal_getTimeZoneID", self.cal, result, result_length, self.status_ptr)
  else
    check_status(status)
  end

  return uchar_to_string(result)
end

function _M:set_time_zone_id(zone_id)
  assert(zone_id)
  zone_id = string_to_uchar(zone_id)
  return call_fn_check_status("ucal_setTimeZone", self.cal, zone_id, -1, self.status_ptr)
end

function _M:format(format)
  assert(format)
  local result_length = 64
  local result = ffi.gc(ffi.C.malloc(result_length * uchar_size), ffi.C.free)

  local status, needed_length = call_fn_status("udat_formatCalendar", format, self.cal, result, result_length, nil, self.status_ptr)
  if status == icu.U_BUFFER_OVERFLOW_ERROR then
    result_length = needed_length + 1
    result = ffi.gc(ffi.C.malloc(result_length * uchar_size), ffi.C.free)
    call_fn_check_status("udat_formatCalendar", format, self.cal, result, result_length, nil, self.status_ptr)
  else
    check_status(status)
  end

  return uchar_to_string(result)
end

function _M:parse(format, text, options)
  assert(format)
  if not options or options["clear"] ~= false then
    _M.clear(self)
  end

  local text_uchar = string_to_uchar(text)
  local position_ptr = ffi.new("int32_t[1]")
  call_fn_check_status("udat_parseCalendar", format, self.cal, text_uchar, -1, position_ptr, self.status_ptr)
end

local function close_cal(cal)
  call_fn("ucal_close", cal)
end

function _M.new(options)
  local zone_id
  local locale
  local calendar_type
  if options then
    zone_id = options["zone_id"]
    locale = options["locale"]
    calendar_type = options["calendar_type"]
  end

  if not zone_id then
    zone_id = "UTC"
  end
  zone_id = string_to_uchar(zone_id)

  if not locale then
    locale = "en_US"
  end

  if not calendar_type then
    calendar_type = _M.calendar_types.GREGORIAN
  end

  local status_ptr = ffi.new(uerrorcode_type)
  local cal = call_fn_check_status("ucal_open", zone_id, -1, locale, calendar_type, status_ptr)
  ffi.gc(cal, close_cal)

  local self = {
    cal = cal,
    status_ptr = status_ptr,
  }

  return setmetatable(self, _M)
end

_M.formats = {}
local format_cache = {}

local function close_date_format(format)
  call_fn("udat_close", format)
end

function _M.formats.pattern(pattern, locale)
  locale = locale or "en_US"
  if format_cache[pattern] and format_cache[pattern][locale] then
    return format_cache[pattern][locale]
  end

  local pattern_uchar = string_to_uchar(pattern)
  local status_ptr = ffi.new(uerrorcode_type)
  local format = call_fn_check_status("udat_open", icu.UDAT_PATTERN, icu.UDAT_PATTERN, locale, nil, 0, pattern_uchar, -1, status_ptr)
  ffi.gc(format, close_date_format)

  format_cache[pattern] = format_cache[pattern] or {}
  format_cache[pattern][locale] = format

  return format
end

function _M.formats.iso8601()
  return _M.formats.pattern("yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ")
end

_M._icu = icu

_M.calendar_types = {
  DEFAULT = icu.UCAL_DEFAULT,
  GREGORIAN = icu.UCAL_GREGORIAN,
}

_M.fields = {
  ERA = icu.UCAL_ERA,
  YEAR = icu.UCAL_YEAR,
  MONTH = icu.UCAL_MONTH,
  WEEK_OF_YEAR = icu.UCAL_WEEK_OF_YEAR,
  WEEK_OF_MONTH = icu.UCAL_WEEK_OF_MONTH,
  DATE = icu.UCAL_DATE,
  DAY_OF_YEAR = icu.UCAL_DAY_OF_YEAR,
  DAY_OF_WEEK = icu.UCAL_DAY_OF_WEEK,
  DAY_OF_WEEK_IN_MONTH = icu.UCAL_DAY_OF_WEEK_IN_MONTH,
  AM_PM = icu.UCAL_AM_PM,
  HOUR = icu.UCAL_HOUR,
  HOUR_OF_DAY = icu.UCAL_HOUR_OF_DAY,
  MINUTE = icu.UCAL_MINUTE,
  SECOND = icu.UCAL_SECOND,
  MILLISECOND = icu.UCAL_MILLISECOND,
  ZONE_OFFSET = icu.UCAL_ZONE_OFFSET,
  DST_OFFSET = icu.UCAL_DST_OFFSET,
  YEAR_WOY = icu.UCAL_YEAR_WOY,
  DOW_LOCAL = icu.UCAL_DOW_LOCAL,
  EXTENDED_YEAR = icu.UCAL_EXTENDED_YEAR,
  JULIAN_DAY = icu.UCAL_JULIAN_DAY,
  MILLISECONDS_IN_DAY = icu.UCAL_MILLISECONDS_IN_DAY,
  IS_LEAP_MONTH = icu.UCAL_IS_LEAP_MONTH,
  DAY_OF_MONTH = icu.UCAL_DAY_OF_MONTH,
}

_M.attributes = {
  LENIENT = icu.UCAL_LENIENT,
  FIRST_DAY_OF_WEEK = icu.UCAL_FIRST_DAY_OF_WEEK,
  MINIMAL_DAYS_IN_FIRST_WEEK = icu.UCAL_MINIMAL_DAYS_IN_FIRST_WEEK,
  REPEATED_WALL_TIME = icu.UCAL_REPEATED_WALL_TIME,
  SKIPPED_WALL_TIME = icu.UCAL_SKIPPED_WALL_TIME,
}

return _M
