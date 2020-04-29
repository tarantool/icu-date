#!/usr/bin/env tarantool
require('strict').on()

local icu_date = require('icu-date')
local tap = require('tap')

local test = tap.test("get")
test:plan(24)

local function date_test(test, func)
    test:plan(2)

    local fields = icu_date.fields
    local date = icu_date.new()
    local format = icu_date.formats.iso8601()

    date:set_millis(1507836727123)
    test:ok("2017-10-12T19:32:07.123Z" == date:format(format))

    test:test("", func, date, fields)
end

test:test("gets era", date_test,
          function(test, date, fields)
              test:plan(1)
              test:is(1, date:get(fields.ERA))
end)

test:test("gets year", date_test,
          function(test, date, fields)
              test:plan(1)
              test:is(2017, date:get(fields.YEAR))
end)

test:test("gets month", date_test,
          function(test, date, fields)
              test:plan(1)
              test:is(9, date:get(fields.MONTH))
end)

test:test("gets week of year", date_test,
          function(test, date, fields)
              test:plan(1)
              test:is(41, date:get(fields.WEEK_OF_YEAR))
end)

test:test("gets week of month", date_test,
          function(test, date, fields)
              test:plan(1)
              test:is(2, date:get(fields.WEEK_OF_MONTH))
end)

test:test("gets date", date_test,
          function(test, date, fields)
              test:plan(1)
              test:is(12, date:get(fields.DATE, fields))
end)

test:test("gets day of year", date_test,
          function(test, date, fields)
              test:plan(1)
              test:is(285, date:get(fields.DAY_OF_YEAR))
end)

test:test("gets day of week", date_test,
          function(test, date, fields)
              test:plan(1)
              test:is(5, date:get(fields.DAY_OF_WEEK))
end)

test:test("gets day of week in month", date_test,
          function(test, date, fields)
              test:plan(1)
              test:is(2, date:get(fields.DAY_OF_WEEK_IN_MONTH))
end)

test:test("gets am/pm", date_test,
          function(test, date, fields)
              test:plan(1)
              test:is(1, date:get(fields.AM_PM))
end)

test:test("gets hour", date_test,
          function(test, date, fields)
              test:plan(1)
              test:is(7, date:get(fields.HOUR))
end)

test:test("gets hour of day", date_test,
          function(test, date, fields)
              test:plan(1)
              test:is(19, date:get(fields.HOUR_OF_DAY))
end)

test:test("gets minute", date_test,
          function(test, date, fields)
              test:plan(1)
              test:is(32, date:get(fields.MINUTE))
end)

test:test("gets second", date_test,
          function(test, date, fields)
              test:plan(1)
              test:is(7, date:get(fields.SECOND))
end)

test:test("gets millisecond", date_test,
          function(test, date, fields)
              test:plan(1)
              test:is(123, date:get(fields.MILLISECOND))
end)

test:test("gets zone offset", date_test,
          function(test, date, fields)
              test:plan(1)
              test:is(0, date:get(fields.ZONE_OFFSET))
end)

test:test("gets dst offset", date_test,
          function(test, date, fields)
              test:plan(1)
              test:is(0, date:get(fields.DST_OFFSET))
end)

test:test("gets year woy", date_test,
          function(test, date, fields)
              test:plan(1)
              test:is(2017, date:get(fields.YEAR_WOY))
end)

test:test("gets dow local", date_test,
          function(test, date, fields)
              test:plan(1)
              test:is(5, date:get(fields.DOW_LOCAL))
end)

test:test("gets extended year", date_test,
          function(test, date, fields)
              test:plan(1)
              test:is(2017, date:get(fields.EXTENDED_YEAR))
end)

test:test("gets julian day", date_test,
          function(test, date, fields)
              test:plan(1)
              test:is(2458039, date:get(fields.JULIAN_DAY))
end)

test:test("gets milliseconds in day", date_test,
          function(test, date, fields)
              test:plan(1)
              test:is(70327123, date:get(fields.MILLISECONDS_IN_DAY))
end)

test:test("gets is leap month", date_test,
          function(test, date, fields)
              test:plan(1)
              test:is(0, date:get(fields.IS_LEAP_MONTH))
end)

test:test("gets day of month", date_test,
          function(test, date, fields)
              test:plan(1)
              test:is(12, date:get(fields.DAY_OF_MONTH))
end)

os.exit(test:check() and 0 or 1)
