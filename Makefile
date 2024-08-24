BUILD_DIR ?= .build

CFLAGS := -std=gnu17 -pedantic
CFLAGS += -iquote .

CFLAGS += -Wp,-U_FORTIFY_SOURCE
CFLAGS += -Wformat=2

CFLAGS += -MMD -MP
CFLAGS += -fanalyzer

CFLAGS += -O2

CFLAGS += -Wall -Wextra
CFLAGS += -Wcast-qual -Wconversion
CFLAGS += -Wduplicated-branches -Wduplicated-cond
CFLAGS += -fvisibility=hidden -Wmissing-prototypes -Wstrict-prototypes
CFLAGS += -Wwrite-strings
CFLAGS += -Wstrict-aliasing=0
CFLAGS += -Wshadow
CFLAGS += -Wunreachable-code

CFLAGS += -Werror=return-type
CFLAGS += -Werror=format-nonliteral

LDFLAGS += -flto
LDLIBS ?=

include ./sourcelist.mk
vpath %.c $(VPATH)

.PHONY: _start
_start: bundle

include ./mk-recipes.mk

CFLAGS_main += -DFOO=1

$(info $(SRC-OUT))

$(eval $(call mk-recipe-binary, release, SRC-OUT, ))
$(eval $(call mk-recipe-binary, debug, SRC-OUT, -DDEBUG=1))

.PHONY: bundle
bundle: debug all

all: $(out-release)

.PHONY: clean
clean:
	$(RM) -r $(_clean)

.PHONY: fclean
fclean: clean
	$(RM) -r $(_fclean)

mrproper: fclean
	$(RM) -r $(BUILD_DIR)

.PHONY: re
.NOTPARALLEL: re
re: fclean all

# ↓ `touch .fast` to force multi-threading
ifneq ($(shell find . -name ".fast"),)
    MAKEFLAGS += -j
endif

V ?= 0
ifneq ($(V),0)
  Q :=
else
  Q := @
endif

RM ?= rm -f
AR ?= ar

ifneq ($(shell command -v tput),)
  ifneq ($(shell tput colors),0)

mk-color = \e[$(strip $1)m

C_BEGIN := \033[A
C_RESET := $(call mk-color, 00)

C_RED := $(call mk-color, 31)
C_GREEN := $(call mk-color, 32)
C_YELLOW := $(call mk-color, 33)
C_BLUE := $(call mk-color, 34)
C_PURPLE := $(call mk-color, 35)
C_CYAN := $(call mk-color, 36)

  endif
endif

NOW = $(shell date +%s%3N)
STIME := $(call NOW)
TIME_NS = $(shell expr $(call NOW) - $(STIME))
TIME_MS = $(shell expr $(call TIME_NS))

BOXIFY = "[$(C_BLUE)$(1)$(C_RESET)] $(2)"

ifneq ($(shell command -v printf),)
  LOG_TIME = printf $(call BOXIFY, %6s , %b\n) "$(call TIME_MS)"
else
  LOG_TIME = echo -e $(call BOXIFY, $(call TIME_MS) ,)
endif

-include hook.mk
