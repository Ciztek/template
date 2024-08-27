BUILD_DIR ?= .build

CFLAGS := -std=gnu17 -pedantic
CFLAGS += -iquote .

CFLAGS += -MMD -MP
CFLAGS += -O2

CFLAGS += @base_flags.txt

LDFLAGS += -flto
LDLIBS ?=

include ./sourcelist.mk
vpath %.c $(VPATH)

# Hack to fixup the shell autocompletion by using dummy rules
auto-complete :=
$(if $(auto-complete),$(error this should not happen),)

ifdef auto-complete
# generated binaries
release debug check:

# from docs.mk:
pdf docs docs-clean docs-fclean docs-re:
endif

.PHONY: _start
_start: bundle

include ./makeincludes/mk-recipes.mk

CFLAGS_@main += -DFOO=1

$(eval $(call mk-recipe-binary, release, SRC-OUT, ))

debug-flags := -fanalyzer -DDEBUG=1
$(eval $(call mk-recipe-binary, debug, SRC-OUT, $(debug-flags)))

check-flags := $(debug-flags) -fsanitize=address,leak,undefined
$(eval $(call mk-recipe-binary, check, SRC-OUT, $(check-flags)))

.PHONY: all #? all: default, build the release binary
all: $(out-release)

.PHONY: bundle #? bundle: build all binaries
bundle: debug check all

.PHONY: clean
clean: #? clean: removes object files
	$Q $(RM) -r $(_clean)

.PHONY: fclean
fclean: clean #? fclean: remove binaries and object files
	$Q $(RM) -r $(_fclean)

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
