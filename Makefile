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

.PHONY: _start
_start: bundle

include ./makeincludes/mk-recipes.mk

CFLAGS_@main += -DFOO=1

$(eval $(call mk-recipe-binary, release, SRC-OUT, ))

debug-flags := -fanalyzer -DDEBUG=1
$(eval $(call mk-recipe-binary, debug, SRC-OUT, debug-flags))

check-flags := $(debug-flags) -fsanitize=address,leak,undefined
$(eval $(call mk-recipe-binary, check, SRC-OUT, check-flags))

.PHONY: bundle
bundle: debug check all

all: $(out-release)

.PHONY: clean
clean:
	$Q $(RM) -r $(_clean)

.PHONY: fclean
fclean: clean
	$Q $(RM) -r $(_fclean)

.PHONY: mrproper
mrproper: fclean
	$Q $(RM) -r $(BUILD_DIR)


# auto-completion fix:
pdf docs docs-clean docs-fclean docs-re:

include ./makeincludes/docs.mk

.PHONY: re
.NOTPARALLEL: re
re: fclean all

include ./makeincludes/log-helper.mk
-include hook.mk
