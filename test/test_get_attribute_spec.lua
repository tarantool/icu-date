#!/usr/bin/env tarantool
require('strict').on()

local icu_date = require('icu-date')
local tap = require('tap')

local test = tap.test("get attributes")
test:plan(5)

local function date_test(test, func)
    test:plan(2)

    local attributes = icu_date.attributes
    local date = icu_date.new()
    local format = icu_date.formats.iso8601()

    date:set_millis(1507836727123)
    test:ok("2017-10-12T19:32:07.123Z" == date:format(format))


    test:test("", func, date, attributes)
end

test:test("gets lenient", date_test,
          function(test, date, attributes)
              test:plan(1)
              test:ok(1 == date:get_attribute(attributes.LENIENT))
end)

test:test("gets first day of week", date_test,
          function(test, date, attributes)
              test:plan(1)
              test:ok(1 == date:get_attribute(attributes.FIRST_DAY_OF_WEEK))
end)

test:test("gets minimal days in first week", date_test,
          function(test, date, attributes)
              test:plan(1)
              test:ok(1 == date:get_attribute(attributes.MINIMAL_DAYS_IN_FIRST_WEEK))
end)

test:test("gets repeated wall time", date_test,
          function(test, date, attributes)
              test:plan(1)
              test:ok(0 == date:get_attribute(attributes.REPEATED_WALL_TIME))
end)

test:test("gets skipped wall time", date_test,
          function(test, date, attributes)
              test:plan(1)
              test:ok(0 == date:get_attribute(attributes.SKIPPED_WALL_TIME))
end)

os.exit(test:check() and 0 or 1)
