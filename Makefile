.PHONY: lint
lint:
	luacheck --config=.luacheckrc --no-unused-args --no-redefined \
	                    ./icu-date.lua ./unit.lua ./test ./icu-date

.PHONY: test
test:
	./unit.lua

.PHONY: build
build:
	tarantoolctl rocks make

all: build
