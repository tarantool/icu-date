#!/usr/bin/env tarantool
require('strict').on()

local icu_date = require('icu-date')
local tap = require('tap')

local test = tap.test("parse")
test:plan(7)

test:test("parses iso8601 date and time", function(test)
              test:plan(2)
              local date = icu_date.new()
              local format = icu_date.formats.iso8601()
              date:parse(format, "2016-10-12T19:32:07.123Z")
              test:is("2016-10-12T19:32:07.123Z", date:format(format))
              test:is(1476300727123, date:get_millis())
end)

test:test("parses iso8601 date and time when year and week year differ",
          function(test)
              test:plan(4)
              local date = icu_date.new()
              local format = icu_date.formats.iso8601()
              date:parse(format, "2014-12-31T00:00:00.000Z")
              test:is("2014", date:format(icu_date.formats.pattern("yyyy")))
              test:is("2015", date:format(icu_date.formats.pattern("YYYY")))
              test:is("2014-12-31T00:00:00.000Z", date:format(format))
              test:is(1419984000000, date:get_millis())
end)

test:test("parses iso8601 date", function(test)
              test:plan(2)
              local date = icu_date.new()
              local format = icu_date.formats.pattern("yyyy-MM-dd")
              date:parse(format, "2016-10-12")
              test:is("2016-10-12", date:format(format))
              test:is(1476230400000, date:get_millis())
end)

test:test("parses time zone aware", function(test)
              test:plan(2)
              local date = icu_date.new({ zone_id = "America/Denver" })
              local format = icu_date.formats.pattern("yyyy-MM-dd'T'HH")
              date:parse(format, "2016-10-12T19")
              test:is("2016-10-12T19", date:format(format))
              test:is(1476320400000, date:get_millis())
end)

test:test("defaults to clearing date", function(test)
              test:plan(2)
              local date = icu_date.new()
              date:set_millis(1507836727123)
              test:is("2017-10-12T19:32:07.123Z", date:format(icu_date.formats.iso8601()))

              local format = icu_date.formats.pattern("yyyy-MM-dd")
              date:parse(format, "2016-09-18")
              test:is("2016-09-18T00:00:00.000Z", date:format(icu_date.formats.iso8601()))
end)

test:test("can disable clearing date", function(test)
              test:plan(2)
              local date = icu_date.new()
              date:set_millis(1507836727123)
              test:is("2017-10-12T19:32:07.123Z", date:format(icu_date.formats.iso8601()))

              local format = icu_date.formats.pattern("yyyy-MM-dd")
              date:parse(format, "2016-09-18", { clear = false })
              test:is("2016-09-18T19:32:07.123Z", date:format(icu_date.formats.iso8601()))
end)

--[[
    By default, parsing is lenient: If the input is not in the form used by
    this object's format method but can still be parsed as a date, then the
    parse succeeds. Clients may insist on strict adherence to the format by
    calling setLenient(false).
    https://github.com/unicode-org/icu/blob/master/icu4c/source/i18n/unicode/datefmt.h
--]]
test:test("parsing is not lenient",
          function(test)
              test:plan(4)
              local date = icu_date.new()
              local format1 = icu_date.formats.pattern("yyyy-MM-dd")
              local ok, err = date:parse(format1, "2016-13-18")
              test:is(ok, nil)
              test:is(err, 'Invalid status: "U_PARSE_ERROR". Result: "nil"')
              local format2 = icu_date.formats.pattern('yyyyMMdd\'T\'HHmmss')
              local ok, err = date:parse(format2, "q2020-50-50")
              test:is(ok, nil)
              test:is(err, 'Invalid status: "U_PARSE_ERROR". Result: "nil"')
end)

os.exit(test:check() and 0 or 1)
