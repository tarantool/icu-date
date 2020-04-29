#!/usr/bin/env tarantool
require('strict').on()

local icu_date = require('icu-date')
local tap = require('tap')

local test = tap.test("set")
test:plan(24)

local fields = icu_date.fields
local format = icu_date.formats.iso8601()

local function date_test(test, func)
    test:plan(2)

    local date = icu_date.new()

    date:set_millis(1507836727123)
    test:ok("2017-10-12T19:32:07.123Z" == date:format(format))

    test:test("", func, date)
end


test:test("setting era is a no-op", date_test,
          function(test, date)
              test:plan(3)
              test:is(1, date:get(fields.ERA))
              date:set(fields.ERA, 0)
              test:is(1, date:get(fields.ERA))
              test:is("2017-10-12T19:32:07.123Z", date:format(format))
end)

test:test("sets year", date_test,
          function(test, date)
              test:plan(3)
              test:is(2017, date:get(fields.YEAR))
              date:set(fields.YEAR, 2016)
              test:is(2016, date:get(fields.YEAR))
              test:is("2016-10-12T19:32:07.123Z", date:format(format))
end)

test:test("sets month", date_test,
          function(test, date)
              test:plan(3)
              test:is(9, date:get(fields.MONTH))
              date:set(fields.MONTH, 0)
              test:is(0, date:get(fields.MONTH))
              test:is("2017-01-12T19:32:07.123Z", date:format(format))
end)

test:test("sets week of year", date_test,
          function(test, date)
              test:plan(3)
              test:is(41, date:get(fields.WEEK_OF_YEAR))
              date:set(fields.WEEK_OF_YEAR, 1)
              test:is(1, date:get(fields.WEEK_OF_YEAR))
              test:is("2017-01-05T19:32:07.123Z", date:format(format))
end)

test:test("sets week of month", date_test,
          function(test, date)
              test:plan(3)
              test:is(2, date:get(fields.WEEK_OF_MONTH))
              date:set(fields.WEEK_OF_MONTH, 1)
              test:is(1, date:get(fields.WEEK_OF_MONTH))
              test:is("2017-10-05T19:32:07.123Z", date:format(format))
end)

test:test("sets date", date_test,
          function(test, date)
              test:plan(3)
              test:is(12, date:get(fields.DATE))
              date:set(fields.DATE, 1)
              test:is(1, date:get(fields.DATE))
              test:is("2017-10-01T19:32:07.123Z", date:format(format))
end)

test:test("sets day of year", date_test,
          function(test, date)
              test:plan(3)
              test:is(285, date:get(fields.DAY_OF_YEAR))
              date:set(fields.DAY_OF_YEAR, 1)
              test:is(1, date:get(fields.DAY_OF_YEAR))
              test:is("2017-01-01T19:32:07.123Z", date:format(format))
end)

test:test("sets day of week", date_test,
          function(test, date)
              test:plan(3)
              test:is(5, date:get(fields.DAY_OF_WEEK))
              date:set(fields.DAY_OF_WEEK, 1)
              test:is(1, date:get(fields.DAY_OF_WEEK))
              test:is("2017-10-08T19:32:07.123Z", date:format(format))
end)

test:test("sets day of week in month", date_test,
          function(test, date)
              test:plan(3)
              test:is(2, date:get(fields.DAY_OF_WEEK_IN_MONTH))
              date:set(fields.DAY_OF_WEEK_IN_MONTH, 1)
              test:is(1, date:get(fields.DAY_OF_WEEK_IN_MONTH))
              test:is("2017-10-05T19:32:07.123Z", date:format(format))
end)

test:test("sets am/pm", date_test,
          function(test, date)
              test:plan(3)
              test:is(1, date:get(fields.AM_PM))
              date:set(fields.AM_PM, 0)
              test:is(0, date:get(fields.AM_PM))
              test:is("2017-10-12T07:32:07.123Z", date:format(format))
end)

test:test("sets hour", date_test,
          function(test, date)
              test:plan(3)
              test:is(7, date:get(fields.HOUR))
              date:set(fields.HOUR, 1)
              test:is(1, date:get(fields.HOUR))
              test:is("2017-10-12T13:32:07.123Z", date:format(format))
end)

test:test("sets hour of day", date_test,
          function(test, date)
              test:plan(3)
              test:is(19, date:get(fields.HOUR_OF_DAY))
              date:set(fields.HOUR_OF_DAY, 1)
              test:is(1, date:get(fields.HOUR_OF_DAY))
              test:is("2017-10-12T01:32:07.123Z", date:format(format))
end)

test:test("sets minute", date_test,
          function(test, date)
              test:plan(3)
              test:is(32, date:get(fields.MINUTE))
              date:set(fields.MINUTE, 1)
              test:is(1, date:get(fields.MINUTE))
              test:is("2017-10-12T19:01:07.123Z", date:format(format))
end)

test:test("sets second", date_test,
          function(test, date)
              test:plan(3)
              test:is(7, date:get(fields.SECOND))
              date:set(fields.SECOND, 1)
              test:is(1, date:get(fields.SECOND))
              test:is("2017-10-12T19:32:01.123Z", date:format(format))
end)

test:test("sets millisecond", date_test,
          function(test, date)
              test:plan(3)
              test:is(123, date:get(fields.MILLISECOND))
              date:set(fields.MILLISECOND, 1)
              test:is(1, date:get(fields.MILLISECOND))
              test:is("2017-10-12T19:32:07.001Z", date:format(format))
end)

test:test("sets zone offset", date_test,
          function(test, date)
              test:plan(3)
              test:is(0, date:get(fields.ZONE_OFFSET))
              date:set(fields.ZONE_OFFSET, 3600000)
              test:is(0, date:get(fields.ZONE_OFFSET))
              test:is("2017-10-12T18:32:07.123Z", date:format(format))
end)

test:test("sets dst offset", date_test,
          function(test, date)
              test:plan(3)
              test:is(0, date:get(fields.DST_OFFSET))
              date:set(fields.DST_OFFSET, -3600000)
              test:is(0, date:get(fields.DST_OFFSET))
              test:is("2017-10-12T20:32:07.123Z", date:format(format))
end)

test:test("sets year woy", date_test,
          function(test, date)
              test:plan(3)
              test:is(2017, date:get(fields.YEAR_WOY))
              date:set(fields.YEAR_WOY, 2016)
              test:is(2016, date:get(fields.YEAR_WOY))
              test:is("2016-10-06T19:32:07.123Z", date:format(format))
end)

test:test("sets dow local", date_test,
          function(test, date)
              test:plan(3)
              test:is(5, date:get(fields.DOW_LOCAL))
              date:set(fields.DOW_LOCAL, 1)
              test:is(1, date:get(fields.DOW_LOCAL))
              test:is("2017-10-08T19:32:07.123Z", date:format(format))
end)

test:test("sets extended year", date_test,
          function(test, date)
              test:plan(3)
              test:is(2017, date:get(fields.EXTENDED_YEAR))
              date:set(fields.EXTENDED_YEAR, 2016)
              test:is(2016, date:get(fields.EXTENDED_YEAR))
              test:is("2016-10-12T19:32:07.123Z", date:format(format))
end)

test:test("sets julian day", date_test,
          function(test, date)
              test:plan(3)
              test:is(2458039, date:get(fields.JULIAN_DAY))
              date:set(fields.JULIAN_DAY, 1)
              test:is(4713, date:get(fields.YEAR))
              test:is("4713-01-02T19:32:07.123Z", date:format(format))
end)

test:test("sets milliseconds in day", date_test,
          function(test, date)
              test:plan(3)
              test:is(70327123, date:get(fields.MILLISECONDS_IN_DAY))
              date:set(fields.MILLISECONDS_IN_DAY, 1)
              test:is(1, date:get(fields.MILLISECONDS_IN_DAY))
              test:is("2017-10-12T00:00:00.001Z", date:format(format))
end)

test:test("sets is leap month", date_test,
          function(test, date)
              test:plan(3)
              test:is(0, date:get(fields.IS_LEAP_MONTH))
              date:set(fields.IS_LEAP_MONTH, 1)
              test:is(1, date:get(fields.IS_LEAP_MONTH))
              test:is("2017-10-12T19:32:07.123Z", date:format(format))
end)

test:test("sets day of month", date_test,
          function(test, date)
              test:plan(3)
              test:is(12, date:get(fields.DAY_OF_MONTH))
              date:set(fields.DAY_OF_MONTH, 1)
              test:is(1, date:get(fields.DAY_OF_MONTH))
              test:is("2017-10-01T19:32:07.123Z", date:format(format))
end)

os.exit(test:check() and 0 or 1)
