##
## EPITECH PROJECT, 2024
## arcade
## File description:
## Makefile
##

export START_TIME := $(shell date +%s%3N)
IMPORT = include $(1).mk

# ↓ `touch .fast` to force multi-threading
ifneq ($(shell find . -name ".fast"),)
    MAKEFLAGS += -j
endif

# ↓ Remove builtin rules
.SUFFIXES:

# ↓ Default target
all:

# ↓ Autocompletion hotfix
core: ## Compile arcade binary
graphicals: ## Compile graphical module binaries
games: ## Compile game module binaries
all: ## Compile game, graphical and core binaries

bundle: ## Compile all binaries

angry: ## Compile with asan lib (Google sanitizer)
debug: ## Compile with debug logs

clean: ## Remove generated objects
fclean: ## Remove any generated files
docs_clean: ## Remove generated documentation
docs_fclean: ## Remove generated documentation and pdf

tests_run: ## Run criterion tests
cov: ## Run a coverage report

re: ## fclean and recompile
docs: ## Generate doxygen documentation
pdf: ## Generate pdf documentation
help: ## Show this help

# ↓ pretty help
help:
	@ cat $(firstword $(MAKEFILE_LIST)) \
  	| grep -E "^\w+:\s##"               \
  	| sed "s/: ## /\t\t/g" | sort

.PHONY: help

# ↓ Auto import modules
MODULES := sources config logger utils
$(foreach m, $(MODULES),$(eval $(call IMPORT, makeincludes/$m)))

# ↓ Auto import rules
RULES := base compile debug angry unittests docs
$(foreach r, $(RULES),$(eval $(call IMPORT, makeincludes/rules/$r)))

# ↓ file & rules guard
SENTINEL = $(error Missing $(if $(findstring .,$(1)),file,rule) $(1))

# ↓ User override

ifneq ($(shell find . -name override.mk),)
-include override.mk
endif
