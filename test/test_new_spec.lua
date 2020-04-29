#!/usr/bin/env tarantool
require('strict').on()

local icu_date = require('icu-date')
local tap = require('tap')

local test = tap.test("new")
test:plan(2)

test:test("creates new instance", function(test)
              test:plan(1)
              local date = icu_date.new()
              test:isnt(date, nil)
end)

test:test("accepts zone_id", function(test)
              test:plan(1)
              local format = icu_date.formats.iso8601()
              local date = icu_date.new({ zone_id = "America/Denver" })
              date:set_millis(1507836727123)
              test:is("2017-10-12T13:32:07.123-06:00", date:format(format))
end)

os.exit(test:check() and 0 or 1)
