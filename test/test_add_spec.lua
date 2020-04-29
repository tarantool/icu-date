#!/usr/bin/env tarantool
require('strict').on()

local icu_date = require('icu-date')
local tap = require('tap')

local test = tap.test("add")
test:plan(3)

local function date_test(test, func)
    test:plan(2)
    local fields = icu_date.fields
    local date = icu_date.new()
    local format = icu_date.formats.iso8601()

    date:set_millis(1507836727123)
    test:ok("2017-10-12T19:32:07.123Z" == date:format(format))


    test:test("", func, date, fields, format)
end

test:test("adds different fields", date_test,
          function (test, date, fields, format)
              test:plan(2)
              date:add(fields.YEAR, 1)
              test:ok("2018-10-12T19:32:07.123Z" == date:format(format))

              date:add(fields.MONTH, 1)
              test:ok("2018-11-12T19:32:07.123Z" == date:format(format))
end)

test:test("subtracts negative values", date_test,
          function (test, date, fields, format)
              test:plan(2)
              date:add(fields.YEAR, -1)
              test:ok("2016-10-12T19:32:07.123Z" == date:format(format))

              date:add(fields.MONTH, -1)
              test:ok("2016-09-12T19:32:07.123Z" == date:format(format))
end)

test:test("wraps values", date_test,
          function(test, date, fields, format)
              test:plan(1)
              date:add(fields.MONTH, 3)
              test:ok("2018-01-12T19:32:07.123Z" == date:format(format))
end)

os.exit(test:check() and 0 or 1)
