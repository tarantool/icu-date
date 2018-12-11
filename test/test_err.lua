#!/usr/bin/env tarantool
require('strict').on()

local icu_date = require('icu-date')
local tap = require('tap')

local test = tap.test("add")
test:plan(1)

local date = icu_date.new()
local format = icu_date.formats.iso8601()
local rc, err = date:parse(format, "Non-Valid")
test:ok(err~=nil, "Parsing non valid string")

return test:check()
