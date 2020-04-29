#!/usr/bin/env tarantool
require('strict').on()

local icu_date = require('icu-date')
local tap = require('tap')

local test = tap.test("set milliseconds")
test:plan(1)

test:test("sets milliseconds", function(test)
              test:plan(4)
              local format = icu_date.formats.iso8601()
              local date = icu_date.new()
              date:set_millis(1507836727123)
              test:is("2017-10-12T19:32:07.123Z", date:format(format))
              test:is(1507836727123, date:get_millis())
              date:set_millis(1000)
              test:is(1000, date:get_millis())
              test:is("1970-01-01T00:00:01.000Z", date:format(format))
end)

os.exit(test:check() and 0 or 1)
