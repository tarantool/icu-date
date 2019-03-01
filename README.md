# icu-date

LuaJIT FFI bindings to [ICU (International Components for Unicode)](http://site.icu-project.org).
ICU provides a robust date and time library that correctly and efficiently
handles complexities of dealing with dates and times:

- Date and time formatting
- Date and time parsing
- Date and time arithmetic (adding and subtracting)
- Time zones
- Daylight saving time
- Leap years
- ISO 8601 formatting and parsing

## Tutorial

First of all make date/time container object

```lua
local icu_date = require("icu-date")

-- Create a new date object and check result
local date, err = icu_date.new({locale="en_US"}) -- default locale can be omitted
if err ~= nil then
  return nil, err
end
```

Parse date from string with format.
Format pattern parts described here [http://userguide.icu-project.org/formatparse/datetime](http://userguide.icu-project.org/formatparse/datetime)
``` lua
local format_date, err = icu_date.formats.pattern("yyyy-MM-dd")
if err ~= nil then
  return nil, err
end
local rc, err = date:parse(format_date, "2016-09-18")
if err ~= nil then
  return nil, err
end
```

Get milliseconds for parsed date

``` lua
local millis, err = date:get_millis()
if err ~= nil then
  return nil, err
end
```

Also

```lua
-- You can get and set the date's timestamp.
date:set_millis(1507836727123)

-- You can generate an ISO 8601 formatted string.
local format_iso8601 = icu_date.formats.iso8601()
date:format(format_iso8601) -- "2017-10-12T19:32:07.123Z"

-- You can generate a custom formatted string.
local format_custom = icu_date.formats.pattern("EEE, MMM d, yyyy h:mma zzz")
date:format(format_custom) -- "Thu, Oct 12, 2017 7:32PM GMT"

-- You can generate a custom formatted string the necessary locale.
local format_custom = icu_date.formats.pattern("d MMMM y", "ru_RU")
date:format(format_custom) -- "12 октября 2017"

-- You can parse a string using various formats.
local format_date = icu_date.formats.pattern("yyyy-MM-dd")
date:parse(format_date, "2016-09-18")
date:format(format_iso8601) -- "2016-09-18T00:00:00.000Z"

-- You can extract specific date or time fields.
date:get(icu_date.fields.YEAR) -- 2016
date:get(icu_date.fields.WEEK_OF_YEAR) -- 39

-- You can set specific date or time fields.
date:set(icu_date.fields.YEAR, 2019)
date:format(format_iso8601) -- "2019-09-18T00:00:00.000Z"

-- You can perform date or time arithmetic,
date:add(icu_date.fields.MONTH, 4)
date:format(format_iso8601) -- "2020-01-18T00:00:00.000Z"
date:add(icu_date.fields.HOUR_OF_DAY, -2)
date:format(format_iso8601) -- "2020-01-17T22:00:00.000Z"

-- Timezones are fully supported.
date:get_time_zone_id() -- "UTC"
date:set_time_zone_id("America/Denver")
date:format(format_iso8601) -- "2020-01-17T15:00:00.000-07:00"

-- Daylight saving time is also fully supported.
date:set_millis(1509862770000)
date:format(format_iso8601) -- "2017-11-05T00:19:30.000-06:00"
date:add(icu_date.fields.HOUR_OF_DAY, 5)
date:format(format_iso8601) -- "2017-11-05T04:19:30.000-07:00"
```

## Timezones

There is simple way to setup time zone:

``` lua
date = icu.new({zone_id='Europe/Moscow'})
```

There is another way, using time shift from GMT.

``` lua
date = icu.new({zone_id='GMT+3'})
```

## API

### new

**syntax:** `date = icu_date.new(options)`

Create and return a new date object.

The `options` table accepts the following fields:

- `zone_id`: (default: `UTC`)
- `locale`: (default: `en_US`)
- `calendar_type`: (default: `calendar_types.GREGORIAN`)

### now

**syntax:** `now = icu_date.now()`

Get the current date and time in milliseconds from the epoch. 
Returned value is double.

### calendar_types

**syntax:** `fields = icu_date.calendar_types`

### fields

**syntax:** `fields = icu_date.fields`

### attributes

**syntax:** `fields = icu_date.attributes`

### formats.pattern

**syntax:** `format = icu_date.formats.pattern(pattern, locale)`

- `locale` is optional argument (default: `en_US`)

### formats.iso8601

**syntax:** `format = icu_date.formats.iso8601()`

A shortcut for `icu_date.formats.pattern("yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ")`.

### date:get

**syntax:** `date:get(field)`

### date:set

**syntax:** `date:set(field, value)`

### date:add

**syntax:** `date:add(field, amount)`

### date:clear

**syntax:** `date:clear()`

### date:clear_field

**syntax:** `date:clear_field(field)`

### date:get_millis

**syntax:** `date:get_millis()`

### date:set_millis

**syntax:** `date:set_millis(value)`

### date:get_attribute

**syntax:** `date:get_attribute(attribute)`

### date:set_attribute

**syntax:** `date:set_attribute(attribute, value)`

### date:format

**syntax:** `date:format(format)`

### date:parse

**syntax:** `date:parse(format, text, options)`

The `options` table accepts the following fields:

- `clear`: (default: `true`)
