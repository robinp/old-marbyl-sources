.PHONY: all clean debug release

haxedep := ../@HAXEDEP@
build_deps := build.hxml.deps

all: marbyl.swf

clean:
	@rm -f marbyl.swf $(build_deps)

debug: marbyl.swf
ifneq "no" "no"
	no marbyl.swf
endif

release: marbyl.swf
ifneq "no" "no"
	no marbyl.swf
endif

marbyl.swf: ../res/sprites.xml build.hxml $(shell cat $(build_deps))
	@echo Building marbyl.swf...
	@/usr/bin/xmllint --valid --noout ../res/sprites.xml
	@/usr/bin/haxe -v build.hxml > $(build_deps).temp
	@gawk '/^Parsed/{print $$2}' $(build_deps).temp > $(build_deps)
	@rm $(build_deps).temp

