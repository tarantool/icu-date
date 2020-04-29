#!/usr/bin/env tarantool
require('strict').on()

local icu_date = require('icu-date')
local tap = require('tap')

local test = tap.test("clear_field")
test:plan(1)

test:test("clear date filed", function(test)
  test:plan(1)
  local date = icu_date.new{}
  date:clear_field(icu_date.fields.MILLISECOND)
  test:ok(0 == date:get(icu_date.fields.MILLISECOND))
end)

os.exit(test:check() and 0 or 1)
