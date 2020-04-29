#!/usr/bin/env tarantool
require('strict').on()

local icu_date = require('icu-date')
local tap = require('tap')

local test = tap.test("now")
test:plan(1)

test:test("get current time", function(test)
              test:plan(1)
              local now = icu_date.now()
              test:is(type(now), 'number')
end)

os.exit(test:check() and 0 or 1)
