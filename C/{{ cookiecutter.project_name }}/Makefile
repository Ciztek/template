BUILD_DIR ?= .build

CFLAGS := -std=gnu17 -pedantic
CFLAGS += -iquote .

CFLAGS += -MMD -MP
CFLAGS += -O2

ifneq ($(EXPLICIT_FLAGS),1)
CFLAGS += @base_flags.txt
else
CFLAGS += $(shell cat base_flags.txt)
endif

LDFLAGS += -flto
LDLIBS ?=

include ./sourcelist.mk
vpath %.c $(VPATH)

# Hack to fixup the shell autocompletion by using dummy rules
auto-complete :=
$(if $(auto-complete),$(error this should not happen),)

ifdef auto-complete
# generated binaries
{{ cookiecutter.project_name }} debug check:

# from docs.mk:
pdf docs docs-clean docs-fclean docs-re:
endif

.PHONY: _start
_start: bundle

include ./makeincludes/mk-recipes.mk

UNIT := unittests

CFLAGS_@main += -DFOO=1

$(eval $(call mk-recipe-binary, release, SRC-OUT, ))

test-src := $(filter-out %main.c, $(SRC-OUT))
test-src += $(TST-OUT)
test-flags := -g3 --coverage -fprofile-arcs -iquote tests/include -lcriterion

$(eval $(call mk-recipe-binary, unittests, test-src, $(test-flags)))

debug-flags := -fanalyzer -DDEBUG=1
$(eval $(call mk-recipe-binary, debug, SRC-OUT, $(debug-flags)))

check-flags := $(debug-flags) -fsanitize=address,leak,undefined
$(eval $(call mk-recipe-binary, check, SRC-OUT, $(check-flags)))

.PHONY: all #? all: default, build the release binary
all: $(out-release)

.PHONY: bundle #? bundle: build all binaries
bundle: debug check all

.PHONY: tests_run #? tests_run: build and run the unit tests
tests_run: $(UNIT)
	$Q ./$(UNIT) -OP:F --full-stats

.PHONY: cov #? cov: run the tests and generate coverage report
cov: tests_run
	$Q gcovr . --object-directory .build/tests \
		--gcov-ignore-errors=no_working_dir_found \
		--exclude-unreachable-branches \
		--exclude tests \
		--exclude .direnv
	$Q gcovr . --object-directory .build/tests \
		--gcov-ignore-errors=no_working_dir_found \
		--exclude-unreachable-branches \
		--gcov-exclude tests \
		--gcov-exclude \.direnv \
		--txt-metric branch

.PHONY: clean
clean: #? clean: removes object files
	$Q $(RM) -r $(_clean)

.PHONY: fclean
fclean: clean #? fclean: remove binaries and object files
	$Q $(RM) -r $(_fclean)
	$Q $(RM) -r *.gcov.json.gz

.PHONY: mrproper
mrproper: fclean #? mrproper: remove all generated files
	$Q $(RM) -r $(BUILD_DIR)

.PHONY: help
help: #? help: Show this help message
	@ grep -P "#[?] " $(MAKEFILE_LIST)          \
	  | sed -E 's/.*#\? ([^:]+): (.*)/\1 "\2"/' \
	  | xargs printf "%-12s: %s\n"

include ./makeincludes/docs.mk

.PHONY: re
.NOTPARALLEL: re
re: fclean all #? re: rebuild the default target


include ./makeincludes/log-helper.mk
-include hook.mk
