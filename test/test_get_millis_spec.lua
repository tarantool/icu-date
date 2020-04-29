#!/usr/bin/env tarantool
require('strict').on()

local icu_date = require('icu-date')
local tap = require('tap')

local test = tap.test("get milliseconds")
test:plan(1)

local function date_test(test, func)
    test:plan(2)

    local date = icu_date.new()
    local format = icu_date.formats.iso8601()

    date:set_millis(1507836727123)
    test:ok("2017-10-12T19:32:07.123Z" == date:format(format))

    test:test("", func, date)
end


test:test("gets milliseconds", date_test,
          function(test, date)
              test:plan(1)
              test:ok(1507836727123 == date:get_millis())
end)

os.exit(test:check() and 0 or 1)
