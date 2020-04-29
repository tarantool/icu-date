#!/usr/bin/env tarantool
require('strict').on()

local icu_date = require('icu-date')
local tap = require('tap')

local test = tap.test("set attribute")
test:plan(5)

local attributes = icu_date.attributes
local format = icu_date.formats.iso8601()

local function date_test(test, func)
    test:plan(2)

    local date = icu_date.new()

    date:set_millis(1507836727123)
    test:is("2017-10-12T19:32:07.123Z", date:format(format))

    test:test("", func, date)
end

test:test("sets lenient", date_test,
          function(test, date)
              test:plan(3)
              test:is(1, date:get_attribute(attributes.LENIENT))
              date:set_attribute(attributes.LENIENT, 0)
              test:is(0, date:get_attribute(attributes.LENIENT))
              test:is("2017-10-12T19:32:07.123Z", date:format(format))
end)

test:test("sets first day of week", date_test,
          function(test, date)
              test:plan(3)
              test:is(1, date:get_attribute(attributes.FIRST_DAY_OF_WEEK))
              date:set_attribute(attributes.FIRST_DAY_OF_WEEK, 2)
              test:is(2, date:get_attribute(attributes.FIRST_DAY_OF_WEEK))
              test:is("2017-10-12T19:32:07.123Z", date:format(format))
end)

test:test("sets minimal days in first week", date_test,
          function(test, date)
              test:plan(3)
              test:is(1, date:get_attribute(attributes.MINIMAL_DAYS_IN_FIRST_WEEK))
              date:set_attribute(attributes.MINIMAL_DAYS_IN_FIRST_WEEK, 2)
              test:is(2, date:get_attribute(attributes.MINIMAL_DAYS_IN_FIRST_WEEK))
              test:is("2017-10-12T19:32:07.123Z", date:format(format))
end)

test:test("sets repeated wall time", date_test,
          function(test, date)
              test:plan(3)
              test:is(0, date:get_attribute(attributes.REPEATED_WALL_TIME))
              date:set_attribute(attributes.REPEATED_WALL_TIME, 1)
              test:is(1, date:get_attribute(attributes.REPEATED_WALL_TIME))
              test:is("2017-10-12T19:32:07.123Z", date:format(format))
end)

test:test("sets skipped wall time", date_test,
          function(test, date)
              test:plan(3)
              test:is(0, date:get_attribute(attributes.SKIPPED_WALL_TIME))
              date:set_attribute(attributes.SKIPPED_WALL_TIME, 2)
              test:is(2, date:get_attribute(attributes.SKIPPED_WALL_TIME))
              test:is("2017-10-12T19:32:07.123Z", date:format(format))
end)

os.exit(test:check() and 0 or 1)
