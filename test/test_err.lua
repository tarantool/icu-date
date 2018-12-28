#!/usr/bin/env tarantool
require('strict').on()

local icu_date = require('icu-date')
local tap = require('tap')

local test = tap.test("errors")
test:plan(3)

local date = icu_date.new()
local format = icu_date.formats.iso8601()
local rc, err = date:parse(format, "Non-Valid")
test:ok(err ~= nil, "Parsing non valid string")

local ok, err = pcall(icu_date.parse, '%Y-%m-%dT%H:%M:%S%z','2018-11-12 08:02:10')
test:ok(ok == false, "Incorrect usage of icu-date.parse function")
test:ok(err:endswith("Use date:parse(...) instead of date.parse(...)"), "Incorrect usage of icu-date.parse function. Error message")

return test:check()
