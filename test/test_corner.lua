#!/usr/bin/env tarantool
require('strict').on()

local icu_date = require('icu-date')
local tap = require('tap')

local test = tap.test("corner")
test:plan(11)

local d = icu_date.new()

local status, _ = pcall(function () d:format(nil) end)
test:isnt(true, status, "format(nil)")

local status, _ = pcall(function () d:set_time_zone_id(nil) end)
test:isnt(true, status, "set_time_zone_id(nil)")

local status, _ = pcall(function () d:get(nil) end)
test:isnt(true, status, "get(nil)")

local status, _ = pcall(function () d:set(nil) end)
test:isnt(true, status, "set(nil)")

local status, _ = pcall(function () d:add(nil, 123) end)
test:isnt(true, status, "add(nil, 123)")

local status, _ = pcall(function () d:clear_field(nil) end)
test:isnt(true, status, "clear_field(nil)")

local status, _ = pcall(function () d:get_attribute(nil) end)
test:isnt(true, status, "get_attribute(nil)")

local status, _ = pcall(function () d:set_attribute(nil, 123) end)
test:isnt(true, status, "set_attribute(nil, 123)")

local status, _ = pcall(function () d:parse(nil, nil, {}) end)
test:isnt(true, status, "parse(nil, nil, {})")

local status, _ = pcall(function () d:parse("adsd", "asdfasdf", {}) end)
test:isnt(true, status, "parse(\"adsd\", \"asdfasdf\", {})")

local status, _ = pcall(function () d:parse(nil, "", {}) end)
test:isnt(true, status, "parse(nil, \"\", {})")

os.exit(test:check() and 0 or 1)
